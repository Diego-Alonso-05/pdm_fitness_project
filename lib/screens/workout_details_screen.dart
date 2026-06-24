import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/routine.dart';
import '../widgets/custom_bottom_navbar.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  final Routine routine;

  const WorkoutDetailsScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF050505);

    const cardColor = Color(0xFF111217);

    const neonGreen = Color(0xFFB6FF00);

    return Scaffold(
      backgroundColor: backgroundColor,

      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 1),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =====================================
              // BACK BUTTON
              // =====================================
              GestureDetector(
                onTap: () {
                  context.go('/routines');
                },

                child: Container(
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: cardColor,

                    borderRadius: BorderRadius.circular(18),

                    border: Border.all(
                      color: neonGreen.withValues(alpha: 0.20),
                    ),
                  ),

                  child: const Icon(Icons.arrow_back, color: neonGreen),
                ),
              ),

              const SizedBox(height: 30),

              // =====================================
              // TITLE
              // =====================================
              Text(
                routine.name,

                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: neonGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Text(
                      routine.difficulty,

                      style: GoogleFonts.inter(
                        color: neonGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Icon(Icons.timer_outlined, color: neonGreen, size: 18),

                  const SizedBox(width: 6),

                  Text(
                    '${routine.duration} min',

                    style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),

              const SizedBox(height: 34),

              // =====================================
              // EXERCISES TITLE
              // =====================================
              Text(
                'Exercises',

                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 20),

              // =====================================
              // EXERCISES LIST
              // =====================================
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),

                  itemCount: routine.exercises.length,

                  itemBuilder: (context, index) {
                    final exercise = routine.exercises[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: cardColor,

                        borderRadius: BorderRadius.circular(24),

                        border: Border.all(
                          color: neonGreen.withValues(alpha: 0.18),
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Expanded(
                            child: Text(
                              exercise,

                              overflow: TextOverflow.ellipsis,

                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          Text(
                            '4 x 12',

                            style: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // =====================================
              // START BUTTON
              // =====================================
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neonGreen,
                    foregroundColor: Colors.black,

                    padding: const EdgeInsets.symmetric(vertical: 20),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),

                  onPressed: () {
                    context.go('/session', extra: routine);
                  },

                  child: Text(
                    'START SESSION',

                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
