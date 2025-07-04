import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

void main(List<String> args) {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Parse AppBar color from dart-define
  final Color? appBarColor = _parseAppBarColorFromDefine();

  // Configure system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set system UI mode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  runApp(DancerRankingApp(appBarColor: appBarColor));
}

/// Parse AppBar color from dart-define
/// Usage: flutter run --dart-define=APPBAR_COLOR=#FF0000
Color? _parseAppBarColorFromDefine() {
  const appBarColorDefine = String.fromEnvironment('APPBAR_COLOR');
  if (appBarColorDefine.isNotEmpty) {
    return AppTheme.parseColor(appBarColorDefine);
  }
  return null;
}

class DancerRankingApp extends StatelessWidget {
  final Color? appBarColor;

  const DancerRankingApp({super.key, this.appBarColor});

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
        theme: AppTheme.getLightTheme(appBarColor: appBarColor),
        darkTheme: AppTheme.getDarkTheme(appBarColor: appBarColor),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Ensure content is not covered by system UI
              padding: MediaQuery.of(context).padding.copyWith(
                    top: MediaQuery.of(context).padding.top,
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
