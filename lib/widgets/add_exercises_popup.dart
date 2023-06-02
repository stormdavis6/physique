import 'package:flutter/material.dart';
import 'package:physique/models/workout_exercise.dart';

import '../constants.dart';
import '../database/pump_pal_database.dart';
import '../models/exercise.dart';
import 'exercise_card.dart';
import 'exercise_create_popup.dart';

class BoxedReturns {
  final List<Exercise> selectedExercises;
  final List<WorkoutExercise> selectedWorkoutExercises;

  BoxedReturns(this.selectedExercises, this.selectedWorkoutExercises);
}

class AddExercisesPopup extends StatefulWidget {
  final List<Exercise> currentExercises;
  final List<WorkoutExercise> currentWorkoutExercises;
  const AddExercisesPopup(
      {Key? key,
      required this.currentExercises,
      required this.currentWorkoutExercises})
      : super(key: key);

  @override
  State<AddExercisesPopup> createState() => _AddExercisesPopupState();
}

class _AddExercisesPopupState extends State<AddExercisesPopup> {
  List<Exercise> exercises = [];
  List<Exercise> duplicateExercises = [];
  List<Exercise> selectedExercises = [];
  List<WorkoutExercise> selectedWorkoutExercises = [];

  bool isLoading = false;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    refreshExercises();
    searchController = TextEditingController();
  }

  // @override
  // dispose() {
  //   PumpPalDatabase.instance.close();
  //
  //   super.dispose();
  // }

  Future refreshExercises() async {
    setState(() {
      isLoading = true;
    });
    // Exercise exercise = await PumpPalDatabase.instance.createExercise(
    //   Exercise(
    //     name: 'test Exercise 1',
    //   ),
    // );
    exercises = await PumpPalDatabase.instance.readAllExercises();
    duplicateExercises = exercises;
    SearchExercises(searchController.text);
    print('${exercises[0].name} , ${exercises[0].id}');

    if (widget.currentExercises.isNotEmpty) {
      for (int i = 0; i < widget.currentExercises.length; i++) {
        widget.currentExercises[i].isSelected = true;
        int indexExercise = exercises.indexWhere(
            (element) => element.id == widget.currentExercises[i].id);
        exercises[indexExercise].isSelected = true;
      }
      selectedExercises = widget.currentExercises;
      selectedWorkoutExercises = widget.currentWorkoutExercises;
    }

    setState(() {
      isLoading = false;
    });
  }

  void refreshExercise(int index, int id) async {
    setState(() {
      isLoading = true;
    });
    if (id != -1) {
      exercises[index] = await PumpPalDatabase.instance.readExercise(id);
    }
    setState(() {
      isLoading = false;
    });
  }

  //function to search through list of exercises
  void SearchExercises(String query) {
    setState(() {
      exercises = duplicateExercises
          .where((exercise) =>
              exercise.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return AlertDialog(
      backgroundColor: kOrangeLightColor,
      content: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              backgroundColor: kOrangeLightColor,
              body: Stack(
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF2BEA1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context, -1);
                                },
                              ),
                              Text(
                                'Exercises',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                              GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF2BEA1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  for (int i = 0;
                                      i < selectedExercises.length;
                                      i++) {
                                    print(
                                        'Returning Exercise: ${exercises[i].name} w/ ExerciseID: ${exercises[i].id}');
                                  }
                                  Navigator.pop(
                                    context,
                                    BoxedReturns(selectedExercises,
                                        selectedWorkoutExercises),
                                  );
                                },
                              ),
                            ],
                          ),
                          //This container is the search bar
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 30),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(29.5),
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Search",
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.grey[700],
                                ),
                                border: InputBorder.none,
                                suffixIcon: searchController.text.isEmpty
                                    ? Container(
                                        width: 0,
                                        height: 0,
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.grey[700],
                                        ),
                                        onPressed: () {
                                          searchController.clear();
                                          SearchExercises('');
                                        }),
                              ),
                              onChanged: (query) {
                                SearchExercises(query);
                              },
                            ),
                          ),
                          exercises.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: exercises.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final exercise = exercises[index];
                                      return ExerciseItem(exercise);
                                    },
                                  ),
                                )
                              : SizedBox(
                                  width: size.width * .5,
                                  height: 50,
                                  child: Text(
                                      'You do not have any exercises, try adding one!'), // it just take the 50% width
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget ExerciseItem(Exercise exercise) {
    return Card(
      color: exercise.isSelected ? kBlueLightColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            title: Text(
              exercise.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              exercise.description ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // selectedTileColor: kBlueLightColor,
            // selected: exercise.isSelected,
            onTap: () {
              setState(() {
                if (exercise.isSelected) {
                  selectedExercises.removeAt(selectedExercises
                      .indexWhere((element) => element.id == exercise.id));
                  selectedWorkoutExercises.removeAt(
                      selectedWorkoutExercises.indexWhere(
                          (element) => element.exercise_id == exercise.id));
                  exercise.isSelected = false;
                  print(
                      'SelectedExercises Length: ${selectedExercises.length}');
                  print(
                      'SelectedWorkoutExercises Length: ${selectedWorkoutExercises.length}');
                } else {
                  selectedExercises.add(exercise);
                  exercise.isSelected = true;
                  WorkoutExercise workoutExercise = WorkoutExercise(
                      exercise_id: exercise.id!, sets: 1, reps: [10]);
                  selectedWorkoutExercises.add(workoutExercise);
                  print(
                      'Adding ${workoutExercise.exercise_id} to selectedWorkoutExercises');
                }
              });
            },
          ),
        ],
      ),
    );
  }
}