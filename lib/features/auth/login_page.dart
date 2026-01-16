import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/primary_button.dart';

import '../../data/config/app_config.dart';
import '../../data/providers/notification_provider.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/secure_storage_service.dart';
import '../../data/services/http_exceptions.dart';

import 'register_page.dart';
import 'forgot_password_page.dart';
import '../dashboard/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r"^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,}$");
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final pwdRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z0-9]).{6,}$');
    return pwdRegex.hasMatch(password);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.border,
      ),
    );
  }

  // ===============================
  // MANUAL LOGIN ONLY (FIXED)
  // ===============================
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Email and password required');
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnack('Invalid email address');
      return;
    }

    if (!_isValidPassword(password)) {
      _showSnack(
        'Password must include letter, number & special character',
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final result = await AuthService.login(email, password);

      if (result['status'] == true) {
        final token = result['token'];

        // ✅ Save token
        await SecureStorage.saveToken(token);

        // 🔔 Start notifications AFTER login
        context.read<NotificationProvider>().start(
              baseUrl: AppConfig.baseUrl,
              userId: 'self',
              authToken: token,
            );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      } else {
        // ✅ IMPORTANT: show backend message
        _showSnack(result['message'] ?? 'Login failed');
      }
    } on UnauthorizedException {
      // ✅ DO NOT redirect silently
      _showSnack('Invalid email or password');
    } catch (e) {
      debugPrint('❌ LOGIN ERROR: $e');
      _showSnack('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // ===============================
  // UI
  // ===============================
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
                        'Welcome Back',
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
                          icon: AppIcons.svg(
                            _passwordVisible
                                ? AppIcons.passHide
                                : AppIcons.passShow,
                            size: AppSpacing.iconSm,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => setState(
                            () => _passwordVisible = !_passwordVisible,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    PrimaryButton(
                      label: _loading ? 'Logging in...' : 'Login',
                      onPressed: _loading ? null : _login,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              const TextSpan(
                                text: "Don't have an account? ",
                              ),
                              TextSpan(
                                text: 'Create one',
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