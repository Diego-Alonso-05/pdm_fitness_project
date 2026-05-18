import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/workout_history.dart';
import '../widgets/custom_bottom_navbar.dart';

class HistoryScreen extends StatelessWidget {

  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const backgroundColor = Color(0xFF050505);

    const cardColor = Color(0xFF111217);

    const neonGreen = Color(0xFFB6FF00);

    return Scaffold(

      backgroundColor: backgroundColor,

      bottomNavigationBar: const CustomBottomNavbar(
        currentIndex: 3,
      ),

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // =====================================
              // HEADER
              // =====================================

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

                style: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              // =====================================
              // EMPTY STATE
              // =====================================

              if (workoutHistory.isEmpty)

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

                // =====================================
                // HISTORY LIST
                // =====================================

                Expanded(

                  child: ListView.builder(

                    physics: const BouncingScrollPhysics(),

                    itemCount: workoutHistory.length,

                    itemBuilder: (context, index) {

                      final workout =
                          workoutHistory[index];

                      return Container(

                        margin:
                            const EdgeInsets.only(
                          bottom: 18,
                        ),

                        padding:
                            const EdgeInsets.all(22),

                        decoration: BoxDecoration(

                          color: cardColor,

                          borderRadius:
                              BorderRadius.circular(28),

                          border: Border.all(
                            color:
                                neonGreen.withOpacity(
                              0.20,
                            ),
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                              children: [

                                Expanded(

                                  child: Text(
                                    workout.routineName,

                                    overflow:
                                        TextOverflow
                                            .ellipsis,

                                    style:
                                        GoogleFonts.inter(
                                      color:
                                          Colors.white,

                                      fontSize: 22,

                                      fontWeight:
                                          FontWeight
                                              .w800,
                                    ),
                                  ),
                                ),

                                Container(

                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color: neonGreen
                                        .withOpacity(
                                            0.12),

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      14,
                                    ),
                                  ),

                                  child: Text(
                                    '${workout.duration} min',

                                    style:
                                        GoogleFonts.inter(
                                      color:
                                          neonGreen,

                                      fontWeight:
                                          FontWeight
                                              .bold,
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

                                  style:
                                      GoogleFonts.inter(
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