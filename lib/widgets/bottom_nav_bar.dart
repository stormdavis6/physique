import 'package:flutter/material.dart';
import 'package:physique/constants.dart';
import 'package:physique/main.dart';
import 'package:physique/screens/exercises_screen.dart';
import 'package:physique/screens/workout_screen.dart';
import 'package:physique/widgets/bottom_nav_item.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      height: 80,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BottomNavItem(
            isActive: widget.selectedIndex == 0 ? true : false,
            svgSrc: 'assets/icons/home.svg',
            press: () {
              if (widget.selectedIndex != 0) {
                // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                //   builder: (context) {
                //     return MyApp();
                //   },
                // ), (Route route) => false);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MyApp();
                  }),
                );
              }
            },
            title: 'Home',
          ),
          BottomNavItem(
            title: 'Workouts',
            isActive: widget.selectedIndex == 1 ? true : false,
            svgSrc: 'assets/icons/gym.svg',
            press: () {
              if (widget.selectedIndex != 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return WorkoutScreen();
                  }),
                );
              }
            },
          ),
          BottomNavItem(
            title: 'Exercises',
            isActive: widget.selectedIndex == 2 ? true : false,
            svgSrc: 'assets/icons/gym.svg',
            press: () {
              if (widget.selectedIndex != 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ExercisesScreen();
                  }),
                );
              }
            },
          ),
          BottomNavItem(
            isActive: widget.selectedIndex == 3 ? true : false,
            svgSrc: 'assets/icons/calendar.svg',
            press: () {},
            title: 'Calendar',
          ),
        ],
      ),
    );
  }
}