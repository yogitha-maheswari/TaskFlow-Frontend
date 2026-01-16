import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';

class TaskStatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final String icon;

  const TaskStatusChip._({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
  });

  /// ✅ Named constructor (FIXED)
  const TaskStatusChip.important({Key? key})
      : this._(
          key: key,
          label: AppStrings.important,
          color: AppColors.primary,
          icon: AppIcons.important,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius:
            BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: color.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcons.svg(
            icon,
            size: AppSpacing.iconSm,
            color: color,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
