import 'package:flutter/material.dart';
import 'package:physique/widgets/bottom_nav_bar.dart';
import 'package:physique/widgets/day_card.dart';
import 'constants.dart';

//https://github.com/abuanwar072/Meditation-App

// Home Screen: The home screen should provide users with an option to create a new workout plan or access their existing workout plans. It can also display recent activity, such as completed workouts, upcoming workouts, and progress summaries.
//
// Workout Creation Screen: This screen should enable users to create new workouts by adding exercises, specifying sets and reps, and entering weights. The interface should be intuitive and easy to navigate, allowing users to quickly select exercises and input data.
//
// Calendar Screen: The calendar screen should allow users to view their workout plans by day, week, or month. It should display upcoming workouts and allow users to click on a specific day to view the corresponding workout plan.
//
// Progress Tracking Screen: This screen should display progress summaries for each workout plan, including the total number of sets, reps, and weight lifted. Users can track their progress over time and set goals for themselves.
//
// Settings Screen: This screen should provide users with options to customize the app's settings, such as notifications, preferences, and data synchronization.
//
// Overall, the layout should be user-friendly and visually appealing, making it easy for users to create workout plans and track their progress. By keeping the layout simple and intuitive, users will be more likely to use the app regularly and achieve their fitness goals.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PumpPal',
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        fontFamily: "Cairo",
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: Theme.of(context).textTheme.apply(displayColor: kTextColor),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: BoxDecoration(
              color: kOrangeLightColor,
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'PumpPal',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      Image.asset('assets/icons/Pirate.png'),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //TODO: some sort of progress indicator?
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        DayCard(
                          day: 'Today',
                          color: Color(0xffBCB3F2),
                          title: 'Chest/Shoulders/Tris',
                          imgSrc: 'assets/icons/Pirate.png',
                          press: () {},
                        ),
                        DayCard(
                          day: 'Wednesday',
                          color: Colors.white,
                          title: 'Cardio',
                          imgSrc: 'assets/icons/Pirate.png',
                          press: () {},
                        ),
                        DayCard(
                          day: 'Thursday',
                          color: Colors.white,
                          title: 'Back & Biceps',
                          imgSrc: 'assets/icons/Pirate.png',
                          press: () {},
                        ),
                        DayCard(
                          day: 'Friday',
                          color: Colors.white,
                          title: 'Chest/Shoulders/Tris',
                          imgSrc: 'assets/icons/Pirate.png',
                          press: () {},
                        ),
                        DayCard(
                          day: 'Saturday',
                          color: Colors.white,
                          title: 'Chest/Shoulders/Tris',
                          imgSrc: 'assets/icons/Pirate.png',
                          press: () {},
                        ),
                        DayCard(
                          day: 'Sunday',
                          color: Colors.white,
                          title: 'Chest/Shoulders/Tris',
                          imgSrc: 'assets/icons/Pirate.png',
                          press: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}