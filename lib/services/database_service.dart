import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import '../models/completed_workout.dart';
import '../models/exercise.dart';
import '../models/routine.dart';

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

      version: 3,

      onCreate: (db, version) async {
        await _createCompletedWorkoutsTable(db);
        await _createCachedExercisesTable(db);
        await _createRoutinesTable(db);
        await _createSelectedRoutineTable(db);
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createCachedExercisesTable(db);
        }

        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE completed_workouts ADD COLUMN calories INTEGER NOT NULL DEFAULT 100',
          );
          await _createRoutinesTable(db);
          await _createSelectedRoutineTable(db);
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

            duration INTEGER NOT NULL,

            calories INTEGER NOT NULL DEFAULT 100

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
      'calories': workout.calories,
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

        calories: workout['calories'] as int? ?? 100,
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

  // =========================================================
  // ROUTINES
  // =========================================================

  Future<void> _createRoutinesTable(Database db) async {
    await db.execute('''
          CREATE TABLE custom_routines (

            id INTEGER PRIMARY KEY AUTOINCREMENT,

            name TEXT NOT NULL,

            difficulty TEXT NOT NULL,

            duration INTEGER NOT NULL,

            exercises TEXT NOT NULL

          )
        ''');
  }

  Future<void> _createSelectedRoutineTable(Database db) async {
    await db.execute('''
          CREATE TABLE selected_routine (

            id INTEGER PRIMARY KEY CHECK (id = 1),

            name TEXT NOT NULL,

            difficulty TEXT NOT NULL,

            duration INTEGER NOT NULL,

            exercises TEXT NOT NULL

          )
        ''');
  }

  Future<int> insertRoutine(Routine routine) async {
    final db = await database;

    return db.insert('custom_routines', routine.toMap());
  }

  Future<List<Routine>> getCustomRoutines() async {
    final db = await database;

    final data = await db.query('custom_routines', orderBy: 'id DESC');

    return data.map((routine) {
      return Routine.fromMap(routine);
    }).toList();
  }

  Future<void> selectRoutine(Routine routine) async {
    final db = await database;

    await db.insert('selected_routine', {
      ...routine.toMap(),
      'id': 1,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Routine?> getSelectedRoutine() async {
    final db = await database;

    final data = await db.query(
      'selected_routine',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (data.isEmpty) {
      return null;
    }

    return Routine.fromMap(data.first);
  }
}
