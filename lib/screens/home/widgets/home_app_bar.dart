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
          icon: const Icon(Icons.people_outlined),
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
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Settings',
          onPressed: () {
            ActionLogger.logUserAction('HomeScreen', 'navigate_to_settings', {
              'destination': 'SettingsScreen',
              'source': 'app_bar',
            });
            navigationService.navigateToSettings(context);
          },
        ),
      ],
    );
  }
}
