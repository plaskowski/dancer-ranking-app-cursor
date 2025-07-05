import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/dancer/dancer_extraction_service.dart';
import '../utils/action_logger.dart';
import '../utils/toast_helper.dart';

class ExtractDanceRecordDialog {
  static Future<void> show(
    BuildContext context, {
    required int attendanceId,
    required String dancerName,
    required String eventName,
    required DateTime eventDate,
    String? impression,
    String? scoreName,
  }) async {
    ActionLogger.logUserAction('ExtractDanceRecordDialog', 'show', {
      'attendanceId': attendanceId,
      'dancerName': dancerName,
      'eventName': eventName,
    });

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ExtractDanceRecordDialogContent(
        attendanceId: attendanceId,
        dancerName: dancerName,
        eventName: eventName,
        eventDate: eventDate,
        impression: impression,
        scoreName: scoreName,
      ),
    );
  }
}

class _ExtractDanceRecordDialogContent extends StatefulWidget {
  final int attendanceId;
  final String dancerName;
  final String eventName;
  final DateTime eventDate;
  final String? impression;
  final String? scoreName;

  const _ExtractDanceRecordDialogContent({
    required this.attendanceId,
    required this.dancerName,
    required this.eventName,
    required this.eventDate,
    this.impression,
    this.scoreName,
  });

  @override
  State<_ExtractDanceRecordDialogContent> createState() =>
      _ExtractDanceRecordDialogContentState();
}

class _ExtractDanceRecordDialogContentState
    extends State<_ExtractDanceRecordDialogContent> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Separate record',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dance details
            Text(
              'Extract this dance record as a new one-time person?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            // Dance record details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.eventName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${_formatDate(widget.eventDate)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (widget.impression != null &&
                      widget.impression!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Impression: ${widget.impression}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  if (widget.scoreName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Score: ${widget.scoreName}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Warning
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This will remove the record from ${widget.dancerName}\'s history',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _extractRecord,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Separate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> _extractRecord() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final database = Provider.of<AppDatabase>(context, listen: false);
      final extractionService = DancerExtractionService(database);

      final success = await extractionService.extractDanceRecordAsOneTimePerson(
        widget.attendanceId,
        widget.dancerName,
      );

      if (mounted) {
        Navigator.pop(context);

        if (success) {
          ToastHelper.showSuccess(
              context, 'Dance record separated as one-time person');
        } else {
          ToastHelper.showError(
              context, 'Failed to separate dance record. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ToastHelper.showError(
            context, 'An error occurred while separating the record.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
