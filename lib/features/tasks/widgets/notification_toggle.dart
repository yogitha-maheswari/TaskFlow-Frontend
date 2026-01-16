import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/glass_container.dart';



class NotificationToggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const NotificationToggle({
    super.key,
    this.initialValue = true,
    this.onChanged,
  });

  @override
  State<NotificationToggle> createState() =>
      _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = widget.initialValue;
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
                AppIcons.notification,
                color: _enabled
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.md),
              const Text('Enable Notification'),
            ],
          ),
          Switch(
            value: _enabled,
            activeColor: AppColors.primary,
            onChanged: (val) {
              setState(() => _enabled = val);
              widget.onChanged?.call(val);
            },
          ),
        ],
      ),
    );
  }
}
