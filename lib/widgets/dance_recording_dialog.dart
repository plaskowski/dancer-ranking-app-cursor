import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/attendance_service.dart';
import '../theme/theme_extensions.dart';

class DanceRecordingDialog extends StatefulWidget {
  final int dancerId;
  final int eventId;
  final String dancerName;

  const DanceRecordingDialog({
    super.key,
    required this.dancerId,
    required this.eventId,
    required this.dancerName,
  });

  @override
  State<DanceRecordingDialog> createState() => _DanceRecordingDialogState();
}

class _DanceRecordingDialogState extends State<DanceRecordingDialog> {
  final _impressionController = TextEditingController();

  bool _isLoading = false;
  bool _alreadyDanced = false;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyDanced();
  }

  @override
  void dispose() {
    _impressionController.dispose();
    super.dispose();
  }

  Future<void> _checkIfAlreadyDanced() async {
    try {
      final attendanceService =
          Provider.of<AttendanceService>(context, listen: false);
      final hasDanced =
          await attendanceService.hasDanced(widget.eventId, widget.dancerId);

      if (mounted) {
        setState(() {
          _alreadyDanced = hasDanced;
        });
      }
    } catch (e) {
      // Handle error silently, user can still proceed
    }
  }

  Future<void> _recordDance() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final attendanceService =
          Provider.of<AttendanceService>(context, listen: false);

      await attendanceService.recordDance(
        eventId: widget.eventId,
        dancerId: widget.dancerId,
        impression: _impressionController.text.trim().isNotEmpty
            ? _impressionController.text.trim()
            : null,
      );

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dance recorded with ${widget.dancerName}!'),
            backgroundColor: context.danceTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error recording dance: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Dance with ${widget.dancerName}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Record that you danced with this person.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            // Impression field
            TextField(
              controller: _impressionController,
              decoration: const InputDecoration(
                labelText: 'Impression (optional)',
                border: OutlineInputBorder(),
                hintText: 'How was the dance? Any notes?',
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),

            const SizedBox(height: 16),

            // Warning if already danced
            if (_alreadyDanced)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.danceTheme.warningContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.danceTheme.warning),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: context.danceTheme.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Already danced with ${widget.dancerName} tonight!',
                        style: TextStyle(
                          color: context.danceTheme.onWarningContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _recordDance,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.danceTheme.danceAccent,
            foregroundColor: context.danceTheme.onDanceAccent,
          ),
          child: _isLoading
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        context.danceTheme.onDanceAccent),
                  ),
                )
              : const Text('Record Dance'),
        ),
      ],
    );
  }
}
