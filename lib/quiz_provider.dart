import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/result_screen.dart'; // Ensure this path is correct

class QuizProvider with ChangeNotifier {
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = false;
  int _currentQuestionIndex = 0;
  final Map<int, String> _selectedAnswers = {};
  int _score = 0;
  bool _quizCompleted = false;

  List<Map<String, dynamic>> get questions => _questions;
  bool get isLoading => _isLoading;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<int, String> get selectedAnswers => _selectedAnswers;
  int get score => _score;
  bool get quizCompleted => _quizCompleted;

  Future<void> fetchQuestions(String topic) async {
    const String apiKey = 'Your Api Key Here';
    const String apiUrl =
        'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey';

    debugPrint("Fetching questions for topic: $topic");

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": """
Generate exactly 10 multiple-choice questions on the topic '$topic'.
Format them as follows:
**Question 1:** What is the capital of France?
(a) Berlin
(b) Madrid
(c) Paris
(d) Rome
**Answer: c**

**Question 2:** What is 2 + 2?
(a) 3
(b) 4
(c) 5
(d) 6
**Answer: b**

Ensure every question follows this exact format.
"""
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("API Response: ${response.body}"); // 🔥 Debugging

        if (data.containsKey('candidates')) {
          final generatedText =
              data['candidates'][0]['content']['parts'][0]['text'];
          debugPrint("Generated Text: $generatedText"); // 🔥 Debugging

          List<Map<String, dynamic>> parsedQuestions =
              parseQuestions(generatedText);

          if (parsedQuestions.isNotEmpty) {
            _questions = parsedQuestions;
            _currentQuestionIndex = 0;
            _selectedAnswers.clear();
            _score = 0;
            _quizCompleted = false;

            debugPrint("Parsed Questions: $_questions");
            notifyListeners();
          } else {
            debugPrint("No valid questions parsed.");
          }
        } else {
          debugPrint("Invalid response format");
        }
      } else {
        debugPrint("Failed to fetch questions: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching questions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> parseQuestions(String generatedText) {
    List<Map<String, dynamic>> questions = [];
    List<String> lines = generatedText.split('\n');

    String? question;
    List<String> options = [];
    String? correctAnswer;

    RegExp questionPattern = RegExp(r'^\*\*Question\s\d+:\*\*\s*(.+)');
    RegExp optionPattern = RegExp(r'^\((a|b|c|d)\)\s(.+)');
    RegExp answerPattern = RegExp(r'^\*\*Answer:\s([a-d])\*\*');

    for (String line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      Match? questionMatch = questionPattern.firstMatch(line);
      if (questionMatch != null) {
        if (question != null && options.length == 4 && correctAnswer != null) {
          questions.add({
            "question": question,
            "options": List<String>.from(options),
            "correctAnswer": correctAnswer,
          });
        }

        question = questionMatch.group(1);
        options = [];
        correctAnswer = null;
        continue;
      }

      Match? optionMatch = optionPattern.firstMatch(line);
      if (optionMatch != null) {
        options.add(line);
        continue;
      }

      Match? answerMatch = answerPattern.firstMatch(line);
      if (answerMatch != null) {
        String correctOpt = answerMatch.group(1)!;
        correctAnswer = options.firstWhere(
          (opt) => opt.startsWith("($correctOpt)"),
          orElse: () => "",
        );
      }
    }

    if (question != null && options.length == 4 && correctAnswer != null) {
      questions.add({
        "question": question,
        "options": List<String>.from(options),
        "correctAnswer": correctAnswer,
      });
    }

    debugPrint("Parsed Questions: $questions");
    return questions;
  }

  void selectAnswer(int questionIndex, String answer) {
    _selectedAnswers[questionIndex] = answer;
    notifyListeners();
  }

  void nextQuestion(BuildContext context) {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _quizCompleted = true;
      calculateScore();
      navigateToResultScreen(
          context); // ✅ Navigate to result screen when finished
    }
    notifyListeners();
  }

  void calculateScore() {
    _score = 0;
    for (var i = 0; i < _questions.length; i++) {
      debugPrint(
          "Q${i + 1}: Selected '${_selectedAnswers[i]}' | Correct '${_questions[i]['correctAnswer']}'");

      if (_selectedAnswers[i] == _questions[i]['correctAnswer']) {
        _score++;
      }
    }
    debugPrint("Final Score: $_score/${_questions.length}");
    notifyListeners();
  }

  void navigateToResultScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          correctAnswers: _score,
          totalQuestions: _questions.length,
        ),
      ),
    );
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _score = 0;
    _quizCompleted = false;
    notifyListeners();
  }
}
