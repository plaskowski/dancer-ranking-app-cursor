import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/attendance_service.dart';
import '../services/dancer_service.dart';
import '../services/tag_service.dart';
import '../utils/action_logger.dart';
import '../utils/toast_helper.dart';
import 'tag_selection_widget.dart';

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
  DateTime? _firstMetDate;

  // Tag-related state
  Set<int> _selectedTagIds = {};

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
      _firstMetDate = widget.dancer!.firstMetDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _impressionController.dispose();
    super.dispose();
  }

  void _onTagsChanged(Set<int> newTags) {
    setState(() {
      _selectedTagIds = newTags;
    });
  }

  Future<void> _selectFirstMetDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _firstMetDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select first met date',
    );

    if (pickedDate != null) {
      setState(() {
        _firstMetDate = pickedDate;
      });
    }
  }

  void _clearFirstMetDate() {
    setState(() {
      _firstMetDate = null;
    });
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
      'selectedTagsCount': _selectedTagIds.length,
      'hasFirstMetDate': _firstMetDate != null,
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
      final tagService = Provider.of<TagService>(context, listen: false);

      int dancerId;

      if (widget.dancer != null) {
        // Editing existing dancer
        ActionLogger.logUserAction('AddDancerDialog', 'updating_dancer', {
          'dancerId': widget.dancer!.id,
          'oldName': widget.dancer!.name,
          'newName': _nameController.text.trim(),
          'firstMetDateChanged': _firstMetDate != widget.dancer!.firstMetDate,
        });

        await dancerService.updateDancer(
          widget.dancer!.id,
          name: _nameController.text.trim(),
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        );

        // Update first met date if it changed
        if (_firstMetDate != widget.dancer!.firstMetDate) {
          await dancerService.updateFirstMetDate(widget.dancer!.id, _firstMetDate);
        }

        dancerId = widget.dancer!.id;
      } else {
        // Creating new dancer
        ActionLogger.logUserAction('AddDancerDialog', 'creating_dancer', {
          'name': _nameController.text.trim(),
          'hasNotes': _notesController.text.trim().isNotEmpty,
        });

        dancerId = await dancerService.createDancer(
          name: _nameController.text.trim(),
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        );
      }

      // Save tags
      await tagService.setDancerTags(dancerId, _selectedTagIds.toList());

      // If we're adding during an event and "already danced" is checked
      if (widget.eventId != null && _alreadyDanced && widget.dancer == null) {
        ActionLogger.logUserAction('AddDancerDialog', 'recording_dance_during_creation', {
          'eventId': widget.eventId!,
          'dancerId': dancerId,
          'hasImpression': _impressionController.text.trim().isNotEmpty,
        });

        final attendanceService = Provider.of<AttendanceService>(context, listen: false);
        await attendanceService.createAttendanceWithDance(
          eventId: widget.eventId!,
          dancerId: dancerId,
          impression: _impressionController.text.trim().isNotEmpty ? _impressionController.text.trim() : null,
        );
      }

      if (mounted) {
        ActionLogger.logUserAction('AddDancerDialog', 'save_completed', {
          'isEditing': widget.dancer != null,
          'dancerId': dancerId,
          'eventId': widget.eventId,
          'savedTagsCount': _selectedTagIds.length,
        });

        Navigator.pop(context, true); // Return true to indicate success
        ToastHelper.showSuccess(
            context, widget.dancer != null ? 'Dancer updated successfully!' : 'Dancer added successfully!');
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
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    // Move focus to notes field
                    FocusScope.of(context).nextFocus();
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    border: const OutlineInputBorder(),
                    hintText: 'e.g., Great lead, loves spins',
                    suffixIcon: _notesController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _notesController.clear();
                              });
                            },
                            tooltip: 'Clear notes',
                          )
                        : null,
                  ),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (_formKey.currentState?.validate() == true) {
                      _saveDancer();
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      // Trigger rebuild to show/hide clear button
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Show "already danced" option only when adding during an event
                if (isEventContext && !isEditing) ...[
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('Already danced with this person'),
                    value: _alreadyDanced,
                    onChanged: (value) {
                      ActionLogger.logUserAction('AddDancerDialog', 'already_danced_toggled', {
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
                    const SizedBox(height: 16),
                  ],
                ],

                // Tag selection
                TagSelectionWidget(
                  selectedTagIds: _selectedTagIds,
                  onTagsChanged: _onTagsChanged,
                  dancerId: widget.dancer?.id,
                ),

                // First met date picker (only when editing existing dancers)
                if (isEditing) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'First Met Date',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Set explicit date for when you first met (if before event tracking)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _selectFirstMetDate,
                                  icon: const Icon(Icons.edit_calendar),
                                  label: Text(_firstMetDate != null
                                      ? DateFormat('MMM d, yyyy').format(_firstMetDate!)
                                      : 'Select Date'),
                                ),
                              ),
                              if (_firstMetDate != null) ...[
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: _clearFirstMetDate,
                                  icon: const Icon(Icons.clear),
                                  tooltip: 'Clear date',
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  ActionLogger.logUserAction('AddDancerDialog', 'dialog_cancelled', {
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
