import '../../core/constants/app_strings.dart';
import 'task_attachment_model.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime? deadline;
  final bool notify;

  bool isCompleted;
  bool isImportant;

  // ✅ NEW
  final List<String> links;
  final List<TaskImage> images;
  final List<TaskDocument> documents;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.deadline,
    this.notify = false,
    this.isCompleted = false,
    this.isImportant = false,
    this.links = const [],
    this.images = const [],
    this.documents = const [],
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']).toLocal() : null,
      notify: json['notify'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      isImportant: json['isImportant'] ?? false,

      // ✅ NEW
      links: (json['links'] as List?)?.cast<String>() ?? [],
      images: (json['images'] as List?)
              ?.map((e) => TaskImage.fromJson(e))
              .toList() ??
          [],
      documents: (json['documents'] as List?)
              ?.map((e) => TaskDocument.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// UI helpers
  String get deadlineLabel {
    if (deadline == null) return AppStrings.noDeadline;
    return '${deadline!.day}/${deadline!.month}/${deadline!.year}';
  }

  bool get isOverdue =>
      !isCompleted && deadline != null && deadline!.isBefore(DateTime.now());
}
