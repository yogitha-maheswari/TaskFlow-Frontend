import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/glass_container.dart';
import '../../models/create_category_model.dart';

class AddCategoryCard extends StatelessWidget {
  final VoidCallback onCreated;

  const AddCategoryCard({
    super.key,
    required this.onCreated,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),

      // ✅ OPEN CREATE CATEGORY MODAL
      onTap: () async {
        final bool? created = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (_) => const CreateCategoryModal(),
        );

        if (created == true) {
          onCreated(); // 🔥 refresh dashboard
        }
      },

      child: GlassContainer(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : MediaQuery.of(context).size.width;

              final double scale =
                  (cardWidth / 250).clamp(0.7, 1.15);

              final double iconBoxSize =
                  (56 * scale).clamp(36, 96);
              final double iconSize =
                  (iconBoxSize * 0.5).clamp(18, 48);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: iconBoxSize,
                    height: iconBoxSize,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.14),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.md),
                    ),
                    child: Center(
                      child: AppIcons.svg(
                        AppIcons.add,
                        size: iconSize,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    AppStrings.addCategory,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
