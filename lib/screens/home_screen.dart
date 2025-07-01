import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/event_import_service.dart';
import '../services/event_service.dart';
import '../services/tag_service.dart';
import '../utils/action_logger.dart';
import '../utils/toast_helper.dart';
import '../widgets/import_events_dialog.dart';
import 'create_event_screen.dart';
import 'dancers_screen.dart';
import 'event_screen.dart';
import 'rank_editor_screen.dart';
import 'tags_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventService = Provider.of<EventService>(context);
    final tagService = Provider.of<TagService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Manage Dancers',
            onPressed: () {
              ActionLogger.logUserAction('HomeScreen', 'navigate_to_dancers', {
                'destination': 'DancersScreen',
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DancersScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.star_border),
            tooltip: 'Manage Ranks',
            onPressed: () {
              ActionLogger.logUserAction('HomeScreen', 'navigate_to_ranks', {
                'destination': 'RankEditorScreen',
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RankEditorScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.label),
            tooltip: 'Manage Tags',
            onPressed: () {
              ActionLogger.logUserAction('HomeScreen', 'navigate_to_tags', {
                'destination': 'TagsScreen',
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TagsScreen(tagService: tagService),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
            onSelected: (value) {
              switch (value) {
                case 'import_events':
                  _importEvents(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'import_events',
                child: ListTile(
                  leading: Icon(Icons.file_upload),
                  title: Text('Import Events'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<Event>>(
        stream: eventService.watchAllEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No events yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to create your first event',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _EventCard(event: event);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ActionLogger.logUserAction('HomeScreen', 'navigate_to_create_event', {
            'destination': 'CreateEventScreen',
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateEventScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _importEvents(BuildContext context) {
    ActionLogger.logUserAction('HomeScreen', 'import_events_dialog_opened', {});

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      pageBuilder: (context, animation, secondaryAnimation) => Provider(
        create: (context) => EventImportService(
          Provider.of<AppDatabase>(context, listen: false),
        ),
        child: const Dialog.fullscreen(
          child: ImportEventsDialog(),
        ),
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation.drive(Tween(begin: 0.9, end: 1.0)),
            child: child,
          ),
        );
      },
    ).then((result) {
      if (result == true) {
        ActionLogger.logUserAction('HomeScreen', 'import_events_completed', {});
        ToastHelper.showSuccess(context, 'Events imported successfully');
      }
    });
  }
}

class _EventCard extends StatelessWidget {
  final Event event;

  const _EventCard({required this.event});

  void _showContextMenu(BuildContext context) {
    ActionLogger.logUserAction('EventCard', 'context_menu_opened', {
      'eventId': event.id,
      'eventName': event.name,
      'eventDate': event.date.toIso8601String(),
    });

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Rename'),
                onTap: () {
                  ActionLogger.logUserAction('EventCard', 'context_rename_tapped', {
                    'eventId': event.id,
                    'eventName': event.name,
                  });

                  Navigator.pop(context);
                  _showRenameDialog(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text('Change Date'),
                onTap: () {
                  ActionLogger.logUserAction('EventCard', 'context_change_date_tapped', {
                    'eventId': event.id,
                    'eventName': event.name,
                    'currentDate': event.date.toIso8601String(),
                  });

                  Navigator.pop(context);
                  _showChangeDateDialog(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const Text('Delete'),
                onTap: () {
                  ActionLogger.logUserAction('EventCard', 'context_delete_tapped', {
                    'eventId': event.id,
                    'eventName': event.name,
                  });

                  Navigator.pop(context);
                  _showDeleteDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    ActionLogger.logUserAction('EventCard', 'rename_dialog_opened', {
      'eventId': event.id,
      'currentName': event.name,
    });

    final controller = TextEditingController(text: event.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Event'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Event name',
            hintText: 'Enter new event name',
          ),
          autofocus: true,
          onSubmitted: (_) => _performRename(context, controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _performRename(context, controller),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showChangeDateDialog(BuildContext context) async {
    ActionLogger.logUserAction('EventCard', 'change_date_dialog_opened', {
      'eventId': event.id,
      'currentDate': event.date.toIso8601String(),
    });

    // Get EventService reference before showing dialog to avoid context issues
    final eventService = Provider.of<EventService>(context, listen: false);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: event.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select event date',
    );

    if (selectedDate != null) {
      ActionLogger.logUserAction('EventCard', 'date_selected', {
        'eventId': event.id,
        'newDate': selectedDate.toIso8601String(),
        'oldDate': event.date.toIso8601String(),
      });

      _performDateChange(context, selectedDate, eventService);
    } else {
      ActionLogger.logUserAction('EventCard', 'date_change_cancelled', {
        'eventId': event.id,
      });
    }
  }

  void _performDateChange(BuildContext context, DateTime newDate, EventService eventService) async {
    ActionLogger.logUserAction('EventCard', 'date_change_started', {
      'eventId': event.id,
      'newDate': newDate.toIso8601String(),
      'oldDate': event.date.toIso8601String(),
    });

    try {
      final success = await eventService.updateEvent(event.id, date: newDate);

      if (context.mounted) {
        if (success) {
          ActionLogger.logUserAction('EventCard', 'date_change_completed', {
            'eventId': event.id,
            'newDate': newDate.toIso8601String(),
          });

          final formattedDate = DateFormat('MMM d, y').format(newDate);
          ToastHelper.showSuccess(context, 'Event date changed to $formattedDate');
        } else {
          ActionLogger.logError('EventCard.performDateChange', 'update_failed', {
            'eventId': event.id,
            'newDate': newDate.toIso8601String(),
          });
          ToastHelper.showError(context, 'Failed to change event date');
        }
      }
    } catch (e) {
      ActionLogger.logError('EventCard.performDateChange', e.toString(), {
        'eventId': event.id,
        'newDate': newDate.toIso8601String(),
      });
      if (context.mounted) {
        ToastHelper.showError(context, 'Error changing event date: $e');
      }
    }
  }

  void _performRename(BuildContext context, TextEditingController controller) async {
    final newName = controller.text.trim();
    if (newName.isEmpty) {
      ActionLogger.logUserAction('EventCard', 'rename_validation_failed', {
        'eventId': event.id,
        'reason': 'empty_name',
      });
      return;
    }

    ActionLogger.logUserAction('EventCard', 'rename_started', {
      'eventId': event.id,
      'oldName': event.name,
      'newName': newName,
    });

    try {
      final eventService = Provider.of<EventService>(context, listen: false);
      final success = await eventService.updateEvent(event.id, name: newName);

      if (context.mounted) {
        Navigator.pop(context);
        if (success) {
          ActionLogger.logUserAction('EventCard', 'rename_completed', {
            'eventId': event.id,
            'newName': newName,
          });
          ToastHelper.showSuccess(context, 'Event renamed to "$newName"');
        } else {
          ActionLogger.logError('EventCard.performRename', 'update_failed', {
            'eventId': event.id,
            'newName': newName,
          });
          ToastHelper.showError(context, 'Failed to rename event');
        }
      }
    } catch (e) {
      ActionLogger.logError('EventCard.performRename', e.toString(), {
        'eventId': event.id,
        'newName': newName,
      });
      if (context.mounted) {
        Navigator.pop(context);
        ToastHelper.showError(context, 'Error renaming event: $e');
      }
    }
  }

  void _showDeleteDialog(BuildContext context) {
    ActionLogger.logUserAction('EventCard', 'delete_dialog_opened', {
      'eventId': event.id,
      'eventName': event.name,
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text(
          'Are you sure you want to delete "${event.name}"?\n\nThis will also delete all associated rankings and attendance records. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _performDelete(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _performDelete(BuildContext context) async {
    ActionLogger.logUserAction('EventCard', 'delete_started', {
      'eventId': event.id,
      'eventName': event.name,
    });

    try {
      final eventService = Provider.of<EventService>(context, listen: false);
      final deletedCount = await eventService.deleteEvent(event.id);

      if (context.mounted) {
        Navigator.pop(context);
        if (deletedCount > 0) {
          ActionLogger.logUserAction('EventCard', 'delete_completed', {
            'eventId': event.id,
            'eventName': event.name,
          });
          ToastHelper.showSuccess(context, 'Event "${event.name}" deleted');
        } else {
          ToastHelper.showError(context, 'Failed to delete event');
        }
      }
    } catch (e) {
      ActionLogger.logError('EventCard.performDelete', e.toString(), {
        'eventId': event.id,
        'eventName': event.name,
      });
      if (context.mounted) {
        Navigator.pop(context);
        ToastHelper.showError(context, 'Error deleting event: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM d, y').format(event.date);
    final isPast = event.date.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          ActionLogger.logUserAction('EventCard', 'event_tapped', {
            'eventId': event.id,
            'eventName': event.name,
            'eventDate': event.date.toIso8601String(),
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventScreen(eventId: event.id),
            ),
          );
        },
        onLongPress: () => _showContextMenu(context),
        child: ListTile(
          title: Text(
            event.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isPast ? Theme.of(context).colorScheme.onSurfaceVariant : null,
            ),
          ),
          subtitle: Text(
            formattedDate,
            style: TextStyle(
              color: isPast ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
