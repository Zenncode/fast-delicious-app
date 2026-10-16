import 'package:flutter/material.dart';

import '../app_state.dart';
import '../painters.dart';
import '../sheets.dart';
import '../theme.dart';
import '../widgets.dart';

// Login / sign-up screen with password recovery.

class AuthScreen extends StatefulWidget {
  final AppState appState;

  const AuthScreen({super.key, required this.appState});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginTab = true;
  final TextEditingController _emailCtrl =
      TextEditingController(text: 'huzeyfebastas@gmail.com');
  final TextEditingController _passCtrl =
      TextEditingController(text: '••••••••••••');
  final TextEditingController _nameCtrl =
      TextEditingController(text: 'Emre Huzeyfe Baştaş');

  bool _isValidEmail(String value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());

  void _showAuthMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surfaceLight,
        behavior: SnackBarBehavior.floating,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Chef Hat & Floating Ingredients Illustration
              SizedBox(
                height: 190,
                width: 240,
                child: CustomPaint(
                  painter: ChefHatSplashPainter(),
                ),
              ),
              const SizedBox(height: 16),

              // Login / Sign up Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => isLoginTab = true),
                    child: Column(
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            color: isLoginTab
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 56,
                          height: 3,
                          decoration: BoxDecoration(
                            color: isLoginTab
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => isLoginTab = false),
                    child: Column(
                      children: [
                        Text(
                          'Sign up',
                          style: TextStyle(
                            color: !isLoginTab
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 56,
                          height: 3,
                          decoration: BoxDecoration(
                            color: !isLoginTab
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              if (!isLoginTab) ...[
                AuthInputField(
                  label: 'Full Name',
                  controller: _nameCtrl,
                  obscure: false,
                ),
                const SizedBox(height: 18),
              ],
              AuthInputField(
                label: 'Email Address',
                controller: _emailCtrl,
                obscure: false,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              AuthInputField(
                label: 'Password',
                controller: _passCtrl,
                obscure: true,
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => showForgotPasswordSheet(context, _emailCtrl.text),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 6,
                    shadowColor: AppColors.primary.withValues(alpha: 0.45),
                  ),
                  onPressed: () {
                    final email = _emailCtrl.text.trim();
                    final password = _passCtrl.text.trim();
                    if (!isLoginTab && _nameCtrl.text.trim().isEmpty) {
                      _showAuthMessage('Please enter your full name.');
                      return;
                    }
                    if (email.isEmpty) {
                      _showAuthMessage('Please enter your email address.');
                      return;
                    }
                    if (!_isValidEmail(email)) {
                      _showAuthMessage('Please enter a valid email address.');
                      return;
                    }
                    if (password.isEmpty) {
                      _showAuthMessage('Please enter your password.');
                      return;
                    }
                    if (password.length < 6) {
                      _showAuthMessage(
                        'Password must be at least 6 characters.',
                      );
                      return;
                    }
                    widget.appState.login(email);
                  },
                  child: Text(
                    isLoginTab ? 'Login' : 'Sign up',
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
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
