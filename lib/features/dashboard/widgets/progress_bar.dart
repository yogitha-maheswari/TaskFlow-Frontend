import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class ProgressBar extends StatelessWidget {
  final double value;

  const ProgressBar({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(AppSpacing.radiusSm),
      child: LinearProgressIndicator(
        value: value,
        minHeight: AppSpacing.progressBarHeight,
        backgroundColor:
            AppColors.surfaceSoft,
        valueColor:
            const AlwaysStoppedAnimation(
          AppColors.primary,
        ),
      ),
    );
  }
}
