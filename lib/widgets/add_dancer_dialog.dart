import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/dancer_service.dart';
import '../services/attendance_service.dart';
import '../theme/theme_extensions.dart';

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
    if (!_formKey.currentState!.validate()) {
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
        dancerId = await dancerService.createDancer(
          name: _nameController.text.trim(),
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        );
      }

      // If we're adding during an event and "already danced" is checked
      if (widget.eventId != null && _alreadyDanced && widget.dancer == null) {
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
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.dancer != null
                ? 'Dancer updated successfully!'
                : 'Dancer added successfully!'),
            backgroundColor: context.danceTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving dancer: $e'),
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
          onPressed: _isLoading ? null : () => Navigator.pop(context),
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
