import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/services/auth_service.dart';
import 'login_page.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,}");
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    // Minimum 6 chars, at least one letter, one number and one special character
    final pwdRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z0-9]).{6,}$');
    return pwdRegex.hasMatch(password);
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Email and password required');
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnack('Please enter a valid email address');
      return;
    }

    if (!_isValidPassword(password)) {
      _showSnack(
        'Password must be at least 6 characters and include a letter, number, and special character',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.register(email, password);

      if (result['status'] == true) {
        _showSnack('Account created successfully');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        _showSnack(result['message'] ?? 'Registration failed');
      }
    } catch (e) {
      _showSnack('Server error. Try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.border,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: GlassContainer(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Create Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: AppIcons.svg(
                            AppIcons.mail,
                            size: AppSpacing.iconSm,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: AppIcons.svg(
                            AppIcons.lock,
                            size: AppSpacing.iconSm,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          icon: AppIcons.svg(
                            _passwordVisible ? AppIcons.passHide : AppIcons.passShow,
                            size: AppSpacing.iconSm,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    PrimaryButton(
                      label: _isLoading ? 'Creating...' : 'Create Account',
                      onPressed: _isLoading ? null : _register,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              const TextSpan(
                                text: 'Already have an account? ',
                              ),
                              TextSpan(
                                text: 'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
