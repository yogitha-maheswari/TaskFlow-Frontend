import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../data/services/task_service.dart';
import '../../models/edit_task_model.dart';
import '../../models/task_model.dart';
import '../../tasks/task_detail_page.dart';
import 'task_status_chip.dart';


class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onRefresh;

  const TaskTile({
    super.key,
    required this.task,
    required this.onRefresh,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            // --------------------------------------------------
            // CHECKBOX
            // --------------------------------------------------
            GestureDetector(
              onTap: () async {
                await TaskService.toggleComplete(widget.task.id);
                widget.onRefresh();
              },
              child: AppIcons.svg(
                widget.task.isCompleted
                    ? AppIcons.checkedSquare
                    : AppIcons.square,
                size: AppSpacing.iconMd,
                color: widget.task.isCompleted
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // --------------------------------------------------
            // TITLE + DEADLINE
            // --------------------------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                          decoration: widget.task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.task.deadlineLabel,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.danger),
                  ),
                ],
              ),
            ),

            // --------------------------------------------------
            // IMPORTANT CHIP
            // --------------------------------------------------
            if (widget.task.isImportant)
              const TaskStatusChip.important(),

            // --------------------------------------------------
            // MENU
            // --------------------------------------------------
            AnimatedOpacity(
              opacity: _hovering ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: PopupMenuButton<String>(
                icon: AppIcons.svg(AppIcons.more),
                onSelected: (value) async {
                  if (value == 'priority') {
                    await TaskService.togglePriority(widget.task.id);
                  } else if (value == 'delete') {
                    await TaskService.deleteTask(widget.task.id);
                  } else if (value == 'edit') {
                    final updated = await showDialog<bool>(
                      context: context,
                      builder: (_) =>
                          EditTaskModal(task: widget.task),
                    );
                    if (updated == true) widget.onRefresh();
                  } else if (value == 'view') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailPage(
                          taskId: widget.task.id,
                        ),
                      ),
                    );
                  }

                  widget.onRefresh();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'view',
                    child: Text('View'),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'priority',
                    child: Text('Toggle Priority'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
