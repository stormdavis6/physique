import 'package:flutter/material.dart';

import '../constants.dart';
import '../database/pump_pal_database.dart';
import '../models/workout.dart';

class WorkoutCard extends StatefulWidget {
  final Workout workout;
  final VoidCallback press;
  final VoidCallback confirmDismissPressed;

  const WorkoutCard(
      {Key? key,
      required this.workout,
      required this.press,
      required this.confirmDismissPressed})
      : super(key: key);

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction) {
        print('Dismissed with direction $direction');
      },
      confirmDismiss: (DismissDirection direction) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete \"${widget.workout.name}\"?'),
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
      child: GestureDetector(
        onTap: widget.press,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          elevation: 4,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  widget.workout.name,
                ),
                subtitle: Text(
                  widget.workout.description ?? '',
                ),
                leading: Container(
                  height: 42,
                  width: 43,
                  decoration: BoxDecoration(
                    color: Color(0xFFb3a5dc),
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFFb3a5dc)),
                  ),
                  child: Text('💪🏻'),
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}