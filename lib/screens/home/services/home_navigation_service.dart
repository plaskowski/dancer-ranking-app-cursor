import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../services/event_import_service.dart';
import '../../../utils/action_logger.dart';
import '../../../utils/toast_helper.dart';
import '../../../widgets/import_events_dialog.dart';
import '../../settings/settings_screen.dart';

class HomeNavigationService {
  void importEvents(BuildContext context) {
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

  void navigateToSettings(BuildContext context) {
    ActionLogger.logUserAction('HomeScreen', 'navigate_to_settings', {
      'destination': 'SettingsScreen',
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
}
