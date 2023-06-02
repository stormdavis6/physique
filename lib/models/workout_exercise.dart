import 'package:physique/models/workout.dart';

import 'exercise.dart';

final String tableWorkoutExercises = 'WorkoutExercises';

class WorkoutExerciseFields {
  static final List<String> values = [id, workout_id, exercise_id, sets, reps];

  static final String id = '_id';
  static final String workout_id = 'workout_id';
  static final String exercise_id = 'exercise_id';
  static final String sets = 'sets';
  static final String reps = 'reps';
}

class WorkoutExercise {
  final int? id;
  final int? workout_id;
  final int exercise_id;
  int? sets;
  List<int>? reps;

  WorkoutExercise(
      {this.id,
      this.workout_id,
      required this.exercise_id,
      this.sets,
      this.reps});

  WorkoutExercise copy({
    required int? id,
    required int? workout_id,
    required int exercise_id,
    int? sets,
    List<int>? reps,
  }) =>
      WorkoutExercise(
        id: id,
        workout_id: workout_id,
        exercise_id: exercise_id,
        sets: sets ?? this.sets,
        reps: reps ?? this.reps,
      );

  static WorkoutExercise fromJson(Map<String, Object?> json) => WorkoutExercise(
        id: json[WorkoutExerciseFields.id] as int,
        workout_id: json[WorkoutExerciseFields.workout_id] as int,
        exercise_id: json[WorkoutExerciseFields.exercise_id] as int,
        reps: json[WorkoutExerciseFields.reps]
            .toString()
            .split(',')
            .map(int.parse)
            .toList(),
        sets: json[WorkoutExerciseFields.sets] as int,
      );

  Map<String, Object?> toJson() => {
        WorkoutExerciseFields.id: id,
        WorkoutExerciseFields.exercise_id: exercise_id,
        WorkoutExerciseFields.workout_id: workout_id,
        WorkoutExerciseFields.reps: reps?.join(','),
        WorkoutExerciseFields.sets: sets
      };
}