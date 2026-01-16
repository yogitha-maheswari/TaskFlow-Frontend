import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/glass_container.dart';
import 'attachment_row.dart';
import 'status_dropdown.dart';
import 'deadline_picker.dart';
import 'priority_toggle.dart';
import 'notification_toggle.dart';

class CreateTaskForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController linkController;

  final VoidCallback onAddLink;
  final List<String> links;
  final List<File> images;
  final List<File> documents;
  final VoidCallback onPickImage;
  final VoidCallback onPickDocument;
  final ValueChanged<int> onRemoveLink;
  final ValueChanged<int> onRemoveImage;
  final ValueChanged<int> onRemoveDocument;

  final ValueChanged<DateTime?>? onDeadlineChanged;
  final ValueChanged<bool>? onPriorityChanged;
  final ValueChanged<bool>? onNotifyChanged;

  final DateTime? initialDeadline;
  final bool initialImportant;
  final bool initialNotify;

  const CreateTaskForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.linkController,
    required this.onAddLink,
    required this.links,
    required this.images,
    required this.documents,
    required this.onPickImage,
    required this.onPickDocument,
    required this.onRemoveLink,
    required this.onRemoveImage,
    required this.onRemoveDocument,
    this.onDeadlineChanged,
    this.onPriorityChanged,
    this.onNotifyChanged,
    this.initialDeadline,
    this.initialImportant = false,
    this.initialNotify = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(AppSpacing.lg),
      border: Border.all(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ------------------------------
          // Task Title *
          // ------------------------------
          _label(context, AppStrings.taskTitle, required: true),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: titleController,
            decoration:
                const InputDecoration(hintText: AppStrings.taskTitleHint),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // ------------------------------
          // Category *
          // ------------------------------
          _label(context, AppStrings.category, required: true),
          const SizedBox(height: AppSpacing.md),
          const StatusDropdown(),

          const SizedBox(height: AppSpacing.xxl),

          // ------------------------------
          // Deadline *
          // ------------------------------
          _label(context, AppStrings.selectDeadline, required: true),
          const SizedBox(height: AppSpacing.md),
          DeadlinePicker(
            initialDateTime: initialDeadline,
            onChanged: onDeadlineChanged,
          ),

          const SizedBox(height: AppSpacing.xxl),

          // ------------------------------
          // Description
          // ------------------------------
          _label(context, AppStrings.taskDescription),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: descriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: AppStrings.taskDescriptionHint,
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          PriorityToggle(
            initialValue: initialImportant,
            onChanged: onPriorityChanged,
          ),

          const SizedBox(height: AppSpacing.xxl),

          NotificationToggle(
            initialValue: initialNotify,
            onChanged: onNotifyChanged,
          ),

          const SizedBox(height: AppSpacing.xxl),

          // ------------------------------
          // Attachments
          // ------------------------------
          _label(context, AppStrings.attachments),
          const SizedBox(height: AppSpacing.md),

          AttachmentsSection(
            linkController: linkController,
            onAddLink: onAddLink,
            links: links,
            images: images,
            documents: documents,
            onPickImage: onPickImage,
            onPickDocument: onPickDocument,
            onRemoveLink: onRemoveLink,
            onRemoveImage: onRemoveImage,
            onRemoveDocument: onRemoveDocument,
          ),
        ],
      ),
    );
  }

  Widget _label(BuildContext context, String text,
      {bool required = false}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textPrimary),
          ),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.danger),
            ),
        ],
      ),
    );
  }
}
