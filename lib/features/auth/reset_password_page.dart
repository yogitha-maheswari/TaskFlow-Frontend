import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/services/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmVisible = false;

  bool _loading = false;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _isValidOtp(String otp) => otp.length == 6;

  bool _isValidPassword(String password) {
    final pwdRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z0-9]).{6,}$');
    return pwdRegex.hasMatch(password);
  }

  Future<void> _resetPassword() async {
    final otp = _otpController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (otp.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack('All fields required');
      return;
    }

    if (!_isValidOtp(otp)) {
      _showSnack('OTP must be 6 digits');
      return;
    }

    if (!_isValidPassword(password)) {
      _showSnack(
        'Password must contain letter, number & special character',
      );
      return;
    }

    if (password != confirm) {
      _showSnack('Passwords do not match');
      return;
    }

    setState(() => _loading = true);

    try {
      final result = await AuthService.resetPassword(
        email: widget.email,
        otp: otp,
        newPassword: password,
      );

      if (!mounted) return;

      if (result['status'] == true) {
        _showSnack('Password reset successful');

        // Go back to Login / Home
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        _showSnack(result['message'] ?? 'Reset failed');
      }
    } catch (e) {
      _showSnack('Server error. Try again.');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: AppIcons.svg(
            AppIcons.back,
            size: AppSpacing.iconMd,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                        'Reset Password',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'OTP sent to ${widget.email}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // OTP
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter 6-digit OTP',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: AppIcons.svg(
                            AppIcons.otp,
                            size: AppSpacing.iconSm,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // New password
                    TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'New password',
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

                    const SizedBox(height: AppSpacing.lg),

                    // Confirm password
                    TextField(
                      controller: _confirmController,
                      obscureText: !_confirmVisible,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
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
                            _confirmVisible ? AppIcons.passHide : AppIcons.passShow,
                            size: AppSpacing.iconSm,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => setState(() => _confirmVisible = !_confirmVisible),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    PrimaryButton(
                      label: _loading ? 'Resetting...' : 'Reset Password',
                      onPressed: _loading ? null : _resetPassword,
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
