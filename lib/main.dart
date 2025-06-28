import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/database.dart';
import 'services/event_service.dart';
import 'services/dancer_service.dart';
import 'services/ranking_service.dart';
import 'services/attendance_service.dart';
import 'screens/home_screen.dart';

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
      ],
      child: MaterialApp(
        title: 'Dancer Ranking',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
