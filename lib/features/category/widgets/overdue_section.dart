import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../models/task_model.dart';
import 'task_tile.dart';

class OverdueSection extends StatelessWidget {
  final List<Task> overdueTasks;
  final VoidCallback onRefresh;

  const OverdueSection({
    super.key,
    required this.overdueTasks,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (overdueTasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.overdue,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        ...overdueTasks.map(
          (task) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: TaskTile(
              task: task,
              onRefresh: onRefresh,
            ),
          ),
        ),
      ],
    );
  }
}
