import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/dummy_routines.dart';
import '../models/exercise.dart';
import '../models/routine.dart';
import '../services/database_service.dart';
import '../services/exercise_api_service.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../widgets/routine_card.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  static const backgroundColor = Color(0xFF050505);
  static const cardColor = Color(0xFF111217);
  static const neonGreen = Color(0xFFB6FF00);

  List<Routine> customRoutines = [];
  Routine? selectedRoutine;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRoutines();
  }

  Future<void> loadRoutines() async {
    final routines = await DatabaseService.instance.getCustomRoutines();
    final selected = await DatabaseService.instance.getSelectedRoutine();

    if (!mounted) return;

    setState(() {
      customRoutines = routines;
      selectedRoutine = selected;
      isLoading = false;
    });
  }

  Future<void> selectRoutine(Routine routine) async {
    await DatabaseService.instance.selectRoutine(routine);

    if (!mounted) return;

    setState(() {
      selectedRoutine = routine;
    });

    showSnackBar('${routine.name} selected');
  }

  Future<void> createRoutine(Routine routine) async {
    await DatabaseService.instance.insertRoutine(routine);

    if (!mounted) return;

    showSnackBar('${routine.name} created');
    await loadRoutines();
  }

  bool isRoutineSelected(Routine routine) {
    return selectedRoutine?.name == routine.name &&
        selectedRoutine?.exercises.join('|') == routine.exercises.join('|');
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: neonGreen,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> openCreateRoutineSheet() async {
    final routine = await showModalBottomSheet<Routine>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return const CreateRoutineSheet();
      },
    );

    if (routine != null) {
      await createRoutine(routine);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: neonGreen,
        onPressed: openCreateRoutineSheet,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Routines',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your workout plan',
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 22),
              buildRoutineIntroCard(),
              const SizedBox(height: 24),
              if (isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: neonGreen),
                  ),
                )
              else
                Expanded(
                  child: Scrollbar(
                    radius: const Radius.circular(20),
                    thickness: 4,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(right: 6),
                      children: [
                        buildSectionTitle('Predefined routines')
                            .animate()
                            .fadeIn(duration: 220.ms)
                            .slideX(begin: -0.04, end: 0),
                        ...dummyRoutines.map(buildRoutineCard),
                        const SizedBox(height: 14),
                        buildSectionTitle('Custom routines')
                            .animate(delay: 120.ms)
                            .fadeIn(duration: 220.ms)
                            .slideX(begin: -0.04, end: 0),
                        if (customRoutines.isEmpty)
                          buildEmptyCustomRoutines()
                        else
                          ...customRoutines.map(buildRoutineCard),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.06, end: 0);
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: neonGreen,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget buildRoutineIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: neonGreen.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: neonGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.bolt, color: Colors.black),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Start with Push, Pull or Legs, or create your own plan from the exercise library.',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRoutineCard(Routine routine) {
    return RoutineCard(
      routine: routine,
      isSelected: isRoutineSelected(routine),
      onSelect: () => selectRoutine(routine),
    );
  }

  Widget buildEmptyCustomRoutines() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: neonGreen.withValues(alpha: 0.18)),
      ),
      child: Text(
        'Tap + to create a routine from the exercise library.',
        style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
      ),
    );
  }
}

class CreateRoutineSheet extends StatefulWidget {
  const CreateRoutineSheet({super.key});

  @override
  State<CreateRoutineSheet> createState() => _CreateRoutineSheetState();
}

class _CreateRoutineSheetState extends State<CreateRoutineSheet> {
  static const neonGreen = Color(0xFFB6FF00);

  final selectedExercises = <String>{};
  final routineNameOptions = [
    'Full Body',
    'Strength',
    'Upper Body',
    'Lower Body',
    'Core',
  ];

  String selectedRoutineName = 'Full Body';

  late Future<List<Exercise>> exercisesFuture;

  @override
  void initState() {
    super.initState();
    exercisesFuture = ExerciseApiService.fetchExercises();
  }

  void saveRoutine() {
    if (selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: neonGreen,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Select at least one exercise',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    }

    final routine = Routine(
      name: selectedRoutineName,
      difficulty: selectedExercises.length >= 5 ? 'Hard' : 'Medium',
      duration: selectedExercises.length * 10,
      exercises: selectedExercises.toList(),
    );

    Navigator.pop(context, routine);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.92,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 54,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Create Routine',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Routine type',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    routineNameOptions.map((name) {
                      final isSelected = selectedRoutineName == name;

                      return ChoiceChip(
                        label: Text(name),
                        selected: isSelected,
                        selectedColor: neonGreen,
                        backgroundColor: const Color(0xFF171920),
                        labelStyle: GoogleFonts.inter(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? neonGreen
                                  : neonGreen.withValues(alpha: 0.20),
                        ),
                        onSelected: (_) {
                          setState(() {
                            selectedRoutineName = name;
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 14),
              Text(
                'Choose exercises from API library',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'These exercises are loaded online, cached locally, and are separate from the predefined Push/Pull/Legs routines.',
                style: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<Exercise>>(
                  future: exercisesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: neonGreen),
                      );
                    }

                    final exercises = snapshot.data ?? [];

                    if (exercises.isEmpty) {
                      return Center(
                        child: Text(
                          'No exercises available',
                          style: GoogleFonts.inter(color: Colors.grey),
                        ),
                      );
                    }

                    return Scrollbar(
                      thumbVisibility: true,
                      radius: const Radius.circular(20),
                      thickness: 4,
                      child: ListView.builder(
                        primary: false,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(right: 8, bottom: 8),
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          final isSelected = selectedExercises.contains(
                            exercise.name,
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF171920),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? neonGreen
                                        : neonGreen.withValues(alpha: 0.10),
                              ),
                            ),
                            child: CheckboxListTile(
                              dense: true,
                              value: isSelected,
                              activeColor: neonGreen,
                              checkColor: Colors.black,
                              title: Text(
                                exercise.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                exercise.bodyPart,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedExercises.add(exercise.name);
                                  } else {
                                    selectedExercises.remove(exercise.name);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neonGreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: saveRoutine,
                  child: Text(
                    'SAVE ROUTINE',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w900),
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
