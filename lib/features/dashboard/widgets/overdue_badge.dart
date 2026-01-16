import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';

class OverdueBadge extends StatelessWidget {
  final int count;

  const OverdueBadge({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999), // full pill
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.danger.withOpacity(0.25),
                AppColors.danger.withOpacity(0.15),
              ],
            ),
            border: Border.all(
              color: AppColors.danger.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Alert icon
              AppIcons.svg(
                AppIcons.danger,
                size: AppSpacing.iconSm,
                color: AppColors.danger,
              ),
              const SizedBox(width: AppSpacing.sm),

              // Text
              Text(
                '$count overdue',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
