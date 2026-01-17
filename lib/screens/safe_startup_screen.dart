import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masteryquiz/screens/onboarding_screen.dart';
import 'package:masteryquiz/screens/welcome_screen.dart';

class SafeStartupScreen extends StatefulWidget {
  const SafeStartupScreen({super.key});

  @override
  State<SafeStartupScreen> createState() => _SafeStartupScreenState();
}

class _SafeStartupScreenState extends State<SafeStartupScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  Future<void> _checkUserAndNavigate() async {
    // Add a small delay to ensure UI is ready
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      User? user = FirebaseAuth.instance.currentUser;
      
      if (!mounted) return;
      
      // Navigate based on auth state
      if (user != null) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } else {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } catch (e) {
      print('Navigation error: $e');
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Color(0xFF6366F1),
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'MasteryQuiz',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 32),
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Color(0xFF6366F1),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
