import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/result_screen.dart';
import 'main.dart';

class QuizProvider with ChangeNotifier {
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = false;
  int _currentQuestionIndex = 0;
  final Map<int, String> _selectedAnswers = {};
  final Map<int, bool> _answerFeedback = {}; // Track if answer is correct
  final List<Map<String, dynamic>> _wrongAnswers = []; // Store wrong answers
  int _score = 0;
  bool _quizCompleted = false;
  
  // Timer properties
  Timer? _questionTimer;
  int _secondsRemaining = 60;
  bool _timeOut = false;

  List<Map<String, dynamic>> get questions => _questions;
  bool get isLoading => _isLoading;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<int, String> get selectedAnswers => _selectedAnswers;
  Map<int, bool> get answerFeedback => _answerFeedback;
  List<Map<String, dynamic>> get wrongAnswers => _wrongAnswers;
  int get score => _score;
  bool get quizCompleted => _quizCompleted;
  int get secondsRemaining => _secondsRemaining;
  bool get timeOut => _timeOut;

  Future<void> fetchQuestions(String topic) async {
    const String apiKey = 'AIzaSyDbp_Nd9GH6KEzNEEWvmG4GgI3jD26TEU0';
    const String apiUrl =
        'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey';

    debugPrint("========== Starting Quiz Fetch ==========");
    debugPrint("Topic: $topic");
    debugPrint("API URL: $apiUrl");

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "contents": [
                {
                  "parts": [
                    {
                      "text": 'Generate exactly 10 multiple-choice questions on "$topic". '
                          'For EACH question, use this EXACT format with NO variations: '
                          '**Question 1:** [question text here]? '
                          '(a) [option a] '
                          '(b) [option b] '
                          '(c) [option c] '
                          '(d) [option d] '
                          'Answer: [single letter a/b/c/d] '
                          'Then repeat for Questions 2-10. '
                          'Put each question, its 4 options, and its answer on separate lines. '
                          'Make sure EVERY question has an Answer line. '
                          'Do NOT add anything before Question 1 or after Question 10.'
                    }
                  ]
                }
              ]
            }),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint("✓ Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        debugPrint("✓ API returned 200 OK");
        final data = jsonDecode(response.body);

        if (data.containsKey('candidates') &&
            (data['candidates'] as List).isNotEmpty) {
          debugPrint("✓ Found candidates in response");

          try {
            final generatedText =
                data['candidates'][0]['content']['parts'][0]['text'];
            debugPrint("Generated text length: ${generatedText.length}");

            List<Map<String, dynamic>> parsedQuestions =
                parseQuestions(generatedText);
            debugPrint("Parsed ${parsedQuestions.length} questions");

            if (parsedQuestions.isNotEmpty) {
              _questions = parsedQuestions;
              _currentQuestionIndex = 0;
              _selectedAnswers.clear();
              _answerFeedback.clear();
              _wrongAnswers.clear();
              _score = 0;
              _quizCompleted = false;
              startQuestionTimer(); // Start timer for first question
              debugPrint("✓ Successfully loaded ${_questions.length} questions");
              debugPrint("✓ Timer started for first question");

            } else {
              debugPrint("✗ Parsing returned 0 questions");
              _showSampleQuestions(topic);
            }
          } catch (e) {
            debugPrint("✗ Error extracting text: $e");
            _showSampleQuestions(topic);
          }
        } else {
          debugPrint("✗ No candidates in response");
          _showSampleQuestions(topic);
        }
      } else {
        debugPrint("✗ API returned ${response.statusCode}");
        debugPrint("Error: ${response.body}");
        _showSampleQuestions(topic);
      }
    } on TimeoutException catch (e) {
      debugPrint("✗ Request timeout: $e");
      _showSampleQuestions(topic);
    } catch (e) {
      debugPrint("✗ Exception: $e");
      _showSampleQuestions(topic);
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint("========== Fetch Complete ==========");
    }
  }

  void _showSampleQuestions(String topic) {
    // Fallback: Show sample questions if API fails
    debugPrint("Using sample questions as fallback for topic: $topic");
    _questions = [
      {
        "question": "What is the capital of France?",
        "options": ["(a) Berlin", "(b) Madrid", "(c) Paris", "(d) Rome"],
        "correctAnswer": "(c) Paris"
      },
      {
        "question": "What is 2 + 2?",
        "options": ["(a) 3", "(b) 4", "(c) 5", "(d) 6"],
        "correctAnswer": "(b) 4"
      },
      {
        "question": "Which planet is closest to the sun?",
        "options": ["(a) Venus", "(b) Mercury", "(c) Earth", "(d) Mars"],
        "correctAnswer": "(b) Mercury"
      },
      {
        "question": "What is the largest ocean?",
        "options": ["(a) Atlantic", "(b) Indian", "(c) Arctic", "(d) Pacific"],
        "correctAnswer": "(d) Pacific"
      },
      {
        "question": "What is the chemical symbol for Gold?",
        "options": ["(a) Go", "(b) Gd", "(c) Au", "(d) Ag"],
        "correctAnswer": "(c) Au"
      },
    ];
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _score = 0;
    _quizCompleted = false;
    debugPrint("Sample questions loaded: ${_questions.length} questions");
    notifyListeners();
  }

  List<Map<String, dynamic>> parseQuestions(String generatedText) {
    List<Map<String, dynamic>> questions = [];
    debugPrint("Parsing text of length: ${generatedText.length}");

    // Split by question pattern
    List<String> lines = generatedText.split('\n');
    debugPrint("Total lines: ${lines.length}");

    String? currentQuestion;
    List<String> currentOptions = [];
    String? currentAnswer;
    List<String> answerCandidates = [];

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      
      if (line.isEmpty) continue;

      // Check for question
      if (line.contains('**Question') || line.contains('Question')) {
        // Save previous question if complete
        if (currentQuestion != null && currentOptions.length == 4) {
          // Try to find answer from candidates
          if (currentAnswer == null && answerCandidates.isNotEmpty) {
            for (String candidate in answerCandidates) {
              Match? answerMatch = RegExp(r'[Aa]nswer\s*:?\s*\(?([a-d])\)?').firstMatch(candidate);
              if (answerMatch != null) {
                String answerLetter = answerMatch.group(1)!;
                for (String opt in currentOptions) {
                  if (opt.startsWith('($answerLetter)')) {
                    currentAnswer = opt;
                    break;
                  }
                }
                if (currentAnswer != null) break;
              }
            }
          }

          if (currentAnswer != null) {
            questions.add({
              "question": currentQuestion,
              "options": currentOptions,
              "correctAnswer": currentAnswer,
            });
            debugPrint("✓ Saved question: $currentQuestion");
          }
        }

        // Start new question
        currentQuestion = line.replaceAll(RegExp(r'^\*\*Question\s*\d+:\*\*\s*'), '');
        currentOptions = [];
        currentAnswer = null;
        answerCandidates = [];
        debugPrint("Found question: $currentQuestion");
      }
      // Check for option
      else if (RegExp(r'^\(([a-d])\)').hasMatch(line)) {
        currentOptions.add(line);
        debugPrint("  Added option: $line");
      }
      // Check for answer - look for multiple patterns
      else if (RegExp(r'[Aa]nswer').hasMatch(line)) {
        answerCandidates.add(line);
        Match? match = RegExp(r'[Aa]nswer\s*:?\s*\(?([a-d])\)?').firstMatch(line);
        if (match != null && currentOptions.length == 4) {
          String answerLetter = match.group(1)!;
          for (String opt in currentOptions) {
            if (opt.startsWith('($answerLetter)')) {
              currentAnswer = opt;
              debugPrint("  Found answer: $currentAnswer");
              break;
            }
          }
        }
      }
    }

    // Add last question
    if (currentQuestion != null && currentOptions.length == 4) {
      if (currentAnswer == null && answerCandidates.isNotEmpty) {
        for (String candidate in answerCandidates) {
          Match? answerMatch = RegExp(r'[Aa]nswer\s*:?\s*\(?([a-d])\)?').firstMatch(candidate);
          if (answerMatch != null) {
            String answerLetter = answerMatch.group(1)!;
            for (String opt in currentOptions) {
              if (opt.startsWith('($answerLetter)')) {
                currentAnswer = opt;
                break;
              }
            }
            if (currentAnswer != null) break;
          }
        }
      }

      if (currentAnswer != null) {
        questions.add({
          "question": currentQuestion,
          "options": currentOptions,
          "correctAnswer": currentAnswer,
        });
        debugPrint("✓ Saved final question: $currentQuestion");
      }
    }

    debugPrint("Total questions parsed: ${questions.length}");
    return questions;
  }

  void selectAnswer(int questionIndex, String answer) {
    // Store the full option text selected by user
    _selectedAnswers[questionIndex] = answer;
    debugPrint("✓ Selected answer for Q${questionIndex + 1}: '$answer'");
    
    // Check if answer is correct
    String correctAnswer = _questions[questionIndex]['correctAnswer'];
    bool isCorrect = answer == correctAnswer;
    debugPrint("  Comparing with correct answer: '$correctAnswer'");
    debugPrint("  Is Correct: $isCorrect");
    
    _answerFeedback[questionIndex] = isCorrect;
    
    // Track wrong answers for history
    if (!isCorrect) {
      _wrongAnswers.add({
        'questionIndex': questionIndex,
        'question': _questions[questionIndex]['question'],
        'selectedAnswer': answer,
        'correctAnswer': correctAnswer,
        'options': _questions[questionIndex]['options'],
      });
    }
    
    notifyListeners();
  }

  void startQuestionTimer() {
    _stopTimer();
    _secondsRemaining = 60;
    _timeOut = false;
    
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _stopTimer();
        _timeOut = true;
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _questionTimer?.cancel();
    _questionTimer = null;
  }

  void nextQuestion(BuildContext context) {
    _stopTimer();
    _timeOut = false;
    
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      startQuestionTimer();
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
    debugPrint("========== Calculating Score ==========");
    for (var i = 0; i < _questions.length; i++) {
      String? selected = _selectedAnswers[i];
      String correct = _questions[i]['correctAnswer'];
      
      debugPrint("Q${i + 1}:");
      debugPrint("  Selected: '$selected'");
      debugPrint("  Correct:  '$correct'");
      
      if (selected != null && selected == correct) {
        _score++;
        debugPrint("  ✓ CORRECT");
      } else {
        debugPrint("  ✗ WRONG or NOT ANSWERED");
      }
    }
    debugPrint("Final Score: $_score/${_questions.length} (${(_score / _questions.length * 100).toStringAsFixed(1)}%)");
    debugPrint("========== Score Calculation Complete ==========");
    notifyListeners();
  }

  void navigateToResultScreen(BuildContext context) {
    _stopTimer();
    Navigator.pushReplacement(
      context,
      FadingPageTransition(
        page: ResultScreen(
          correctAnswers: _score,
          totalQuestions: _questions.length,
        ),
      ),
    );
  }

  void resetQuiz() {
    _stopTimer();
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _answerFeedback.clear();
    _wrongAnswers.clear();
    _score = 0;
    _quizCompleted = false;
    _secondsRemaining = 60;
    _timeOut = false;
    notifyListeners();
  }
}
