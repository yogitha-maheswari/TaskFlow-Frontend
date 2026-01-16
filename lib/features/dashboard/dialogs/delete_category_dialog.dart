import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/outline_button.dart';

class DeleteCategoryDialog extends StatefulWidget {
  final Future<void> Function() onConfirm;

  const DeleteCategoryDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  State<DeleteCategoryDialog> createState() =>
      _DeleteCategoryDialogState();
}

class _DeleteCategoryDialogState
    extends State<DeleteCategoryDialog> {
  bool _loading = false;

  Future<void> _handleDelete() async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      await widget.onConfirm(); // ✅ wait for API

      if (!mounted) return;

      Navigator.pop(context, true); // ✅ success
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete category'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: GlassContainer(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.deleteCategoryTitle,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                AppStrings.deleteCategoryMessage,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
              ),

              const SizedBox(height: AppSpacing.xl),

              Row(
                children: [
                  Expanded(
                    child: OutlineButton(
                      label: AppStrings.cancel,
                      onPressed:
                          _loading ? null : () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: PrimaryButton(
                      label:
                          _loading ? 'Deleting...' : AppStrings.delete,
                      onPressed:
                          _loading ? null : _handleDelete,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
