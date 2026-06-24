class CompletedWorkout {
  final int? id;

  final String routineName;

  final String date;

  final int duration;

  final int calories;

  CompletedWorkout({
    this.id,

    required this.routineName,

    required this.date,

    required this.duration,

    this.calories = 100,
  });

  // =========================================================
  // TO MAP
  // =========================================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'routineName': routineName,

      'date': date,

      'duration': duration,

      'calories': calories,
    };
  }

  // =========================================================
  // FROM MAP
  // =========================================================

  factory CompletedWorkout.fromMap(Map<String, dynamic> map) {
    return CompletedWorkout(
      id: map['id'],

      routineName: map['routineName'],

      date: map['date'],

      duration: map['duration'],

      calories: map['calories'] ?? 100,
    );
  }
}
