import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/completed_workout.dart';
import '../services/database_service.dart';
import '../widgets/custom_bottom_navbar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const Color backgroundColor = Color(0xFF050505);

  static const Color cardColor = Color(0xFF111217);

  static const Color neonGreen = Color(0xFFB6FF00);

  List<CompletedWorkout> workouts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadWorkouts();
  }

  Future<void> loadWorkouts() async {
    final data = await DatabaseService.instance.getWorkouts();

    setState(() {
      workouts = data.reversed.toList();

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 3),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Workout History',

                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Track your completed workouts',

                style: GoogleFonts.inter(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 30),

              if (isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (workouts.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'No workouts completed yet.',

                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),

                    itemCount: workouts.length,

                    itemBuilder: (context, index) {
                      final workout = workouts[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),

                        padding: const EdgeInsets.all(22),

                        decoration: BoxDecoration(
                          color: cardColor,

                          borderRadius: BorderRadius.circular(28),

                          border: Border.all(
                            color: neonGreen.withValues(alpha: 0.20),
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Expanded(
                                  child: Text(
                                    workout.routineName,

                                    overflow: TextOverflow.ellipsis,

                                    style: GoogleFonts.inter(
                                      color: Colors.white,

                                      fontSize: 22,

                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),

                                  decoration: BoxDecoration(
                                    color: neonGreen.withValues(alpha: 0.12),

                                    borderRadius: BorderRadius.circular(14),
                                  ),

                                  child: Text(
                                    '${workout.duration} min',

                                    style: GoogleFonts.inter(
                                      color: neonGreen,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: neonGreen,
                                  size: 18,
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  workout.date,

                                  style: GoogleFonts.inter(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
