import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:physique/models/exercise.dart';
import 'package:physique/widgets/exercise_edit_popup.dart';
import '../constants.dart';
import '../database/pump_pal_database.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/exercise_card.dart';
import '../widgets/exercise_create_popup.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({Key? key}) : super(key: key);

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<Exercise> exercises = [];
  List<Exercise> duplicateExercises = [];
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
    print(searchController.text);
    // print(exercises[0].name);
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
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: 2,
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  height: size.height * .45,
                  decoration: BoxDecoration(
                    color: kOrangeLightColor,
                    image: DecorationImage(
                      alignment: Alignment.centerLeft,
                      image:
                          AssetImage("assets/images/undraw_pilates_gpdb.png"),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              'Exercises',
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
                                  color: Color(0xFFF2BEA1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      ExerciseCreatePopup(),
                                ).then(
                                  (value) => refreshExercises(),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Add, Edit, or Delete Exercises",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: size.width *
                              .6, // it just take 60% of total width
                          child: Text(
                            "Click on an exercise to edit, swipe left to delete, or click the plus sign to create.",
                          ),
                        ),
                        //This container is the search bar
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 30),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                    return ExerciseCard(
                                      exercise: exercise,
                                      press: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ExerciseEditPopup(
                                            exercise: exercise,
                                          ),
                                        ).then(
                                          (value) => refreshExercise(
                                              index, exercise.id ?? -1),
                                        );
                                      },
                                      confirmDismissPressed: () async {
                                        await PumpPalDatabase.instance
                                            .deleteExercise(exercise.id!);
                                        Navigator.pop(context, true);
                                        refreshExercises();
                                      },
                                      dismissDirection:
                                          DismissDirection.endToStart,
                                    );
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
          );
  }
}