import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearchPressed;
  final String hint;

  const SearchField({
    super.key,
    required this.controller,
    required this.onSearchPressed,
    this.hint = AppStrings.searchTasks,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,

      // 🔥 Press keyboard search → same action
      onSubmitted: (_) => onSearchPressed(),

      decoration: InputDecoration(
        hintText: hint,

        // 🔥 RIGHT ICON (TRIGGERS SEARCH)
        suffixIcon: IconButton(
          tooltip: 'Search',
          icon: AppIcons.svg(
            AppIcons.search,
            size: AppSpacing.iconMd,
            color: AppColors.primary,
          ),
          onPressed: onSearchPressed,
        ),

        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
      ),
    );
  }
}
