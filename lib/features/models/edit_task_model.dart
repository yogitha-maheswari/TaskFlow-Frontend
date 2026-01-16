import 'dart:io';
import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/outline_button.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/services/task_service.dart';
import '../tasks/utils/file_picker_utils.dart';
import '../tasks/widgets/create_task_form.dart';
import 'task_model.dart';

class EditTaskModal extends StatefulWidget {
  final Task task;

  const EditTaskModal({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskModal> createState() => _EditTaskModalState();
}

class _EditTaskModalState extends State<EditTaskModal> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final TextEditingController _linkController = TextEditingController();

  DateTime? _deadline;
  bool _isImportant = false;
  bool _notify = false;
  bool _loading = false;

  // ----------------------------
  // ATTACHMENTS
  // ----------------------------
  late List<String> _links;
  final List<File> _newImages = [];
  final List<File> _newDocuments = [];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description ?? '');

    _deadline = widget.task.deadline;
    _isImportant = widget.task.isImportant;
    _notify = widget.task.notify;

    _links = List<String>.from(widget.task.links);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  // ----------------------------
  // PICKERS
  // ----------------------------
  Future<void> _pickImage() async {
    final file = await FilePickerUtils.pickImage();
    if (!mounted) return;
    if (file != null) {
      setState(() => _newImages.add(file));
    }
  }

  Future<void> _pickDocument() async {
    final file = await FilePickerUtils.pickDocument();
    if (!mounted) return;
    if (file != null) {
      setState(() => _newDocuments.add(file));
    }
  }

  void _addLink() {
    final link = _linkController.text.trim();
    if (link.isEmpty) return;

    setState(() {
      _links.add(link);
      _linkController.clear();
    });
  }

  // ----------------------------
  // SAVE TASK
  // ----------------------------
  Future<void> _saveTask() async {
    if (_loading) return;

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task title is required')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await TaskService.updateTaskMultipart(
        taskId: widget.task.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        deadline: _deadline?.toUtc(),
        isImportant: _isImportant,
        notify: _notify,
        links: _links,
        images: _newImages,
        documents: _newDocuments,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // ----------------------------
  // UI
  // ----------------------------
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      contentPadding: EdgeInsets.zero,

      // 🔒 FIXED WIDTH — SAME AS CREATE TASK
      content: SizedBox(
        width: 560,
        child: GlassContainer(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ----------------------------
              // TITLE
              // ----------------------------
              Text(
                AppStrings.editTask,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: AppSpacing.xl),

              // ----------------------------
              // FORM
              // ----------------------------
              Flexible(
                child: SingleChildScrollView(
                  child: CreateTaskForm(
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    initialDeadline: _deadline,
                    initialImportant: _isImportant,
                    initialNotify: _notify,
                    onDeadlineChanged: (d) => _deadline = d,
                    onPriorityChanged: (v) => _isImportant = v,
                    onNotifyChanged: (v) => _notify = v,
                    linkController: _linkController,
                    onAddLink: _addLink,
                    links: _links,
                    images: _newImages,
                    documents: _newDocuments,
                    onPickImage: _pickImage,
                    onPickDocument: _pickDocument,
                    onRemoveLink: (i) =>
                        setState(() => _links.removeAt(i)),
                    onRemoveImage: (i) =>
                        setState(() => _newImages.removeAt(i)),
                    onRemoveDocument: (i) =>
                        setState(() => _newDocuments.removeAt(i)),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ----------------------------
              // ACTIONS
              // ----------------------------
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
                          _loading ? 'Saving...' : AppStrings.saveTask,
                      onPressed:
                          _loading ? null : _saveTask,
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
