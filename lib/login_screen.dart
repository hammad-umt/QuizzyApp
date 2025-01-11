// ignore_for_file: deprecated_member_use, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:quizzy/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzy/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false; // State to toggle password visibility
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
      return;
    }

    try {
      // Sign in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If successful, navigate to the home screen
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Center(child: Text("Welcome!"))),
        );
      }
    } catch (e) {
      // Handle error if sign-in fails
      print("Sign-in failed: $e"); // Detailed error log for debugging

      String errorMessage = "Failed to sign in: Please try again later.";

      if (e is FirebaseAuthException) {
        // Firebase error handling for specific cases
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "No user found for that email.";
            break;
          case 'wrong-password':
            errorMessage = "Wrong password provided for that user.";
            break;
          case 'invalid-email':
            errorMessage = "The email address is not valid.";
            break;
          case 'too-many-requests':
            errorMessage = "Too many requests. Try again later.";
            break;
          default:
            errorMessage = e.message ?? "Unknown error occurred.";
        }
      }

      // Show the error message in a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Center(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Align items horizontally
            children: [
              const Text(
                'Login Here',
                style: TextStyle(
                  color: Color(0xFF1F41BB),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back!, You\'ve \n been missed.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _passwordController,
                  obscureText:
                      !_isPasswordVisible, // Toggle password visibility
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                              !_isPasswordVisible; // Toggle state
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: signIn, // Call the signIn function
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF1F41BB)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()),
                    );
                  },
                  child: const Text('Create Account'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor:
                        MaterialStateProperty.all(const Color(0xFF1F41BB)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
