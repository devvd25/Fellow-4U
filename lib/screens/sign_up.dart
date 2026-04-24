import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../core/widgets.dart';
import 'sign_in.dart';
import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _roleValue = 0; // 0: Traveler, 1: Guide
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // Validate inputs
    if (_firstNameController.text.trim().isEmpty) {
      _showError('Please enter your first name');
      return;
    }
    if (_lastNameController.text.trim().isEmpty) {
      _showError('Please enter your last name');
      return;
    }
    if (_countryController.text.trim().isEmpty) {
      _showError('Please enter your country');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }
    if (!_emailController.text.contains('@')) {
      _showError('Please enter a valid email');
      return;
    }
    if (_passwordController.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Save user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', _firstNameController.text.trim());
      await prefs.setString('lastName', _lastNameController.text.trim());
      await prefs.setString('country', _countryController.text.trim());
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('password', _passwordController.text);
      await prefs.setString('role', _roleValue == 0 ? 'Traveler' : 'Guide');
      await prefs.setBool('isLoggedIn', true);

      setState(() => _isLoading = false);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to main screen
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('An error occurred. Please try again.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CurvedHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Radio Buttons
                  Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: _roleValue,
                        activeColor: primaryColor,
                        onChanged: (val) =>
                            setState(() => _roleValue = val as int),
                      ),
                      const Text(
                        'Traveler',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: 1,
                        groupValue: _roleValue,
                        activeColor: primaryColor,
                        onChanged: (val) =>
                            setState(() => _roleValue = val as int),
                      ),
                      const Text(
                        'Guide',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          labelText: 'First Name',
                          hintText: 'Yoo',
                          controller: _firstNameController,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomTextField(
                          labelText: 'Last Name',
                          hintText: 'Jin',
                          controller: _lastNameController,
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    labelText: 'Country',
                    hintText: 'Country',
                    controller: _countryController,
                  ),
                  CustomTextField(
                    labelText: 'Email',
                    hintText: 'Type email',
                    controller: _emailController,
                  ),
                  CustomTextField(
                    labelText: 'Password',
                    hintText: 'Type password',
                    isPassword: true,
                    helperText: 'Password has more than 6 letters',
                    controller: _passwordController,
                  ),
                  CustomTextField(
                    labelText: 'Confirm Password',
                    hintText: '••••••',
                    isPassword: true,
                    controller: _confirmPasswordController,
                  ),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'By Signing Up, you agree to our ',
                        style: const TextStyle(color: hintColor, fontSize: 11),
                        children: const [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : PrimaryButton(text: 'SIGN UP', onPressed: _signUp),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: hintColor, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
