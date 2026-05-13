import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/routines_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/routines',
      builder: (context, state) => const RoutinesScreen(),
    ),

    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),

    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),

  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}