import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/exercise.dart';

class ExerciseApiService {
  static const String baseUrl =
      'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json';

  static Future<List<Exercise>>
      fetchExercises() async {
    try {
      final url = Uri.parse(baseUrl);

      final response =
          await http.get(url);

      if (response.statusCode != 200) {
        throw Exception(
          'API Error ${response.statusCode}',
        );
      }

      final List data =
          jsonDecode(response.body);

      return data.take(20).map((item) {
        return Exercise.fromJson(
          Map<String, dynamic>.from(item),
        );
      }).toList();
    } catch (error) {
      print(
        'API ERROR: $error',
      );

      return _fallbackExercises();
    }
  }

  static List<Exercise>
      _fallbackExercises() {
    return [
      Exercise(
        id: 'offline-1',
        name: 'Push Up',
        description:
            'A bodyweight exercise focused on chest, shoulders and triceps.',
        bodyPart: 'Chest',
        equipment: 'Body weight',
        gifUrl: '',
        target: 'Pectorals',
      ),
      Exercise(
        id: 'offline-2',
        name: 'Squat',
        description:
            'A lower body exercise focused on legs and glutes.',
        bodyPart: 'Legs',
        equipment: 'Body weight',
        gifUrl: '',
        target: 'Quadriceps',
      ),
      Exercise(
        id: 'offline-3',
        name: 'Plank',
        description:
            'A core stability exercise used to strengthen abdominal muscles.',
        bodyPart: 'Core',
        equipment: 'Body weight',
        gifUrl: '',
        target: 'Abs',
      ),
      Exercise(
        id: 'offline-4',
        name: 'Pull Up',
        description:
            'An upper body exercise focused mainly on back and arms.',
        bodyPart: 'Back',
        equipment: 'Pull-up bar',
        gifUrl: '',
        target: 'Lats',
      ),
      Exercise(
        id: 'offline-5',
        name: 'Lunge',
        description:
            'A unilateral leg exercise useful for strength and balance.',
        bodyPart: 'Legs',
        equipment: 'Body weight',
        gifUrl: '',
        target: 'Glutes',
      ),
    ];
  }
}