import 'exercise.dart';

final String tableWorkouts = 'Workouts';

class WorkoutFields {
  static final List<String> values = [id, name, description];

  static final String id = '_id';
  static final String name = 'name';
  static final String description = 'description';
}

class Workout {
  final int? id;
  final String name;
  final String? description;

  Workout({this.id, required this.name, this.description});

  Workout copy({
    int? id,
    required String name,
    String? description,
  }) =>
      Workout(
        id: id ?? this.id,
        name: name,
        description: description,
      );

  static Workout fromJson(Map<String, Object?> json) => Workout(
        id: json[WorkoutFields.id] as int,
        name: json[WorkoutFields.name] as String,
        description: json[WorkoutFields.description] as String?,
      );

  Map<String, Object?> toJson() => {
        WorkoutFields.id: id,
        WorkoutFields.name: name,
        WorkoutFields.description: description
      };
}