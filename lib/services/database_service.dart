import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import '../models/completed_workout.dart';

class DatabaseService {

  // =========================================================
  // SINGLETON
  // =========================================================

  static final DatabaseService instance =
      DatabaseService._constructor();

  static Database? _database;

  DatabaseService._constructor();

  // =========================================================
  // GET DATABASE
  // =========================================================

  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }

    _database = await getDatabase();

    return _database!;
  }

  // =========================================================
  // INIT DATABASE
  // =========================================================

  Future<Database> getDatabase() async {

    final databaseDirPath =
        await getDatabasesPath();

    final databasePath = join(
      databaseDirPath,
      'fitness.db',
    );

    final database = await openDatabase(

      databasePath,

      version: 1,

      onCreate: (db, version) async {

        await db.execute('''
          CREATE TABLE completed_workouts (

            id INTEGER PRIMARY KEY AUTOINCREMENT,

            routineName TEXT NOT NULL,

            date TEXT NOT NULL,

            duration INTEGER NOT NULL

          )
        ''');
      },
    );

    return database;
  }

  // =========================================================
  // INSERT WORKOUT
  // =========================================================

  Future<void> insertWorkout(
    CompletedWorkout workout,
  ) async {

    final db = await database;

    await db.insert(

      'completed_workouts',

      {
        'routineName': workout.routineName,
        'date': workout.date,
        'duration': workout.duration,
      },
    );
  }

  // =========================================================
  // GET WORKOUTS
  // =========================================================

  Future<List<CompletedWorkout>>
      getWorkouts() async {

    final db = await database;

    final data =
        await db.query('completed_workouts');

    return data.map((workout) {

      return CompletedWorkout(

        routineName:
            workout['routineName'] as String,

        date:
            workout['date'] as String,

        duration:
            workout['duration'] as int,

      );
    }).toList();
  }

  // =========================================================
  // DELETE ALL WORKOUTS
  // =========================================================

  Future<void> clearWorkouts() async {

    final db = await database;

    await db.delete('completed_workouts');
  }
}