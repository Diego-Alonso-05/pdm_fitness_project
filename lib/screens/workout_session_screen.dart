import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../models/routine.dart';
import '../models/completed_workout.dart';
import '../services/database_service.dart';

class WorkoutSessionScreen extends StatefulWidget {

  final Routine routine;

  const WorkoutSessionScreen({
    super.key,
    required this.routine,
  });

  @override
  State<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState
    extends State<WorkoutSessionScreen> {

  static const Color backgroundColor =
      Color(0xFF050505);

  static const Color cardColor =
      Color(0xFF111217);

  static const Color neonGreen =
      Color(0xFFB6FF00);

  int currentExerciseIndex = 0;

  int currentSet = 1;

  final int totalSets = 4;

  int secondsElapsed = 0;

  Timer? timer;

  @override
  void initState() {

    super.initState();

    startTimer();
  }

  @override
  void dispose() {

    timer?.cancel();

    super.dispose();
  }

  // =========================================================
  // TIMER
  // =========================================================

  void startTimer() {

    timer = Timer.periodic(

      const Duration(seconds: 1),

      (_) {

        setState(() {
          secondsElapsed++;
        });
      },
    );
  }

  String formatTime(int seconds) {

    final hours =
        (seconds ~/ 3600).toString().padLeft(2, '0');

    final minutes =
        ((seconds % 3600) ~/ 60)
            .toString()
            .padLeft(2, '0');

    final secs =
        (seconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$secs';
  }

  // =========================================================
  // ACTIONS
  // =========================================================

  void completeSet() {

    if (currentSet < totalSets) {

      setState(() {
        currentSet++;
      });

    } else {

      nextExercise();
    }
  }

  Future<void> nextExercise() async {

    if (currentExerciseIndex <
        widget.routine.exercises.length - 1) {

      setState(() {

        currentExerciseIndex++;

        currentSet = 1;
      });

    } else {

      timer?.cancel();

      // =====================================
      // SAVE TO SQLITE
      // =====================================

      final workout = CompletedWorkout(

        routineName: widget.routine.name,

        date:
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',

        duration: secondsElapsed ~/ 60,
      );

      await DatabaseService.instance
          .insertWorkout(workout);

      // =====================================
      // FINISH DIALOG
      // =====================================

      if (!mounted) return;

      showDialog(

        context: context,

        builder: (context) {

          return AlertDialog(

            backgroundColor: cardColor,

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(24),
            ),

            title: Text(
              'Workout Complete 🎉',

              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),

            content: Text(
              'Your workout has been saved locally.',

              style: GoogleFonts.inter(
                color: Colors.grey,
              ),
            ),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pop(context);

                  context.go('/history');
                },

                child: Text(
                  'Finish',

                  style: GoogleFonts.inter(
                    color: neonGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final currentExercise =
        widget.routine.exercises[
            currentExerciseIndex];

    final progress =
        (currentExerciseIndex + 1) /
            widget.routine.exercises.length;

    return Scaffold(

      backgroundColor: backgroundColor,

      body: SafeArea(

        child: SingleChildScrollView(

          physics:
              const BouncingScrollPhysics(),

          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  GestureDetector(

                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: Container(

                      padding:
                          const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: cardColor,

                        borderRadius:
                            BorderRadius.circular(
                                18),

                        border: Border.all(
                          color: neonGreen
                              .withOpacity(0.20),
                        ),
                      ),

                      child: const Icon(
                        Icons.arrow_back,
                        color: neonGreen,
                      ),
                    ),
                  ),

                  Expanded(

                    child: Center(

                      child: Text(
                        widget.routine.name,

                        overflow:
                            TextOverflow.ellipsis,

                        style:
                            GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 52),

                ],
              ),

              const SizedBox(height: 34),

              Center(

                child: Column(

                  children: [

                    Text(
                      'Workout Timer',

                      style:
                          GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    FittedBox(

                      child: Text(
                        formatTime(
                            secondsElapsed),

                        style:
                            GoogleFonts.inter(
                          color: neonGreen,
                          fontSize: 48,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 34),

              ClipRRect(

                borderRadius:
                    BorderRadius.circular(20),

                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor:
                      Colors.white10,
                  valueColor:
                      const AlwaysStoppedAnimation(
                    neonGreen,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Exercise ${currentExerciseIndex + 1} / ${widget.routine.exercises.length}',

                style: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 26),

              Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: cardColor,

                  borderRadius:
                      BorderRadius.circular(30),

                  border: Border.all(
                    color:
                        neonGreen.withOpacity(
                            0.22),
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      'Current Exercise',

                      style:
                          GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      currentExercise,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(

                      children: [

                        Expanded(
                          child:
                              buildInfoCard(
                            title: 'SET',
                            value:
                                '$currentSet / $totalSets',
                          ),
                        ),

                        const SizedBox(
                            width: 14),

                        Expanded(
                          child:
                              buildInfoCard(
                            title: 'REPS',
                            value: '12',
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 28),

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
                        const EdgeInsets
                            .symmetric(
                      vertical: 20,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              22),
                    ),
                  ),

                  onPressed: completeSet,

                  child: Text(
                    currentSet == totalSets
                        ? 'NEXT EXERCISE'
                        : 'COMPLETE SET',

                    style:
                        GoogleFonts.inter(
                      fontWeight:
                          FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required String title,
    required String value,
  }) {

    return Container(

      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 12,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF171920),

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color:
              neonGreen.withOpacity(0.16),
        ),
      ),

      child: Column(

        children: [

          Text(
            title,

            style: GoogleFonts.inter(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          FittedBox(

            child: Text(
              value,

              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

        ],
      ),
    );
  }
}