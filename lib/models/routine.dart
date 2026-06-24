class Routine {
  final int? id;

  final String name;

  final String difficulty;

  final int duration;

  final List<String> exercises;

  Routine({
    this.id,
    required this.name,
    required this.difficulty,
    required this.duration,
    required this.exercises,
  });

  factory Routine.fromMap(Map<String, dynamic> map) {
    return Routine(
      id: map['id'] as int?,
      name: map['name'] as String,
      difficulty: map['difficulty'] as String,
      duration: map['duration'] as int,
      exercises:
          (map['exercises'] as String)
              .split('|')
              .where((exercise) => exercise.isNotEmpty)
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'difficulty': difficulty,
      'duration': duration,
      'exercises': exercises.join('|'),
    };
  }
}
