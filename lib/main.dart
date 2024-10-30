import 'package:flutter/material.dart';
import 'dart:async'; // Import this for the Timer
import 'screens/login_screen.dart'; // Import your login screen
import 'screens/signup_screen.dart'; // Import your signup screen
import 'screens/forgot_password_screen.dart'; // Import your forgot password screen
import 'screens/home_screen.dart'; // Import your home screen

void main() {
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
      initialRoute: '/', // Set initial route
      routes: {
        '/': (context) => const SplashScreen(), // Set SplashScreen as the home
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to LoginScreen after a delay
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Text(
          'Welcome to My App',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
