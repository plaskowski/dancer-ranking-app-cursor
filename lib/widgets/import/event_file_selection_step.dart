import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../utils/action_logger.dart';

/// Step 1: Event File Selection Component
/// Handles file picking and validation for event JSON import files
class EventFileSelectionStep extends StatefulWidget {
  final List<File> selectedFiles;
  final Function(List<File>) onFilesSelected;
  final VoidCallback onFilesClear;
  final bool isLoading;

  const EventFileSelectionStep({
    super.key,
    required this.selectedFiles,
    required this.onFilesSelected,
    required this.onFilesClear,
    required this.isLoading,
  });

  @override
  State<EventFileSelectionStep> createState() => _EventFileSelectionStepState();
}

class _EventFileSelectionStepState extends State<EventFileSelectionStep> {
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.selectedFiles.isEmpty) ...[
          // File drop area with drag and drop support
          DropTarget(
            onDragDone: (detail) => _handleDrop(detail),
            onDragEntered: (detail) {
              setState(() {
                _isDragOver = true;
              });
              ActionLogger.logUserAction(
                  'EventFileSelectionStep', 'drag_entered', {});
            },
            onDragExited: (detail) {
              setState(() {
                _isDragOver = false;
              });
              ActionLogger.logUserAction(
                  'EventFileSelectionStep', 'drag_exited', {});
            },
            child: InkWell(
              onTap: widget.isLoading ? null : _pickFiles,
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
                      _isDragOver ? Icons.file_download : Icons.event_note,
                      size: 48,
                      color: _isDragOver
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isDragOver
                          ? 'Drop Event JSON files here'
                          : 'Select Event JSON files to import',
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
              onPressed: widget.isLoading ? null : _pickFiles,
              icon: const Icon(Icons.folder_open),
              label: const Text('Browse Files'),
            ),
          ),
        ] else ...[
          // Selected files info
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
                          '${widget.selectedFiles.length} file${widget.selectedFiles.length == 1 ? '' : 's'} selected',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onFilesClear,
                        icon: const Icon(Icons.close),
                        tooltip: 'Clear selection',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...widget.selectedFiles.map((file) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file,
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                file.path.split('/').last,
                                style: Theme.of(context).textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            FutureBuilder<int>(
                              future: file.length(),
                              builder: (context, snapshot) {
                                final size = snapshot.data ?? 0;
                                final sizeKB = (size / 1024).round();
                                return Text(
                                  '$sizeKB KB',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                      )),
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
                      'Event Import Requirements',
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
                  '• Maximum file size: 5 MB per file\n'
                  '• Required fields: name, date, attendances\n'
                  '• Date format: YYYY-MM-DD\n'
                  '• Attendance statuses: present, served, left\n'
                  '• Duplicate events automatically skipped\n'
                  '• Missing dancers automatically created\n'
                  '• Multiple files processed in sequence',
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

      final files = <File>[];

      for (final droppedFile in detail.files) {
        ActionLogger.logUserAction('EventFileSelectionStep', 'file_dropped', {
          'fileName': droppedFile.name,
          'filePath': droppedFile.path,
        });

        // Validate file extension
        if (!droppedFile.name.toLowerCase().endsWith('.json')) {
          throw Exception(
              'Only JSON files are supported. Please select .json files.');
        }

        final file = File(droppedFile.path);

        // Validate file size (5MB limit for events)
        final size = await file.length();
        if (size > 5 * 1024 * 1024) {
          throw Exception(
              'File ${droppedFile.name} too large. Maximum size is 5 MB.');
        }

        files.add(file);
      }

      widget.onFilesSelected(files);
    } catch (e) {
      ActionLogger.logError('EventFileSelectionStep._handleDrop', e.toString());
      // Note: Error handling will be done by parent widget
      rethrow;
    }
  }

  Future<void> _pickFiles() async {
    try {
      ActionLogger.logUserAction(
          'EventFileSelectionStep', 'file_picker_opened', {});

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final files = <File>[];

        for (final pickedFile in result.files) {
          final file = File(pickedFile.path!);

          // Validate file size (5MB limit for events)
          final size = await file.length();
          if (size > 5 * 1024 * 1024) {
            throw Exception(
                'File ${pickedFile.name} too large. Maximum size is 5 MB.');
          }

          files.add(file);
        }

        widget.onFilesSelected(files);
      }
    } catch (e) {
      ActionLogger.logError('EventFileSelectionStep._pickFiles', e.toString());
      // Note: Error handling will be done by parent widget
      rethrow;
    }
  }
}
