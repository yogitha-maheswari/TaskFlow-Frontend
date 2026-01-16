import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/glass_container.dart';
import '../dialogs/delete_category_dialog.dart';
import '../../../data/services/category_service.dart';
import '../../category/category_page.dart';
import '../../models/edit_category_model.dart';
import 'progress_bar.dart';

class CategoryCard extends StatelessWidget {
  final String categoryId;
  final String title;
  final int taskCount;
  final double progress;

  /// icon can be KEY or SVG PATH
  final String icon;

  /// 🔴 overdue tasks count
  final int overdueCount;

  final VoidCallback? onDelete;
  final VoidCallback? onRename;

  const CategoryCard({
    super.key,
    required this.categoryId,
    required this.title,
    required this.taskCount,
    required this.progress,
    required this.icon,
    required this.overdueCount,
    this.onDelete,
    this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryPage(
              categoryId: categoryId,
              categoryName: title,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          GlassContainer(
            showMenu: true,

            onRename: () async {
              final updated = await showDialog<bool>(
                context: context,
                builder: (_) => EditCategoryModal(
                  categoryId: categoryId,
                  initialName: title,
                  initialIcon: icon,
                ),
              );

              if (updated == true) {
                onRename?.call();
              }
            },

            onDelete: () async {
              final deleted = await showDialog<bool>(
                context: context,
                builder: (_) => DeleteCategoryDialog(
                  onConfirm: () async {
                    await CategoryService.deleteCategory(categoryId);
                  },
                ),
              );

              if (deleted == true) {
                onDelete?.call();
              }
            },

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ICON
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _categoryColor(icon).withOpacity(0.15),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.md),
                  ),
                  child: Center(
                    child: AppIcons.svg(
                      _resolveIcon(icon),
                      size: 28,
                      color: _categoryColor(icon),
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  title,
                  style:
                      Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  '$taskCount tasks',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const SizedBox(height: AppSpacing.md),
                ProgressBar(value: progress),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  '${(progress * taskCount).round()} of $taskCount completed',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // 🔴 OVERDUE RED DOT
          if (overdueCount > 0)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ✅ ACCEPT KEY OR SVG PATH
  String _resolveIcon(String value) {
    if (value.endsWith('.svg')) {
      return value;
    }

    switch (value) {
      case 'work':
        return AppIcons.work;
      case 'school':
        return AppIcons.school;
      case 'home':
        return AppIcons.home;
      case 'important':
        return AppIcons.important;
      case 'personal':
        return AppIcons.person;
      case 'shop':
        return AppIcons.shop;
      case 'music':
        return AppIcons.music;
      case 'travel':
        return AppIcons.travel;
      case 'heart':
        return AppIcons.heart;
      default:
        return AppIcons.person;
    }
  }

  Color _categoryColor(String value) {
    if (value.contains('work')) return AppColors.work;
    if (value.contains('school')) return AppColors.college;
    if (value.contains('home')) return AppColors.house;
    if (value.contains('important')) return AppColors.important;
    if (value.contains('travel')) return AppColors.travel;
    if (value.contains('music')) return AppColors.music;
    if (value.contains('shop')) return AppColors.shop;
    if (value.contains('person')) return AppColors.personal;
    if (value.contains('heart')) return AppColors.danger;
    return AppColors.primary;
  }
}