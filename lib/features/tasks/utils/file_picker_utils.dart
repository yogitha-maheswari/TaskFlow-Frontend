import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// --------------------------------------------------
/// File Picker Utils
/// Works on: Windows, Android, macOS, Linux
/// --------------------------------------------------
class FilePickerUtils {
  const FilePickerUtils._();

  /// ------------------------------
  /// Pick Image (jpg, png, jpeg)
  /// ------------------------------
  static Future<File?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null) return null;

    final path = result.files.single.path;
    if (path == null) return null;

    return File(path);
  }

  /// ------------------------------
  /// Pick Document (pdf, doc, docx)
  /// ------------------------------
  static Future<File?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: false,
    );

    if (result == null) return null;

    final path = result.files.single.path;
    if (path == null) return null;

    return File(path);
  }

  /// ------------------------------
  /// Pick Any File (fallback)
  /// ------------------------------
  static Future<File?> pickAnyFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result == null) return null;

    final path = result.files.single.path;
    if (path == null) return null;

    return File(path);
  }
}
