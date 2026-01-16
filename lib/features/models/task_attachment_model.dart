class TaskImage {
  final String url;
  final String name;

  TaskImage({
    required this.url,
    required this.name,
  });

  factory TaskImage.fromJson(Map<String, dynamic> json) {
    return TaskImage(
      url: json['url'],
      name: json['name'] ?? '',
    );
  }
}

class TaskDocument {
  final String url;
  final String name;
  final int size;
  final String type;

  TaskDocument({
    required this.url,
    required this.name,
    required this.size,
    required this.type,
  });

  factory TaskDocument.fromJson(Map<String, dynamic> json) {
    return TaskDocument(
      url: json['url'],
      name: json['name'] ?? '',
      size: json['size'] ?? 0,
      type: json['type'] ?? '',
    );
  }
}
