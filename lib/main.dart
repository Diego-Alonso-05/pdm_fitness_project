import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/routine.dart';

import 'screens/workout_session_screen.dart';
import 'screens/home_screen.dart';
import 'screens/routines_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/history_screen.dart';
import 'screens/workout_details_screen.dart';

void main() {
  runApp(const MyApp());
}

// =========================================================
// ROUTER
// =========================================================

final GoRouter router = GoRouter(

  initialLocation: '/',

  routes: [

    // HOME

    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    // ROUTINES

    GoRoute(
      path: '/routines',
      builder: (context, state) => const RoutinesScreen(),
    ),

    // PROGRESS

    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),

    // HISTORY

    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),

    // WORKOUT DETAILS

    GoRoute(

      path: '/workout',

      builder: (context, state) {

        final routine = state.extra as Routine;

        return WorkoutDetailsScreen(
          routine: routine,
        );
      },
    ),
    GoRoute(

  path: '/session',

  builder: (context, state) {

    final routine = state.extra as Routine;

    return WorkoutSessionScreen(
      routine: routine,
    );
  },
),

  ],
);

// =========================================================
// APP
// =========================================================

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(

      debugShowCheckedModeBanner: false,

      title: 'FIT-NESS',

      theme: ThemeData(

        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(0xFF050505),

        primaryColor: const Color(0xFFB6FF00),

        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB6FF00),
          brightness: Brightness.dark,
        ),
      ),

      routerConfig: router,
    );
  }
}