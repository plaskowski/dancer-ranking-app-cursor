import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../services/event_service.dart';
import '../../../theme/theme_extensions.dart';
import '../../../utils/action_logger.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    ActionLogger.logUserAction('CreateEventScreen', 'screen_opened');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    ActionLogger.logUserAction('CreateEventScreen', 'date_picker_opened', {
      'currentDate': _selectedDate.toIso8601String(),
    });

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      ActionLogger.logUserAction('CreateEventScreen', 'date_selected', {
        'oldDate': _selectedDate.toIso8601String(),
        'newDate': picked.toIso8601String(),
      });

      setState(() {
        _selectedDate = picked;
      });
    } else {
      ActionLogger.logUserAction(
          'CreateEventScreen', 'date_selection_cancelled');
    }
  }

  Future<void> _createEvent() async {
    ActionLogger.logUserAction('CreateEventScreen', 'create_event_started', {
      'eventName': _nameController.text.trim(),
      'eventDate': _selectedDate.toIso8601String(),
      'nameLength': _nameController.text.trim().length,
    });

    if (!_formKey.currentState!.validate()) {
      ActionLogger.logUserAction('CreateEventScreen', 'validation_failed');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final eventService = Provider.of<EventService>(context, listen: false);

      final eventId = await eventService.createEvent(
        name: _nameController.text.trim(),
        date: _selectedDate,
      );

      if (mounted) {
        ActionLogger.logUserAction(
            'CreateEventScreen', 'create_event_completed', {
          'eventId': eventId,
          'eventName': _nameController.text.trim(),
          'eventDate': _selectedDate.toIso8601String(),
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Event created successfully!'),
            backgroundColor: context.danceTheme.success,
          ),
        );
      }
    } catch (e) {
      ActionLogger.logError('CreateEventScreen._createEvent', e.toString(), {
        'eventName': _nameController.text.trim(),
        'eventDate': _selectedDate.toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating event: $e'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Event Name *',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Salsa Night',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 24),

              // Date selection
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Date',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          Text(
                            DateFormat('MMM d, y').format(_selectedDate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'Change Date',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Create button
              ElevatedButton(
                onPressed: _isLoading ? null : _createEvent,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary),
                        ),
                      )
                    : const Text(
                        'CREATE EVENT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
