import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/widgets.dart';
import '../core/api_service.dart';
import 'sign_in.dart';
import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _roleValue = 0;

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
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (!email.contains('@')) {
      _showError('Email không hợp lệ');
      return;
    }
    if (password.length < 6) {
      _showError('Mật khẩu phải ít nhất 6 ký tự');
      return;
    }
    if (password != confirmPassword) {
      _showError('Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final name = "$firstName $lastName";
      await ApiService.signup(name, email, password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký tài khoản thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError(e.toString().replaceAll('Exception: ', ''));
      }
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

                  RadioGroup<int>(
                    groupValue: _roleValue,
                    onChanged: (val) => setState(() => _roleValue = val ?? 0),
                    child: Row(
                      children: const [
                        Radio(value: 0, activeColor: primaryColor),
                        Text(
                          'Traveler',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 20),
                        Radio(value: 1, activeColor: primaryColor),
                        Text(
                          'Guide',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
