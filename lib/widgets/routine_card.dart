import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/routine.dart';

class RoutineCard extends StatelessWidget {
  final Routine routine;
  final bool isSelected;
  final VoidCallback? onSelect;

  const RoutineCard({
    super.key,
    required this.routine,
    this.isSelected = false,
    this.onSelect,
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
          color: isSelected ? neonGreen : neonGreen.withValues(alpha: 0.22),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: neonGreen.withValues(alpha: isSelected ? 0.14 : 0.05),
            blurRadius: isSelected ? 24 : 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: neonGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                      Icons.fitness_center,
                      color: neonGreen,
                      size: 22,
                    )
                    .animate(target: isSelected ? 1 : 0)
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.16, 1.16),
                      duration: 320.ms,
                    )
                    .shake(duration: 650.ms, hz: 2),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${routine.exercises.length} exercises',
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
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
            ],
          ),
          const SizedBox(height: 16),
          if (isSelected) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: neonGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'ACTIVE PLAN',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
            ).animate().fadeIn(duration: 220.ms).slideX(begin: -0.08, end: 0),
            const SizedBox(height: 14),
          ],
          Text(
            routine.exercises.join(' • '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, color: neonGreen, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${routine.duration} min',
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: neonGreen,
                      side: const BorderSide(color: neonGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: onSelect,
                    child: Text(isSelected ? 'Selected' : 'Select'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neonGreen,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      context.go('/workout', extra: routine);
                    },
                    child: const Text('Start'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.06, end: 0);
  }
}
