import '../models/exercise.dart';
import 'exercise_api_service.dart';

class SyncResult {
  final bool success;
  final int exerciseCount;
  final String message;

  const SyncResult({
    required this.success,
    required this.exerciseCount,
    required this.message,
  });
}

class SyncManager {
  static final SyncManager instance = SyncManager._constructor();

  SyncManager._constructor();

  Future<SyncResult> syncExercises() async {
    try {
      final List<Exercise> exercises =
          await ExerciseApiService.fetchExercises();

      return SyncResult(
        success: true,
        exerciseCount: exercises.length,
        message: 'Exercise data synchronized',
      );
    } catch (_) {
      return const SyncResult(
        success: false,
        exerciseCount: 0,
        message: 'Could not synchronize data',
      );
    }
  }
}
