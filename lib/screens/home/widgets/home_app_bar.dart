import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/tag_service.dart';
import '../../../utils/action_logger.dart';
import '../../dancers/dancers_screen.dart';
import '../../settings/tabs/tags_screen.dart';
import '../services/home_navigation_service.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final tagService = Provider.of<TagService>(context);
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
                navigationService.importEvents(context);
                break;
              case 'settings':
                navigationService.navigateToSettings(context);
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
            const PopupMenuItem<String>(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
