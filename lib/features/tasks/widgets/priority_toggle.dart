import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/glass_container.dart';


class PriorityToggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const PriorityToggle({
    super.key,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<PriorityToggle> createState() => _PriorityToggleState();
}

class _PriorityToggleState extends State<PriorityToggle> {
  late bool _isPriority;

  @override
  void initState() {
    super.initState();
    _isPriority = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppIcons.svg(
                AppIcons.important,
                color: _isPriority
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                AppStrings.markAsImportant,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Switch(
            value: _isPriority,
            activeColor: AppColors.primary,
            onChanged: (v) {
              setState(() => _isPriority = v);
              widget.onChanged?.call(v);
            },
          ),
        ],
      ),
    );
  }
}

