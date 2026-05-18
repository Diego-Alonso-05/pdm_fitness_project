import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/routine.dart';

class RoutineCard extends StatelessWidget {

  final Routine routine;

  const RoutineCard({
    super.key,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {

    const neonGreen = Color(0xFFB6FF00);

    const cardColor = Color(0xFF111217);

    return Container(

      margin: const EdgeInsets.only(bottom: 18),

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(

        color: cardColor,

        borderRadius: BorderRadius.circular(28),

        border: Border.all(
          color: neonGreen.withOpacity(0.22),
        ),

      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // =====================================
          // TITLE
          // =====================================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Expanded(

                child: Text(
                  routine.name,

                  overflow: TextOverflow.ellipsis,

                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              Container(

                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: neonGreen.withOpacity(0.12),
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

            ],
          ),

          const SizedBox(height: 16),

          // =====================================
          // EXERCISES
          // =====================================

          Text(
            routine.exercises.join(' • '),

            style: GoogleFonts.inter(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          // =====================================
          // FOOTER
          // =====================================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Row(

                children: [

                  const Icon(
                    Icons.timer_outlined,
                    color: neonGreen,
                    size: 18,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    '${routine.duration} min',

                    style: GoogleFonts.inter(
                      color: Colors.white,
                    ),
                  ),

                ],
              ),

              ElevatedButton(

                style: ElevatedButton.styleFrom(

                  backgroundColor: neonGreen,
                  foregroundColor: Colors.black,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                onPressed: () {

                  context.go(
                    '/workout',
                    extra: routine,
                  );
                },

                child: const Text('Start'),
              ),

            ],
          ),

        ],
      ),
    );
  }
}