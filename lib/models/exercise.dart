class Exercise {
  final String id;
  final String name;
  final String description;
  final String bodyPart;
  final String equipment;
  final String gifUrl;
  final String target;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.bodyPart,
    required this.equipment,
    required this.gifUrl,
    required this.target,
  });

  factory Exercise.fromJson(
    Map<String, dynamic> json,
  ) {
    return Exercise(
      id: json['id']?.toString() ?? '0',
      name: json['name']?.toString() ?? 'Unknown Exercise',
      description: _getDescription(json),
      bodyPart: _getFirstValue(json['primaryMuscles']),
      equipment: json['equipment']?.toString() ?? 'Unknown',
      gifUrl: '',
      target: json['force']?.toString() ?? 'General',
    );
  }

  static String _getDescription(
    Map<String, dynamic> json,
  ) {
    final instructions = json['instructions'];

    if (instructions is List &&
        instructions.isNotEmpty) {
      return instructions.join(' ');
    }

    return 'No description available';
  }

  static String _getFirstValue(
    dynamic value,
  ) {
    if (value is List &&
        value.isNotEmpty) {
      return value.first.toString();
    }

    return 'Unknown';
  }
}