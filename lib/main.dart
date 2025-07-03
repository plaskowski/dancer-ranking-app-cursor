import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/database.dart';
import 'screens/home/home_screen.dart';
import 'services/attendance_service.dart';
import 'services/dancer/dancer_crud_service.dart';
import 'services/dancer/dancer_tag_service.dart';
import 'services/dancer_import_service.dart';
import 'services/dancer_service.dart';
import 'services/event_service.dart';
import 'services/ranking_service.dart';
import 'services/score_service.dart';
import 'services/tag_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DancerRankingApp());
}

class DancerRankingApp extends StatelessWidget {
  const DancerRankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Database instance
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, db) => db.close(),
        ),

        // Services
        ProxyProvider<AppDatabase, EventService>(
          update: (_, db, __) => EventService(db),
        ),
        ProxyProvider<AppDatabase, DancerService>(
          update: (_, db, __) => DancerService(db),
        ),
        ProxyProvider<AppDatabase, RankingService>(
          update: (_, db, __) => RankingService(db),
        ),
        ProxyProvider<AppDatabase, AttendanceService>(
          update: (_, db, __) => AttendanceService(db),
        ),
        ProxyProvider<AppDatabase, ScoreService>(
          update: (_, db, __) => ScoreService(db),
        ),
        ProxyProvider<AppDatabase, TagService>(
          update: (_, db, __) => TagService(db),
        ),
        ProxyProvider<AppDatabase, DancerImportService>(
          update: (_, db, __) => DancerImportService(db),
        ),
        ProxyProvider<AppDatabase, DancerCrudService>(
          update: (_, db, __) => DancerCrudService(db),
        ),
        ProxyProvider2<AppDatabase, DancerCrudService, DancerTagService>(
          update: (_, db, crudService, __) => DancerTagService(db, crudService),
        ),
      ],
      child: MaterialApp(
        title: 'Dancer Ranking',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
