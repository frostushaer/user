import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';
  String _successMessage = '';

  void _sendResetLink() async {
    final String email = _emailController.text;

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email.';
        _successMessage = '';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('https://xjwmobilemassage.com.au/app/api.php'),
      body: {
        'action': 'forget_password_request',
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['error']) {
        setState(() {
          _errorMessage = responseBody['message'];
          _successMessage = '';
        });
      } else {
        setState(() {
          _successMessage = 'Password reset link sent to your email.';
          _errorMessage = '';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Failed to send reset link. Please try again later.';
        _successMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendResetLink,
                child: const Text('Send Reset Link'),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (_successMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    _successMessage,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
