import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import 'document_preview_page.dart';

class AttachmentsSection extends StatelessWidget {
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

  const AttachmentsSection({
    super.key,
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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ------------------------------
        // LINK INPUT
        // ------------------------------
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: linkController,
                decoration: const InputDecoration(labelText: 'Add link'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_link),
              onPressed: onAddLink,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // ------------------------------
        // IMAGE / DOC PICKERS
        // ------------------------------
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: AppIcons.svg(
                  AppIcons.camera,
                  size: AppSpacing.iconSm,
                  color: AppColors.textSecondary,
                ),
                label: Text('Images (${images.length})'),
                onPressed: onPickImage,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton.icon(
                icon: AppIcons.svg(
                  AppIcons.document,
                  size: AppSpacing.iconSm,
                  color: AppColors.textSecondary,
                ),
                label: Text('Docs (${documents.length})'),
                onPressed: onPickDocument,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // ------------------------------
        // LINKS
        // ------------------------------
        if (links.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              links.length,
              (i) => Chip(
                avatar: AppIcons.svg(
                  AppIcons.link,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                label: GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(text: links[i]),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copied')),
                    );
                  },
                  child: Text(
                    links[i],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onDeleted: () => onRemoveLink(i),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // ------------------------------
        // IMAGE PREVIEW
        // ------------------------------
        if (images.isNotEmpty) ...[
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final f = images[i];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => _showImagePreview(context, f),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          f,
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: InkWell(
                        onTap: () => onRemoveImage(i),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // ------------------------------
        // DOCUMENT LIST (TAP TO PREVIEW PAGE)
        // ------------------------------
        if (documents.isNotEmpty)
          Column(
            children: List.generate(
              documents.length,
              (i) {
                final f = documents[i];
                final name =
                    f.path.split(Platform.pathSeparator).last;

                return ListTile(
                  leading: AppIcons.svg(
                    AppIcons.document,
                    size: 24,
                    color: AppColors.textSecondary,
                  ),
                  title: Text(name),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => DocumentPreviewDialog(file: f),
                    );
                  },
                  trailing: IconButton(
                    icon:
                        const Icon(Icons.remove_circle_outline),
                    onPressed: () => onRemoveDocument(i),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  // ------------------------------
  // IMAGE PREVIEW DIALOG
  // ------------------------------
  void _showImagePreview(BuildContext context, File file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: InteractiveViewer(
          child: Image.file(file),
        ),
      ),
    );
  }
}
