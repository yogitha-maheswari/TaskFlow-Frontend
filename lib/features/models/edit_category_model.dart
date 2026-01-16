import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/outline_button.dart';
import '../../data/services/category_service.dart';

class EditCategoryModal extends StatefulWidget {
  final String categoryId;
  final String initialName;
  final String initialIcon;

  const EditCategoryModal({
    super.key,
    required this.categoryId,
    required this.initialName,
    required this.initialIcon,
  });

  @override
  State<EditCategoryModal> createState() =>
      _EditCategoryModalState();
}

class _EditCategoryModalState extends State<EditCategoryModal> {
  late TextEditingController _nameController;
  late String _selectedIcon;
  bool _loading = false;

  final List<String> _icons = [
    AppIcons.person,
    AppIcons.work,
    AppIcons.school,
    AppIcons.home,
    AppIcons.important,
    AppIcons.star,
    AppIcons.heart,
    AppIcons.shop,
    AppIcons.travel,
    AppIcons.music,
    AppIcons.file,
    AppIcons.camera,
  ];

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialName);
    _selectedIcon = widget.initialIcon;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category name is required')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await CategoryService.updateCategory(
        id: widget.categoryId,
        name: name,
        icon: _selectedIcon,
      );

      // ✅ tell dashboard to refresh
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update category'),
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
        constraints: const BoxConstraints(maxWidth: 480),
        child: GlassContainer(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // Header
              // --------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.editCategory,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: AppIcons.svg(
                      AppIcons.close,
                      color: AppColors.textMuted,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              // --------------------------------------------------
              // Category Name
              // --------------------------------------------------
              Text(
                AppStrings.categoryName,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textPrimary),
              ),

              const SizedBox(height: AppSpacing.md),

              TextField(
                controller: _nameController,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: const InputDecoration(
                  hintText: 'Enter category name...',
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // --------------------------------------------------
              // Icon Label
              // --------------------------------------------------
              Text(
                AppStrings.icon,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textPrimary),
              ),

              const SizedBox(height: AppSpacing.md),

              // --------------------------------------------------
              // Icon Grid
              // --------------------------------------------------
              Wrap(
                spacing: AppSpacing.xxl,
                runSpacing: AppSpacing.md,
                children: _icons.map((icon) {
                  final bool isSelected = icon == _selectedIcon;

                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedIcon = icon),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 180),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: AppIcons.svg(
                          icon,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          size: AppSpacing.iconMd,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.xl * 1.2),

              // --------------------------------------------------
              // Actions
              // --------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: OutlineButton(
                      label: AppStrings.cancel,
                      onPressed: () =>
                          Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: PrimaryButton(
                      label: _loading
                          ? 'Saving...'
                          : AppStrings.saveChanges,
                      onPressed:
                          _loading ? null : _saveChanges,
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
