import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import '../models/completed_workout.dart';
import '../models/exercise.dart';

class DatabaseService {
  // =========================================================
  // SINGLETON
  // =========================================================

  static final DatabaseService instance = DatabaseService._constructor();

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
    final databaseDirPath = await getDatabasesPath();

    final databasePath = join(databaseDirPath, 'fitness.db');

    final database = await openDatabase(
      databasePath,

      version: 2,

      onCreate: (db, version) async {
        await _createCompletedWorkoutsTable(db);
        await _createCachedExercisesTable(db);
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createCachedExercisesTable(db);
        }
      },
    );

    return database;
  }

  Future<void> _createCompletedWorkoutsTable(Database db) async {
    await db.execute('''
          CREATE TABLE completed_workouts (

            id INTEGER PRIMARY KEY AUTOINCREMENT,

            routineName TEXT NOT NULL,

            date TEXT NOT NULL,

            duration INTEGER NOT NULL

          )
        ''');
  }

  Future<void> _createCachedExercisesTable(Database db) async {
    await db.execute('''
          CREATE TABLE cached_exercises (

            id TEXT PRIMARY KEY,

            name TEXT NOT NULL,

            description TEXT NOT NULL,

            bodyPart TEXT NOT NULL,

            equipment TEXT NOT NULL,

            gifUrl TEXT NOT NULL,

            target TEXT NOT NULL,

            cachedAt INTEGER NOT NULL

          )
        ''');
  }

  // =========================================================
  // INSERT WORKOUT
  // =========================================================

  Future<void> insertWorkout(CompletedWorkout workout) async {
    final db = await database;

    await db.insert('completed_workouts', {
      'routineName': workout.routineName,
      'date': workout.date,
      'duration': workout.duration,
    });
  }

  // =========================================================
  // GET WORKOUTS
  // =========================================================

  Future<List<CompletedWorkout>> getWorkouts() async {
    final db = await database;

    final data = await db.query('completed_workouts');

    return data.map((workout) {
      return CompletedWorkout(
        routineName: workout['routineName'] as String,

        date: workout['date'] as String,

        duration: workout['duration'] as int,
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

  // =========================================================
  // EXERCISE CACHE
  // =========================================================

  Future<void> cacheExercises(List<Exercise> exercises) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete('cached_exercises');

      final cachedAt = DateTime.now().millisecondsSinceEpoch;

      for (final exercise in exercises) {
        await txn.insert('cached_exercises', {
          ...exercise.toMap(),
          'cachedAt': cachedAt,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Exercise>> getCachedExercises() async {
    final db = await database;

    final data = await db.query('cached_exercises', orderBy: 'name ASC');

    return data.map((exercise) {
      return Exercise.fromMap(exercise);
    }).toList();
  }
}
