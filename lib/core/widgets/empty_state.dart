import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';

class EmptyState extends StatelessWidget {
  /// Optional overrides
  final String? title;
  final String? subtitle;

  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyState({
    super.key,
    this.title,
    this.subtitle,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ------------------------------
            // Icon
            // ------------------------------
            Icon( AppIcons.empty, size: AppSpacing.iconXl * 2, color: AppColors.textMuted, ),
            
            const SizedBox(height: AppSpacing.lg),

            // ------------------------------
            // Title
            // ------------------------------
            Text(
              title ?? AppStrings.noTasksTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            // ------------------------------
            // Subtitle
            // ------------------------------
            Text(
              subtitle ?? AppStrings.noTasksSubtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.center,
            ),

            // ------------------------------
            // Optional Action Button
            // ------------------------------
            if (onAction != null)
              Padding(
                padding:
                    const EdgeInsets.only(top: AppSpacing.xl),
                child: SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: onAction,
                    child: Text(
                      actionLabel ??
                          AppStrings.createTask,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
