class Exercise {

  final String name;

  final String description;

  Exercise({

    required this.name,

    required this.description,
  });

  factory Exercise.fromJson(
    Map<String, dynamic> json,
  ) {

    return Exercise(

      name: json['name'] ?? 'Unknown Exercise',

      description:
          json['description'] ?? 'No description',
    );
  }
}