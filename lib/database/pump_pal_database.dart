import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:physique/models/exercise.dart';
import 'package:physique/models/workout.dart';
import 'package:physique/models/workout_exercise.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PumpPalDatabase {
  static final PumpPalDatabase instance = PumpPalDatabase._init();

  static Database? _database;

  PumpPalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pumpPal.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final textTypeNullable = 'TEXT';
    final intTypeNotNull = 'INTEGER NOT NULL';
    final intTypeNullable = 'INTEGER';

    await db.execute('''
    CREATE TABLE $tableWorkouts (
    ${WorkoutFields.id} $idType,
    ${WorkoutFields.name} $textType,
    ${WorkoutFields.description} $textTypeNullable
    )
    ''');

    await db.execute('''
    CREATE UNIQUE INDEX idx_workout_name ON Workouts (name);
    ''');

    await db.execute('''
    CREATE TABLE $tableExercises (
    ${ExerciseFields.id} $idType,
    ${ExerciseFields.name} $textType,
    ${WorkoutFields.description} $textTypeNullable
    )
    ''');

    await db.execute('''
    CREATE UNIQUE INDEX idx_exercise_name ON Exercises (name);
    ''');

    // Load exercises from CSV file
    final exerciseCsv =
        await rootBundle.loadString('assets/megaGymDataset.csv');
    final exercises = CsvToListConverter().convert(exerciseCsv);
    for (final exercise in exercises) {
      await db.execute('''
      INSERT INTO Exercises (name, description)
      VALUES (?, ?)
    ''', [exercise[0], exercise[1]]);
    }

    await db.execute('''
    CREATE TABLE $tableWorkoutExercises (
    ${WorkoutExerciseFields.id} $idType,
    ${WorkoutExerciseFields.workout_id} $intTypeNotNull,
    ${WorkoutExerciseFields.exercise_id} $intTypeNotNull,
    ${WorkoutExerciseFields.sets} $intTypeNullable,
    ${WorkoutExerciseFields.reps} $intTypeNullable,
    FOREIGN KEY (workout_id) REFERENCES Workouts(workout_id),
    FOREIGN KEY (exercise_id) REFERENCES Exercises(exercise_id)
    )
    ''');
  }

  Future<Workout> createWorkout(Workout workout) async {
    final db = await instance.database;

    final id = await db.insert(tableWorkouts, workout.toJson());
    return workout.copy(
        id: id, name: workout.name, description: workout.description);
  }

  Future<Exercise> createExercise(Exercise exercise) async {
    final db = await instance.database;

    final id = await db.insert(tableExercises, exercise.toJson());
    return exercise.copy(
        id: id, name: exercise.name, description: exercise.description);
  }

  Future<WorkoutExercise> createWorkoutExercise(
      WorkoutExercise workoutExercise) async {
    final db = await instance.database;

    final id = await db.insert(tableWorkoutExercises, workoutExercise.toJson());
    return workoutExercise.copy(
        id: id,
        workout_id: workoutExercise.workout_id,
        exercise_id: workoutExercise.exercise_id,
        sets: workoutExercise.sets,
        reps: workoutExercise.reps);
  }

  Future<Workout> readWorkout(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableWorkouts,
      columns: WorkoutFields.values,
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Workout.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<Workout> readWorkoutByName(String name) async {
    final db = await instance.database;
    final maps = await db.query(
      tableWorkouts,
      columns: WorkoutFields.values,
      where: '${WorkoutFields.name} = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return Workout.fromJson(maps.first);
    } else {
      throw Exception('Name $name is not found');
    }
  }

  Future<Exercise> readExercise(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableExercises,
      columns: ExerciseFields.values,
      where: '${ExerciseFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Exercise.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<WorkoutExercise> readWorkoutExercise(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableWorkoutExercises,
      columns: WorkoutExerciseFields.values,
      where: '${WorkoutExerciseFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WorkoutExercise.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<WorkoutExercise> readWorkoutExerciseByWorkoutId(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableWorkoutExercises,
      columns: WorkoutExerciseFields.values,
      where: '${WorkoutExerciseFields.workout_id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WorkoutExercise.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<List<Workout>> readAllWorkouts() async {
    final db = await instance.database;
    final result = await db.query(tableWorkouts);
    return result.map((json) => Workout.fromJson(json)).toList();
  }

  Future<List<Exercise>> readAllExercises() async {
    final db = await instance.database;
    final result = await db.query(tableExercises, orderBy: 'name ASC');
    return result.map((json) => Exercise.fromJson(json)).toList();
  }

  Future<List<WorkoutExercise>> readAllWorkoutExercises() async {
    final db = await instance.database;
    final result = await db.query(tableWorkoutExercises, orderBy: 'name ASC');
    return result.map((json) => WorkoutExercise.fromJson(json)).toList();
  }

  Future<int> updateWorkout(Workout workout) async {
    final db = await instance.database;
    return db.update(
      tableWorkouts,
      workout.toJson(),
      where: '${WorkoutFields.id} = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await instance.database;
    return db.update(
      tableExercises,
      exercise.toJson(),
      where: '${ExerciseFields.id} = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> updateWorkoutExercise(WorkoutExercise workoutExercise) async {
    final db = await instance.database;
    return db.update(
      tableWorkoutExercises,
      workoutExercise.toJson(),
      where: '${WorkoutExerciseFields.id} = ?',
      whereArgs: [workoutExercise.id],
    );
  }

  Future<int> deleteWorkout(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableWorkouts,
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteExercise(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableExercises,
      where: '${ExerciseFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteWorkoutExercise(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableWorkoutExercises,
      where: '${WorkoutExerciseFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteWorkoutExercisesByWorkoutId(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableWorkoutExercises,
      where: '${WorkoutExerciseFields.workout_id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}