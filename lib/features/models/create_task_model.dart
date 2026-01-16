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

class CreateTaskModal extends StatefulWidget {
  final String categoryId;

  const CreateTaskModal({
    super.key,
    required this.categoryId,
  });

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();

  DateTime? _deadline;
  bool _isImportant = false;
  bool _notify = false;
  bool _loading = false;

  final List<File> _images = [];
  final List<File> _documents = [];
  final List<String> _links = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  // ------------------------------
  // PICKERS
  // ------------------------------
  Future<void> _pickImage() async {
    final file = await FilePickerUtils.pickImage();
    if (!mounted) return;
    if (file != null) {
      setState(() => _images.add(file));
    }
  }

  Future<void> _pickDocument() async {
    final file = await FilePickerUtils.pickDocument();
    if (!mounted) return;
    if (file != null) {
      setState(() => _documents.add(file));
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

  // ------------------------------
  // CREATE TASK
  // ------------------------------
  Future<void> _createTask() async {
    if (_loading) return;

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task title is required')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await TaskService.createTask(
        categoryId: widget.categoryId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        deadline: _deadline?.toUtc(),
        isImportant: _isImportant,
        notify: _notify,
        images: _images,
        documents: _documents,
        links: _links,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // ------------------------------
  // UI
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 560, // 🔒 FIXED WIDTH (prevents infinite constraints)
        child: GlassContainer(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ------------------------------
              // TITLE
              // ------------------------------
              Text(
                AppStrings.createTask,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: AppSpacing.xl),

              // ------------------------------
              // FORM
              // ------------------------------
              Flexible(
                child: SingleChildScrollView(
                  child: CreateTaskForm(
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    linkController: _linkController,
                    onAddLink: _addLink,
                    links: _links,
                    images: _images,
                    documents: _documents,
                    onPickImage: _pickImage,
                    onPickDocument: _pickDocument,
                    onRemoveLink: (i) =>
                        setState(() => _links.removeAt(i)),
                    onRemoveImage: (i) =>
                        setState(() => _images.removeAt(i)),
                    onRemoveDocument: (i) =>
                        setState(() => _documents.removeAt(i)),
                    onDeadlineChanged: (d) => _deadline = d,
                    onPriorityChanged: (v) => _isImportant = v,
                    onNotifyChanged: (v) => _notify = v,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ------------------------------
              // ACTIONS
              // ------------------------------
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
                      label: _loading
                          ? 'Creating...'
                          : AppStrings.createTask,
                      onPressed: _loading ? null : _createTask,
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
