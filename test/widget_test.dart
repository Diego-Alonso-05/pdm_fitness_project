import 'package:flutter_test/flutter_test.dart';
import 'package:pdm_fitness_project/models/exercise.dart';

void main() {
  test('exercise can be restored from local cache data', () {
    final exercise = Exercise.fromMap({
      'id': 'push-up',
      'name': 'Push Up',
      'description': 'Bodyweight chest exercise',
      'bodyPart': 'Chest',
      'equipment': 'Body weight',
      'gifUrl': '',
      'target': 'Pectorals',
    });

    expect(exercise.name, 'Push Up');
    expect(exercise.bodyPart, 'Chest');
    expect(exercise.toMap()['target'], 'Pectorals');
  });
}
