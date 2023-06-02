import 'package:flutter/material.dart';
import 'package:physique/models/exercise.dart';

import '../constants.dart';
import '../database/pump_pal_database.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback press;
  final VoidCallback confirmDismissPressed;
  final DismissDirection dismissDirection;
  const ExerciseCard(
      {Key? key,
      required this.exercise,
      required this.press,
      required this.confirmDismissPressed,
      required this.dismissDirection})
      : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    var constraint = MediaQuery.of(context).size;
    return Dismissible(
      key: UniqueKey(),
      direction: widget.dismissDirection,
      onDismissed: (DismissDirection direction) {
        print('Dismissed with direction $direction');
      },
      confirmDismiss: (DismissDirection direction) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              title: Text('Remove Exercise?'),
              content: Text(
                'This removes \"${widget.exercise.name}\" and all of the associated data (weight, reps, sets) from all previous workouts. You cannot undo this action.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: widget.confirmDismissPressed,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.white),
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
                  widget.exercise.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  widget.exercise.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                selectedTileColor: Colors.red,
                // leading: Container(
                //   height: 42,
                //   width: 43,
                //   decoration: BoxDecoration(
                //     color: kBlueLightColor,
                //     shape: BoxShape.circle,
                //     border: Border.all(color: kBlueLightColor),
                //   ),
                //   child: Text('💪🏻'),
                //   alignment: Alignment.center,
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}