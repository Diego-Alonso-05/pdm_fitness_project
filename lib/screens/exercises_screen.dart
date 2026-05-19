import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/exercise.dart';
import '../services/exercise_api_service.dart';
import '../widgets/custom_bottom_navbar.dart';

class ExercisesScreen extends StatefulWidget {

  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() =>
      _ExercisesScreenState();
}

class _ExercisesScreenState
    extends State<ExercisesScreen> {

  // =========================================================
  // COLORS
  // =========================================================

  static const Color backgroundColor =
      Color(0xFF050505);

  static const Color cardColor =
      Color(0xFF111217);

  static const Color neonGreen =
      Color(0xFFB6FF00);

  static const Color primaryText =
      Colors.white;

  static const Color secondaryText =
      Color(0xFFD0D0D0);

  static const Color mutedText =
      Color(0xFF8A8A8A);

  // =========================================================
  // STATE
  // =========================================================

  late Future<List<Exercise>> exercises;

  @override
  void initState() {

    super.initState();

    exercises =
        ExerciseApiService.fetchExercises();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: backgroundColor,

      bottomNavigationBar:
          const CustomBottomNavbar(
        currentIndex: 1,
      ),

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // =====================================
              // TITLE
              // =====================================

              Text(
                'Exercise\nLibrary',

                style: GoogleFonts.inter(
                  color: primaryText,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Discover new exercises from online API',

                style: GoogleFonts.inter(
                  color: secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              // =====================================
              // LIST
              // =====================================

              Expanded(

                child: FutureBuilder<
                    List<Exercise>>(

                  future: exercises,

                  builder:
                      (context, snapshot) {

                    // LOADING

                    if (snapshot.connectionState ==
                        ConnectionState
                            .waiting) {

                      return const Center(
                        child:
                            CircularProgressIndicator(
                          color: neonGreen,
                        ),
                      );
                    }

                    // ERROR

                    if (snapshot.hasError) {

                      return Center(

                        child: Text(
                          'Failed to load exercises',

                          style:
                              GoogleFonts.inter(
                            color: primaryText,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    // DATA

                    final exerciseList =
                        snapshot.data ?? [];

                    return ListView.builder(

                      physics:
                          const BouncingScrollPhysics(),

                      padding:
                          const EdgeInsets.only(
                        bottom: 20,
                      ),

                      itemCount:
                          exerciseList.length,

                      itemBuilder:
                          (context, index) {

                        final exercise =
                            exerciseList[index];

                        return buildExerciseCard(
                          exercise,
                          index,
                        );
                      },
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

  // =========================================================
  // EXERCISE CARD
  // =========================================================

  Widget buildExerciseCard(
    Exercise exercise,
    int index,
  ) {

    final muscleGroups = [

      'FULL BODY',
      'CHEST',
      'BACK',
      'LEGS',
      'SHOULDERS',
      'ARMS',
      'CORE',
    ];

    final muscle =
        muscleGroups[
            index % muscleGroups.length];

    return Container(

      margin:
          const EdgeInsets.only(bottom: 16),

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: cardColor,

        borderRadius:
            BorderRadius.circular(28),

        border: Border.all(
          color:
              neonGreen.withOpacity(0.18),
        ),

        boxShadow: [

          BoxShadow(
            color:
                neonGreen.withOpacity(0.04),
            blurRadius: 16,
          ),

        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // =====================================
          // TAG
          // =====================================

          Container(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration: BoxDecoration(

              color:
                  neonGreen.withOpacity(0.10),

              borderRadius:
                  BorderRadius.circular(14),
            ),

            child: Text(
              muscle,

              style: GoogleFonts.inter(
                color: neonGreen,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 0.8,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // =====================================
          // TITLE
          // =====================================

          SizedBox(

            height: 52,

            child: Text(
              exercise.name.toUpperCase(),

              maxLines: 2,

              overflow: TextOverflow.ellipsis,

              style: GoogleFonts.inter(
                color: primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // =====================================
          // DESCRIPTION
          // =====================================

          Text(
            exercise.description,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            style: GoogleFonts.inter(
              color: mutedText,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          // =====================================
          // BUTTON
          // =====================================

          SizedBox(

            width: double.infinity,

            child: ElevatedButton(

              style:
                  ElevatedButton.styleFrom(

                backgroundColor:
                    neonGreen,

                foregroundColor:
                    Colors.black,

                padding:
                    const EdgeInsets.symmetric(
                  vertical: 14,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          18),
                ),
              ),

              onPressed: () {},

              child: Text(
                'START EXERCISE',

                style: GoogleFonts.inter(
                  fontWeight:
                      FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}