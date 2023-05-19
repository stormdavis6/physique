import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:physique/constants.dart';
import 'package:physique/database/pump_pal_database.dart';
import 'package:physique/models/exercise.dart';
import 'package:physique/screens/workout_create_screen.dart';
import 'package:physique/screens/workout_details.dart';
import 'package:physique/widgets/workout_card.dart';

import '../models/workout.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/workout_create_popup.dart';
import '../widgets/workout_edit_popup.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  List<Workout> workouts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshWorkouts();
  }

  // @override
  // dispose() {
  //   PumpPalDatabase.instance.close();
  //
  //   super.dispose();
  // }

  Future refreshWorkouts() async {
    setState(() {
      isLoading = true;
    });
    // Workout workout = await PumpPalDatabase.instance.createWorkout(
    //   Workout(
    //     name: 'test1',
    //   ),
    // );
    workouts = await PumpPalDatabase.instance.readAllWorkouts();
    // print(workouts[0].name);
    setState(() {
      isLoading = false;
    });
  }

  void refreshWorkout(int index, int id) async {
    setState(() {
      isLoading = true;
    });
    if (id != -1) {
      workouts[index] = await PumpPalDatabase.instance.readWorkout(id);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //TODO: Build custom loading/spinner widget
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: 1,
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  height: size.height * .45,
                  decoration: BoxDecoration(
                    color: kBlueLightColor,
                    image: DecorationImage(
                      image: AssetImage("assets/images/exercises_bg.png"),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Workouts',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                              GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 52,
                                    width: 52,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFb3a5dc),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return WorkoutCreateScreen();
                                      }),
                                    );
                                    if (result == true) {
                                      refreshWorkouts();
                                    }
                                  }),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Add, Edit, or Delete Workout Plans",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: size.width *
                                .6, // it just take 60% of total width
                            child: Text(
                              "Click on a workout plan to edit, swipe left to delete, or click the plus sign to create.",
                            ),
                          ),
                          SizedBox(
                            width: size.width * .5,
                            height: 20, // it just take the 50% width
                          ),
                          workouts.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: workouts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Workout workout = workouts[index];
                                    return WorkoutCard(
                                      workout: workout,
                                      press: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              WorkoutEditPopup(
                                            workout: workout,
                                          ),
                                        ).then(
                                          (value) => refreshWorkout(
                                              index, workout.id ?? -1),
                                        );
                                      },
                                      confirmDismissPressed: () async {
                                        Navigator.pop(context, true);
                                        await PumpPalDatabase.instance
                                            .deleteWorkout(workout.id!);
                                        await PumpPalDatabase.instance
                                            .deleteWorkoutExercisesByWorkoutId(
                                                workout.id!);
                                        refreshWorkouts();
                                      },
                                    );
                                  },
                                )
                              : SizedBox(
                                  width: size.width * .5,
                                  height: 50,
                                  child: Text(
                                      'You do not have any workouts, try adding one!'), // it just take the 50% width
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}