import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart'; // Import your ApiService
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '61');
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _selectedGender;

  // Function to generate a random 6-digit authentication code
  String _generateAuthCode() {
    var rng = Random();
    return (rng.nextInt(900000) + 100000)
        .toString(); // Generates a number between 100000 and 999999
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate() && _selectedGender != null) {
      setState(() => _isLoading = true);

      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();
      final cCode = _countryCodeController.text.trim();
      final authCode = _generateAuthCode(); // Generate the random 6-digit code
      final apiService = ApiService(); // Create an instance of ApiService

      try {
        final response = await apiService.signup(
          firstName: firstName,
          lastName: lastName,
          gender: _selectedGender!,
          countryCode: cCode,
          phone: phone,
          email: email,
          password: password,
          refCode: null, // Optional, pass null if not used
        );

        setState(() => _isLoading = false);

        // Handle the response
        if (response['error'] == false) {
          // Show success message
          Fluttertoast.showToast(
            msg: 'Signup successful! Now logging you in...',
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          // Save user data in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', response['user']['id']);
          await prefs.setString('firstName', firstName);
          await prefs.setString('lastName', lastName);
          await prefs.setString('email', email);
          await prefs.setString('phone', phone);

          // Navigate to the home screen after successful signup
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const HomeScreen(), // Adjust according to your needs
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: response['message'] ?? 'Signup failed',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } else if (_selectedGender == null) {
      Fluttertoast.showToast(
        msg: 'Please select your gender',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildNameFields(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 16),
                _buildGenderField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildSignupButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your first name';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your last name';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your email';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Phone',
        prefixIcon: Icon(Icons.phone_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your phone number';
        }
        return null;
      },
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      value: _selectedGender,
      items: const [
        DropdownMenuItem(
          value: 'Male',
          child: Text('Male'),
        ),
        DropdownMenuItem(
          value: 'Female',
          child: Text('Female'),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Select your gender';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildSignupButton() {
    return ElevatedButton(
      onPressed: _signup,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A4A4A),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text(
              'Sign Up',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
