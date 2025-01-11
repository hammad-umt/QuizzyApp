import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizzy/onboarding_screen.dart'; // Your onboarding screen import
import 'firebase_options.dart'; // Make sure this is generated correctly

void main() async {
  // Ensures Flutter is fully initialized before calling async code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Ensure correct Firebase options are used
  );

  // Run the app after Firebase initialization is complete
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(), // Your onboarding screen here
    );
  }
}
