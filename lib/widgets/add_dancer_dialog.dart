import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/attendance_service.dart';
import '../services/dancer_service.dart';
import '../utils/action_logger.dart';
import '../utils/toast_helper.dart';

class AddDancerDialog extends StatefulWidget {
  final Dancer? dancer; // If provided, we're editing
  final int? eventId; // If provided, we're adding during an event

  const AddDancerDialog({
    super.key,
    this.dancer,
    this.eventId,
  });

  @override
  State<AddDancerDialog> createState() => _AddDancerDialogState();
}

class _AddDancerDialogState extends State<AddDancerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _impressionController = TextEditingController();

  bool _alreadyDanced = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    ActionLogger.logUserAction('AddDancerDialog', 'dialog_opened', {
      'isEditing': widget.dancer != null,
      'eventId': widget.eventId,
      'dancerId': widget.dancer?.id,
      'dancerName': widget.dancer?.name,
    });

    // If editing, populate fields
    if (widget.dancer != null) {
      _nameController.text = widget.dancer!.name;
      _notesController.text = widget.dancer!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _impressionController.dispose();
    super.dispose();
  }

  Future<void> _saveDancer() async {
    ActionLogger.logUserAction('AddDancerDialog', 'save_started', {
      'isEditing': widget.dancer != null,
      'eventId': widget.eventId,
      'dancerId': widget.dancer?.id,
      'nameLength': _nameController.text.trim().length,
      'hasNotes': _notesController.text.trim().isNotEmpty,
      'alreadyDanced': _alreadyDanced,
      'hasImpression': _impressionController.text.trim().isNotEmpty,
    });

    if (!_formKey.currentState!.validate()) {
      ActionLogger.logUserAction('AddDancerDialog', 'validation_failed', {
        'isEditing': widget.dancer != null,
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dancerService = Provider.of<DancerService>(context, listen: false);

      int dancerId;

      if (widget.dancer != null) {
        // Editing existing dancer
        ActionLogger.logUserAction('AddDancerDialog', 'updating_dancer', {
          'dancerId': widget.dancer!.id,
          'oldName': widget.dancer!.name,
          'newName': _nameController.text.trim(),
        });

        await dancerService.updateDancer(
          widget.dancer!.id,
          name: _nameController.text.trim(),
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        );
        dancerId = widget.dancer!.id;
      } else {
        // Creating new dancer
        ActionLogger.logUserAction('AddDancerDialog', 'creating_dancer', {
          'name': _nameController.text.trim(),
          'hasNotes': _notesController.text.trim().isNotEmpty,
        });

        dancerId = await dancerService.createDancer(
          name: _nameController.text.trim(),
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        );
      }

      // If we're adding during an event and "already danced" is checked
      if (widget.eventId != null && _alreadyDanced && widget.dancer == null) {
        ActionLogger.logUserAction(
            'AddDancerDialog', 'recording_dance_during_creation', {
          'eventId': widget.eventId!,
          'dancerId': dancerId,
          'hasImpression': _impressionController.text.trim().isNotEmpty,
        });

        final attendanceService =
            Provider.of<AttendanceService>(context, listen: false);
        await attendanceService.createAttendanceWithDance(
          eventId: widget.eventId!,
          dancerId: dancerId,
          impression: _impressionController.text.trim().isNotEmpty
              ? _impressionController.text.trim()
              : null,
        );
      }

      if (mounted) {
        ActionLogger.logUserAction('AddDancerDialog', 'save_completed', {
          'isEditing': widget.dancer != null,
          'dancerId': dancerId,
          'eventId': widget.eventId,
        });

        Navigator.pop(context, true); // Return true to indicate success
        ToastHelper.showSuccess(
            context,
            widget.dancer != null
                ? 'Dancer updated successfully!'
                : 'Dancer added successfully!');
      }
    } catch (e) {
      ActionLogger.logError('AddDancerDialog._saveDancer', e.toString(), {
        'isEditing': widget.dancer != null,
        'eventId': widget.eventId,
        'dancerId': widget.dancer?.id,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error saving dancer: $e');
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
    final isEditing = widget.dancer != null;
    final isEventContext = widget.eventId != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Dancer' : 'Add New Dancer'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Great lead, loves spins',
                ),
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),

              // Show "already danced" option only when adding during an event
              if (isEventContext && !isEditing) ...[
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Already danced with this person'),
                  value: _alreadyDanced,
                  onChanged: (value) {
                    ActionLogger.logUserAction(
                        'AddDancerDialog', 'already_danced_toggled', {
                      'value': value ?? false,
                      'eventId': widget.eventId,
                    });

                    setState(() {
                      _alreadyDanced = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),

                // Show impression field if already danced is checked
                if (_alreadyDanced) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _impressionController,
                    decoration: const InputDecoration(
                      labelText: 'Impression (optional)',
                      border: OutlineInputBorder(),
                      hintText: 'How was the dance?',
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  ActionLogger.logUserAction(
                      'AddDancerDialog', 'dialog_cancelled', {
                    'isEditing': widget.dancer != null,
                    'eventId': widget.eventId,
                  });
                  Navigator.pop(context);
                },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveDancer,
          child: _isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Update' : 'Add Dancer'),
        ),
      ],
    );
  }
}
