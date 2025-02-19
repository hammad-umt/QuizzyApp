import 'package:flutter/material.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    double scorePercentage = (correctAnswers / totalQuestions) * 100;
    String message = scorePercentage >= 80
        ? "🎉 Excellent!"
        : scorePercentage >= 50
            ? "😊 Good Job!"
            : "😕 Keep Practicing!";

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Trophy
                  const AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(seconds: 2),
                    child: Icon(
                      Icons.emoji_events,
                      size: 100,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Score Message
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Score Details
                  Text(
                    'You got $correctAnswers out of $totalQuestions correct!',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Score Progress Bar
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: correctAnswers / totalQuestions,
                      minHeight: 10,
                      backgroundColor: Colors.white24,
                      color: Colors.amberAccent,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Home Button with Stylish Animation
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                      backgroundColor: Colors.amberAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: Colors.black45,
                      elevation: 8,
                    ),
                    child: const Text(
                      '🏠 Back to Home',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
