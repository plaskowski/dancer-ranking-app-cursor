import 'package:flutter/material.dart';

import '../../../utils/action_logger.dart';
import '../../dancers/dancers_screen.dart';
import '../services/home_navigation_service.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final navigationService = HomeNavigationService();

    return AppBar(
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
        PopupMenuButton<String>(
          tooltip: 'More options',
          onSelected: (value) {
            switch (value) {
              case 'settings':
                ActionLogger.logUserAction(
                    'HomeScreen', 'navigate_to_settings', {
                  'destination': 'SettingsScreen',
                  'source': 'overflow_menu',
                });
                navigationService.navigateToSettings(context);
                break;
              case 'import_events':
                ActionLogger.logUserAction(
                    'HomeScreen', 'import_events_opened', {
                  'source': 'overflow_menu',
                });
                navigationService.importEvents(context);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'import_events',
              child: ListTile(
                leading: Icon(Icons.file_upload),
                title: Text('Import events'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
