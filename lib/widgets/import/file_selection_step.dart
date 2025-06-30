import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../utils/action_logger.dart';

/// Step 1: File Selection Component
/// Handles file picking and validation for JSON import files
class FileSelectionStep extends StatelessWidget {
  final File? selectedFile;
  final Function(File) onFileSelected;
  final VoidCallback onFileClear;
  final bool isLoading;

  const FileSelectionStep({
    super.key,
    required this.selectedFile,
    required this.onFileSelected,
    required this.onFileClear,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedFile == null) ...[
          // File picker area
          InkWell(
            onTap: isLoading ? null : _pickFile,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withOpacity(0.3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.file_upload,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select JSON file to import',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to browse files',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : _pickFile,
              icon: const Icon(Icons.folder_open),
              label: const Text('Browse Files'),
            ),
          ),
        ] else ...[
          // Selected file info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedFile!.path.split('/').last,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: onFileClear,
                        icon: const Icon(Icons.close),
                        tooltip: 'Clear selection',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<int>(
                    future: selectedFile!.length(),
                    builder: (context, snapshot) {
                      final size = snapshot.data ?? 0;
                      final sizeKB = (size / 1024).round();
                      return Text(
                        'Size: $sizeKB KB',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Info section
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Import Requirements',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• JSON file format only\n'
                  '• Maximum file size: 1 MB\n'
                  '• Maximum 1000 dancers per file\n'
                  '• Required field: name\n'
                  '• Optional fields: tags, notes',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      ActionLogger.logUserAction('FileSelectionStep', 'file_picker_opened', {});

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);

        // Validate file size (1MB limit)
        final size = await file.length();
        if (size > 1024 * 1024) {
          throw Exception('File too large. Maximum size is 1 MB.');
        }

        onFileSelected(file);
      }
    } catch (e) {
      ActionLogger.logError('FileSelectionStep._pickFile', e.toString());
      // Note: Error handling will be done by parent widget
      rethrow;
    }
  }
}
