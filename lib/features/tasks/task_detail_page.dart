import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/config/app_config.dart';
import '../../data/services/task_service.dart';
import '../models/task_model.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../core/widgets/glass_container.dart';

class TaskDetailPage extends StatelessWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<Task>(
        future: TaskService.fetchTaskById(taskId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load task'));
          }

          final task = snapshot.data!;

          String fullDeadlineLabel(DateTime d) {
            final local = d.toLocal();
            final date =
                '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
            final time =
                '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';

            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final target = DateTime(local.year, local.month, local.day);
            final diffDays = target.difference(today).inDays;

            String when;
            if (diffDays == 0) {
              when = 'Today';
            } else if (diffDays == 1) {
              when = 'Tomorrow';
            } else if (diffDays == -1) {
              when = 'Yesterday';
            } else if (diffDays > 1) {
              when = 'In $diffDays days';
            } else {
              when = '${diffDays.abs()} days ago';
            }

            return  '$when      • $date      • $time';
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),

                      // --------------------------------------------------
                      // HEADER
                      // --------------------------------------------------
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: AppSpacing.md),
                              child: AppIcons.svg(
                                AppIcons.back,
                                size: AppSpacing.iconMd,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              AppStrings.taskDetails,
                              style: theme.textTheme.headlineMedium,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xxl),

                      // --------------------------------------------------
                      // TITLE
                      // --------------------------------------------------
                      Text(
                        task.title,
                        style: theme.textTheme.headlineLarge,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // --------------------------------------------------
                      // STATUS PILLS
                      // --------------------------------------------------
                      Wrap(
                        spacing: AppSpacing.xl,
                        runSpacing: AppSpacing.md,
                        children: [
                          StatusPill(
                            label: task.isCompleted
                                ? AppStrings.completed
                                : AppStrings.pending,
                          ),
                          if (task.isImportant)
                            const StatusPill(label: AppStrings.important),
                          if (task.notify)
                            const StatusPill(label: 'Notify'),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // --------------------------------------------------
                      // DEADLINE
                      // --------------------------------------------------
                      GlassContainer(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                            children: [
                            AppIcons.svg(
                              AppIcons.clock,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              task.deadline != null
                                  ? 'Deadline: ${fullDeadlineLabel(task.deadline!)}'
                                  : 'No deadline',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // --------------------------------------------------
                      // DESCRIPTION
                      // --------------------------------------------------
                      if (task.description?.trim().isNotEmpty ?? false) ...[
                        Text(
                          AppStrings.taskDescription,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        GlassContainer(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(
                            task.description!,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],

                      // --------------------------------------------------
                      // LINKS
                      // --------------------------------------------------
                      if (task.links.isNotEmpty) ...[
                        Text(
                          AppStrings.links,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...task.links.map(
                          (link) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm),
                            child: GestureDetector(
                              onTap: () =>
                                  launchUrl(Uri.parse(link)),
                              child: GlassContainer(
                                padding:
                                    const EdgeInsets.all(AppSpacing.md),
                                child: Row(
                                  children: [
                                    AppIcons.svg(
                                      AppIcons.link, // Add your link icon here
                                      size: 18,
                                      color: AppColors.textMuted,
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Text(
                                        link,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],

                      // --------------------------------------------------
                      // IMAGES
                      // --------------------------------------------------
                        if (task.images.isNotEmpty) ...[
                        Text(
                          AppStrings.images,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...task.images.map(
                          (image) {
                          final imageUrl =
                            '${AppConfig.baseUrl}${image.url}';

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm),
                            child: GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (_) => Dialog(
                              backgroundColor: Colors.black,
                              insetPadding: EdgeInsets.zero,
                              child: InteractiveViewer(
                                child: Image.network(imageUrl),
                              ),
                              ),
                            ),
                            child: GlassContainer(
                              padding: EdgeInsets.zero,
                              child: ClipRRect(
                              borderRadius:
                                BorderRadius.circular(12),
                              child: Image.network(
                                imageUrl,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder:
                                  (_, __, ___) =>
                                    const Icon(
                                Icons.broken_image,
                                ),
                              ),
                              ),
                            ),
                            ),
                          );
                          },
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        ],
                      // --------------------------------------------------
                      // DOCUMENTS
                      // --------------------------------------------------
                      if (task.documents.isNotEmpty) ...[
                        Text(
                          AppStrings.documents,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...task.documents.map(
                          (doc) {
                            final docUrl =
                                '${AppConfig.baseUrl}${doc.url}';

                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm),
                              child: GlassContainer(
                                padding:
                                    const EdgeInsets.all(AppSpacing.md),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                      Icons.insert_drive_file),
                                  title: Text(doc.name),
                                  subtitle: Text(
                                    '${(doc.size / 1024).toStringAsFixed(1)} KB',
                                  ),
                                    trailing: AppIcons.svg(
                                    AppIcons.open_new,
                                    size: AppSpacing.iconMd,
                                    color: AppColors.textPrimary,
                                    ),
                                  onTap: () => launchUrl(
                                    Uri.parse(docUrl),
                                    mode: LaunchMode
                                        .externalApplication,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --------------------------------------------------
// STATUS PILL (SAFE IMPLEMENTATION)
// --------------------------------------------------
class StatusPill extends StatelessWidget {
  final String label;
  final bool isActive;

  const StatusPill({
    super.key,
    required this.label,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 250,
      height: 45,
      child: Container(
        alignment: Alignment.center,

        // ✅ BORDER APPLIED HERE (NOT ON GlassContainer)
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: isActive
              ? Border.all(
                  color: theme.colorScheme.primary,
                  width: 1.8,
                )
              : null,
        ),

        child: GlassContainer(
          padding: EdgeInsets.zero,
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
