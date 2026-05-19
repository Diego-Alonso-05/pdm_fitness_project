import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/exercise.dart';

class ExerciseApiService {

  static Future<List<Exercise>>
      fetchExercises() async {

    final url = Uri.parse(
      'https://jsonplaceholder.typicode.com/posts',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {

      final List data =
          jsonDecode(response.body);

      return data.take(15).map((item) {

        return Exercise(

          name: item['title'],

          description: item['body'],
        );

      }).toList();

    } else {

      throw Exception(
        'Failed to load exercises',
      );
    }
  }
}