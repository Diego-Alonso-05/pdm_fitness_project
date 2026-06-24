import '../models/routine.dart';

final List<Routine> dummyRoutines = [
  Routine(
    name: 'Push',
    difficulty: 'Basic',
    duration: 40,
    exercises: ['Push Up', 'Bench Press', 'Shoulder Press', 'Tricep Dips'],
  ),
  Routine(
    name: 'Pull',
    difficulty: 'Basic',
    duration: 40,
    exercises: ['Pull Ups', 'Dumbbell Row', 'Lat Pulldown', 'Bicep Curl'],
  ),
  Routine(
    name: 'Legs',
    difficulty: 'Basic',
    duration: 45,
    exercises: ['Squats', 'Lunges', 'Leg Press', 'Calf Raises'],
  ),
];
