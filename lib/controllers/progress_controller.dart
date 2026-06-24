import '../models/completed_workout.dart';
import '../services/database_service.dart';

class WeeklyWorkoutData {
  final String day;
  final int workouts;

  WeeklyWorkoutData({required this.day, required this.workouts});
}

class ProgressSummary {
  final List<CompletedWorkout> workouts;
  final int totalWorkouts;
  final int totalMinutes;
  final int estimatedCalories;
  final List<WeeklyWorkoutData> weeklyData;

  ProgressSummary({
    required this.workouts,
    required this.totalWorkouts,
    required this.totalMinutes,
    required this.estimatedCalories,
    required this.weeklyData,
  });
}

class ProgressController {
  Future<ProgressSummary> loadProgressData() async {
    final workouts = await DatabaseService.instance.getWorkouts();

    final totalWorkouts = workouts.length;

    final totalMinutes = workouts.fold<int>(
      0,
      (sum, workout) => sum + workout.duration,
    );

    final estimatedCalories = workouts.fold<int>(
      0,
      (sum, workout) => sum + workout.calories,
    );

    final weeklyData = _buildWeeklyData(workouts);

    return ProgressSummary(
      workouts: workouts,
      totalWorkouts: totalWorkouts,
      totalMinutes: totalMinutes,
      estimatedCalories: estimatedCalories,
      weeklyData: weeklyData,
    );
  }

  List<WeeklyWorkoutData> _buildWeeklyData(List<CompletedWorkout> workouts) {
    final counters = List<int>.filled(7, 0);

    for (final workout in workouts) {
      final date = _parseWorkoutDate(workout.date);

      if (date != null) {
        final index = date.weekday - 1;
        counters[index]++;
      }
    }

    return [
      WeeklyWorkoutData(day: 'Mon', workouts: counters[0]),
      WeeklyWorkoutData(day: 'Tue', workouts: counters[1]),
      WeeklyWorkoutData(day: 'Wed', workouts: counters[2]),
      WeeklyWorkoutData(day: 'Thu', workouts: counters[3]),
      WeeklyWorkoutData(day: 'Fri', workouts: counters[4]),
      WeeklyWorkoutData(day: 'Sat', workouts: counters[5]),
      WeeklyWorkoutData(day: 'Sun', workouts: counters[6]),
    ];
  }

  DateTime? _parseWorkoutDate(String date) {
    try {
      final parts = date.split('/');

      if (parts.length != 3) {
        return null;
      }

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }
}
