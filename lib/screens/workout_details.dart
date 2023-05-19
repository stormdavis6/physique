import 'package:flutter/material.dart';
import 'package:physique/models/workout.dart';
import 'package:physique/widgets/exercise_card.dart';

import '../constants.dart';
import '../models/exercise.dart';

class WorkoutDetails extends StatefulWidget {
  final Workout workout;
  const WorkoutDetails({Key? key, required this.workout}) : super(key: key);

  @override
  State<WorkoutDetails> createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kOrangeLightColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: const BoxDecoration(
              color: kOrangeLightColor,
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Text(
                      widget.workout.name,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: <Widget>[
                        // ExerciseCard(
                        //   exercise: widget.workout.exercises![0],
                        //   press: () {},
                        // ),
                        // ExerciseCard(
                        //   exercise: widget.workout.exercises![1],
                        //   press: () {},
                        // ),
                        // ExerciseCard(
                        //   exercise: widget.workout.exercises![2],
                        //   press: () {},
                        // ),
                        // ExerciseCard(
                        //   exercise: widget.workout.exercises![3],
                        //   press: () {},
                        // ),
                        // ExerciseCard(
                        //   exercise: widget.workout.exercises![4],
                        //   press: () {},
                        // ),
                        // ExerciseCard(
                        //   exercise: widget.workout.exercises![5],
                        //   press: () {},
                        // ),
                        // ExerciseCard(
                        //   exercise: widget.workout.exercises![6],
                        //   press: () {},
                        // ),
                        // ExerciseCard(
                        //   exercise: widget.workout.exercises![7],
                        //   press: () {},
                        // ),
                      ],
                    )
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