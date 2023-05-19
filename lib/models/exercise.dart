final String tableExercises = 'Exercises';

class ExerciseFields {
  static final List<String> values = [id, name, description];

  static final String id = '_id';
  static final String name = 'name';
  static final String description = 'description';
}

class Exercise {
  final int? id;
  String name;
  String? description;
  bool isSelected = false;

  Exercise({this.id, required this.name, this.description});

  Exercise copy({
    required int id,
    required String name,
    required String? description,
  }) =>
      Exercise(
        id: id,
        name: name,
        description: description ?? this.description,
      );

  static Exercise fromJson(Map<String, Object?> json) => Exercise(
        id: json[ExerciseFields.id] as int,
        name: json[ExerciseFields.name] as String,
        description: json[ExerciseFields.description] as String?,
      );

  Map<String, Object?> toJson() => {
        ExerciseFields.id: id,
        ExerciseFields.name: name,
        ExerciseFields.description: description,
      };
}