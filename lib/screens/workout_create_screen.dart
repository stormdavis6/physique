import 'package:flutter/material.dart';
import 'package:physique/models/exercise.dart';
import 'package:physique/models/workout_exercise.dart';
import 'package:physique/widgets/add_exercises_popup.dart';

import '../constants.dart';
import '../database/pump_pal_database.dart';
import '../models/workout.dart';
import '../widgets/exercise_card.dart';

List<WorkoutExercise> workoutExercises = [];

class WorkoutCreateScreen extends StatefulWidget {
  const WorkoutCreateScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutCreateScreen> createState() => _WorkoutCreateScreenState();
}

class _WorkoutCreateScreenState extends State<WorkoutCreateScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late FocusNode nameFocusNode;
  late FocusNode descriptionFocusNode;
  List<Exercise> exercises = [];
  bool _validate = false;

  @override
  void initState() {
    nameController = TextEditingController();
    nameController.addListener(() => setState(() {}));

    descriptionController = TextEditingController();
    descriptionController.addListener(() => setState(() {}));

    nameFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    nameController.dispose();
    descriptionController.dispose();
    nameFocusNode.dispose();
    descriptionFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: BoxDecoration(
              color: kBlueLightColor,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Color(0xFFb3a5dc),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'New Workout',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Color(0xFFb3a5dc),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () async {
                          if (nameController.text.isEmpty) {
                            setState(() {
                              _validate = true;
                            });
                          } else if (exercises.isEmpty) {
                            final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                elevation: 3,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                content: Text(
                                  'You must add at least 1 exercise',
                                  textAlign: TextAlign.center,
                                ));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            Workout newWorkout = Workout(
                                name: nameController.text,
                                description: descriptionController.text);
                            if (newWorkout.name.isNotEmpty) {
                              newWorkout = await PumpPalDatabase.instance
                                  .createWorkout(newWorkout);
                              // print(workoutExercises[0].reps?.join(','));
                              for (int i = 0;
                                  i < workoutExercises.length;
                                  i++) {
                                WorkoutExercise workoutExercise =
                                    WorkoutExercise(
                                        workout_id: newWorkout.id,
                                        exercise_id:
                                            workoutExercises[i].exercise_id,
                                        sets: workoutExercises[i].sets,
                                        reps: workoutExercises[i].reps);
                                workoutExercise = await PumpPalDatabase.instance
                                    .createWorkoutExercise(workoutExercise);
                                print(
                                    'Added workout exercise --> ID: ${workoutExercise.id}, Workout_ID: ${workoutExercise.workout_id}, Exercise_ID: ${workoutExercise.exercise_id}, Sets: ${workoutExercise.sets}');
                              }
                            }
                            Navigator.pop(context, true);
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      TextField(
                        focusNode: nameFocusNode,
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: 'Workout name',
                            hintStyle: TextStyle(
                              fontSize: 20,
                            ),
                            suffixIcon: nameController.text.isEmpty
                                ? Container(
                                    width: 0,
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.grey[700],
                                    ),
                                    onPressed: () => nameController.clear(),
                                  ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorText:
                                _validate ? 'Workout name is required' : null),
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty
                                ? _validate = true
                                : _validate = false;
                          });
                        },
                      ),
                    ],
                  ),
                  TextField(
                    focusNode: descriptionFocusNode,
                    controller: descriptionController,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Workout description',
                      hintStyle: TextStyle(
                        fontSize: 15,
                      ),
                      suffixIcon: descriptionController.text.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.grey[700],
                              ),
                              onPressed: () => descriptionController.clear(),
                            ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  exercises.isEmpty
                      ? Container(
                          width: 0,
                          height: 0,
                        )
                      : Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: exercises.length,
                              itemBuilder: (BuildContext context, int index) {
                                final exercise = exercises[index];
                                final workoutExercise = workoutExercises[index];
                                return ExerciseDetailsCard(
                                  workoutExercise: workoutExercise,
                                  exercise: exercise,
                                  confirmDismissPressed: () {
                                    exercises.remove(exercise);
                                    workoutExercises.remove(workoutExercise);
                                    Navigator.pop(context, true);
                                    print(workoutExercises.length);
                                  },
                                  dismissDirection: DismissDirection.endToStart,
                                );
                              }),
                        ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Color(0xFFb3a5dc),
                      minimumSize: const Size.fromHeight(30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: () async {
                      for (int i = 0; i < exercises.length; i++) {
                        print('Sending Exercise: ${exercises[i].name}');
                      }
                      for (int i = 0; i < workoutExercises.length; i++) {
                        print(
                            'Sending Workout Exercise: ${workoutExercises[i].exercise_id} w/ ${workoutExercises[i].sets} sets');
                      }
                      dynamic result = await showDialog(
                        context: context,
                        builder: (BuildContext context) => AddExercisesPopup(
                            currentExercises: exercises,
                            currentWorkoutExercises: workoutExercises),
                      );
                      setState(() {
                        if (result != -1 && result != null) {
                          exercises = result.selectedExercises;
                          workoutExercises = result.selectedWorkoutExercises;
                        }
                      });
                      for (int i = 0; i < exercises.length; i++) {
                        print(
                            'Received Exercise: ${exercises[i].name} w/ Exercise ID: ${exercises[i].id}');
                      }
                      for (int i = 0; i < workoutExercises.length; i++) {
                        print(
                            'Received Exercise Sets: ${workoutExercises[i].sets}');
                      }
                    },
                    child: Text('Add Exercises'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseDetailsCard extends StatefulWidget {
  final Exercise exercise;
  final WorkoutExercise workoutExercise;
  final VoidCallback confirmDismissPressed;
  final DismissDirection dismissDirection;
  const ExerciseDetailsCard(
      {Key? key,
      required this.workoutExercise,
      required this.exercise,
      required this.confirmDismissPressed,
      required this.dismissDirection})
      : super(key: key);

  @override
  State<ExerciseDetailsCard> createState() => _ExerciseDetailsCardState();
}

class _ExerciseDetailsCardState extends State<ExerciseDetailsCard> {
  List<TextEditingController> controllers = [TextEditingController()];
  late int size = controllers.length;
  List<int> reps = [];

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.exercise.name),
      direction: widget.dismissDirection,
      onDismissed: (DismissDirection direction) {
        print('Dismissed with direction $direction');
      },
      confirmDismiss: (DismissDirection direction) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete \"${widget.exercise.name}\"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    'No',
                    style: TextStyle(color: kOrangeLightColor),
                  ),
                ),
                TextButton(
                  onPressed: widget.confirmDismissPressed,
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: kBlueLightColor),
                  ),
                )
              ],
            );
          },
        );
        print('Deletion confirmed: $confirmed');
        return confirmed;
      },
      background: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.delete_forever_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                widget.exercise.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w900),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Set',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Previous',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'lbs',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Reps',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    width: 24,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.workoutExercise.sets,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Color(0xFFb3a5dc),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                (index + 1).toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                            ),
                            Text(
                              '---',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black26),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(
                              width: 50,
                              height: 25,
                              child: TextField(
                                controller: TextEditingController(),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kBlueLightColor, width: 2),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kOrangeLightColor),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 25,
                              child: TextField(
                                controller: controllers[index],
                                onChanged: (value) {
                                  var repValue = int.tryParse(value);
                                  repValue ??= 0;
                                  if (reps.asMap().containsKey(index)) {
                                    reps[index] = repValue;
                                    print(
                                        'Adding to reps list for ExerciseID: ${widget.workoutExercise.exercise_id} w/ reps ${reps[index]}');
                                    widget.workoutExercise.reps = reps;
                                  } else {
                                    reps.add(repValue);
                                  }
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kBlueLightColor, width: 2),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kOrangeLightColor),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                              ),
                            ),
                            if (index + 1 == widget.workoutExercise.sets &&
                                index != 0) ...[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.workoutExercise.sets =
                                        widget.workoutExercise.sets! - 1;
                                    controllers.removeAt(index);
                                  });
                                },
                                child: Icon(Icons.delete),
                              ),
                            ] else ...[
                              Container(
                                width: 24,
                                height: 24,
                              ),
                            ],
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  }),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Color(0xFFb3a5dc),
                  minimumSize: const Size.fromHeight(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                onPressed: () {
                  widget.workoutExercise.sets =
                      (widget.workoutExercise.sets! + 1);
                  int index = workoutExercises.indexWhere(
                      (element) => element.exercise_id == widget.exercise.id);
                  workoutExercises[index] = widget.workoutExercise;
                  setState(() {
                    final controller = TextEditingController();
                    controllers.add(controller);
                  });
                  for (int i = 0; i < controllers.length; i++) {
                    print('Controller $i : ${controllers[i].text}');
                  }
                },
                child: Text('+ Add Set'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}