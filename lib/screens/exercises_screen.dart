import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/exercise.dart';
import '../services/exercise_api_service.dart';
import '../widgets/custom_bottom_navbar.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  static const Color backgroundColor = Color(0xFF050505);
  static const Color cardColor = Color(0xFF111217);
  static const Color neonGreen = Color(0xFFB6FF00);
  static const Color primaryText = Colors.white;
  static const Color secondaryText = Color(0xFFD0D0D0);
  static const Color mutedText = Color(0xFF8A8A8A);

  late Future<List<Exercise>> exercises;

  @override
  void initState() {
    super.initState();
    exercises = ExerciseApiService.fetchExercises();
  }

  Future<void> refreshExercises() async {
    setState(() {
      exercises = ExerciseApiService.fetchExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: const CustomBottomNavbar(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),

              const SizedBox(height: 24),

              Expanded(
                child: FutureBuilder<List<Exercise>>(
                  future: exercises,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: neonGreen,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return buildErrorState();
                    }

                    final exerciseList = snapshot.data ?? [];

                    if (exerciseList.isEmpty) {
                      return buildEmptyState();
                    }

                    return RefreshIndicator(
                      color: neonGreen,
                      backgroundColor: cardColor,
                      onRefresh: refreshExercises,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        itemCount: exerciseList.length,
                        itemBuilder: (context, index) {
                          final exercise = exerciseList[index];

                          return buildExerciseCard(
                            exercise,
                            index,
                          );
                        },
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

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          'Discover exercises from an online API',
          style: GoogleFonts.inter(
            color: secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildExerciseCard(
    Exercise exercise,
    int index,
  ) {
    final hasImage = exercise.gifUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: neonGreen.withOpacity(0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: neonGreen.withOpacity(0.04),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTagRow(exercise),

          const SizedBox(height: 14),

          if (hasImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                exercise.gifUrl,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return buildImagePlaceholder();
                },
              ),
            )
          else
            buildImagePlaceholder(),

          const SizedBox(height: 16),

          Text(
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

          const SizedBox(height: 12),

          Text(
            exercise.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: mutedText,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          buildInfoRow(
            icon: Icons.fitness_center,
            label: 'Target',
            value: exercise.target,
          ),

          const SizedBox(height: 8),

          buildInfoRow(
            icon: Icons.sports_gymnastics,
            label: 'Equipment',
            value: exercise.equipment,
          ),
        ],
      ),
    );
  }

  Widget buildTagRow(
    Exercise exercise,
  ) {
    return Row(
      children: [
        buildTag(
          exercise.bodyPart.toUpperCase(),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildTag(
            exercise.target.toUpperCase(),
          ),
        ),
      ],
    );
  }

  Widget buildTag(
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: neonGreen.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          color: neonGreen,
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: neonGreen,
          size: 18,
        ),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            color: secondaryText,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: mutedText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImagePlaceholder() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF171920),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: neonGreen.withOpacity(0.12),
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.fitness_center,
          color: neonGreen,
          size: 42,
        ),
      ),
    );
  }

  Widget buildErrorState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.red.withOpacity(0.35),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off,
              color: Colors.red,
              size: 42,
            ),
            const SizedBox(height: 16),
            Text(
              'Could not load exercises',
              style: GoogleFonts.inter(
                color: primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: mutedText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: Colors.black,
              ),
              onPressed: refreshExercises,
              child: Text(
                'RETRY',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: neonGreen.withOpacity(0.20),
          ),
        ),
        child: Text(
          'No exercises available',
          style: GoogleFonts.inter(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}