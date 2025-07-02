import 'package:flutter/material.dart';

import '../../utils/action_logger.dart';
import 'tabs/general_settings_tab.dart';
import 'tabs/ranks_management_tab.dart';
import 'tabs/scores_management_tab.dart';
import 'tabs/tags_management_tab.dart';

class SettingsScreen extends StatefulWidget {
  final int initialTabIndex;

  const SettingsScreen({super.key, this.initialTabIndex = 0});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    ActionLogger.logAction('UI_SettingsScreen', 'screen_initialized', {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    ActionLogger.logAction('UI_SettingsScreen', 'screen_disposed', {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ActionLogger.logAction('UI_SettingsScreen', 'build_called', {});

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.settings),
              text: 'General',
            ),
            Tab(
              icon: Icon(Icons.military_tech),
              text: 'Ranks',
            ),
            Tab(
              icon: Icon(Icons.star_rate),
              text: 'Scores',
            ),
            Tab(
              icon: Icon(Icons.label),
              text: 'Tags',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          GeneralSettingsTab(),
          RanksManagementTab(),
          ScoresManagementTab(),
          TagsManagementTab(),
        ],
      ),
    );
  }
}
