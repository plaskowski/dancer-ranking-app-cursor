import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../utils/action_logger.dart';

/// Step 1: File Selection Component
/// Handles file picking and validation for JSON import files
class FileSelectionStep extends StatefulWidget {
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
  State<FileSelectionStep> createState() => _FileSelectionStepState();
}

class _FileSelectionStepState extends State<FileSelectionStep> {
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.selectedFile == null) ...[
          // File drop area with drag and drop support
          DropTarget(
            onDragDone: (detail) => _handleDrop(detail),
            onDragEntered: (detail) {
              setState(() {
                _isDragOver = true;
              });
              ActionLogger.logUserAction(
                  'FileSelectionStep', 'drag_entered', {});
            },
            onDragExited: (detail) {
              setState(() {
                _isDragOver = false;
              });
              ActionLogger.logUserAction(
                  'FileSelectionStep', 'drag_exited', {});
            },
            child: InkWell(
              onTap: widget.isLoading ? null : _pickFile,
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isDragOver
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: _isDragOver ? 3 : 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: _isDragOver
                      ? Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.5)
                      : Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withOpacity(0.3),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isDragOver ? Icons.file_download : Icons.file_upload,
                      size: 48,
                      color: _isDragOver
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isDragOver
                          ? 'Drop JSON file here'
                          : 'Select JSON file to import',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isDragOver
                          ? 'Release to upload'
                          : 'Drag & drop or tap to browse files',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: widget.isLoading ? null : _pickFile,
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
                          widget.selectedFile!.path.split('/').last,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onFileClear,
                        icon: const Icon(Icons.close),
                        tooltip: 'Clear selection',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<int>(
                    future: widget.selectedFile!.length(),
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

  Future<void> _handleDrop(DropDoneDetails detail) async {
    try {
      setState(() {
        _isDragOver = false;
      });

      if (detail.files.isEmpty) {
        return;
      }

      final droppedFile = detail.files.first;
      ActionLogger.logUserAction('FileSelectionStep', 'file_dropped', {
        'fileName': droppedFile.name,
        'filePath': droppedFile.path,
      });

      // Validate file extension
      if (!droppedFile.name.toLowerCase().endsWith('.json')) {
        throw Exception(
            'Only JSON files are supported. Please select a .json file.');
      }

      final file = File(droppedFile.path);

      // Validate file size (1MB limit)
      final size = await file.length();
      if (size > 1024 * 1024) {
        throw Exception('File too large. Maximum size is 1 MB.');
      }

      widget.onFileSelected(file);
    } catch (e) {
      ActionLogger.logError('FileSelectionStep._handleDrop', e.toString());
      // Note: Error handling will be done by parent widget
      rethrow;
    }
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

        widget.onFileSelected(file);
      }
    } catch (e) {
      ActionLogger.logError('FileSelectionStep._pickFile', e.toString());
      // Note: Error handling will be done by parent widget
      rethrow;
    }
  }
}
