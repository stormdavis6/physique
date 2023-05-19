import 'package:flutter/material.dart';
import 'package:physique/database/pump_pal_database.dart';
import 'package:physique/models/workout.dart';
import '../constants.dart';
import '../models/exercise.dart';

class WorkoutCreatePopup extends StatefulWidget {
  const WorkoutCreatePopup({Key? key}) : super(key: key);

  @override
  State<WorkoutCreatePopup> createState() => _WorkoutCreatePopupState();
}

class _WorkoutCreatePopupState extends State<WorkoutCreatePopup> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late FocusNode nameFocusNode;
  late FocusNode descriptionFocusNode;

  @override
  void initState() {
    nameController = TextEditingController();
    nameController.addListener(() => setState(() {}));

    descriptionController = TextEditingController();
    descriptionController.addListener(() => setState(() {}));

    nameFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(13)),
        ),
        title: Text('Create Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              autofocus: true,
              focusNode: nameFocusNode,
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'workout name',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(
                  Icons.info_outline,
                  color: nameFocusNode.hasFocus
                      ? kOrangeLightColor
                      : kBlueLightColor,
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
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kBlueLightColor, width: 2),
                  borderRadius: BorderRadius.circular(13),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kOrangeLightColor),
                  borderRadius: BorderRadius.circular(13),
                ),
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: nameFocusNode.hasFocus
                      ? kOrangeLightColor
                      : kBlueLightColor,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: Scrollbar(
                child: TextField(
                  autocorrect: true,
                  focusNode: descriptionFocusNode,
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'workout description',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: descriptionFocusNode.hasFocus
                          ? kOrangeLightColor
                          : kBlueLightColor,
                    ),
                    suffixIcon: descriptionController.text.isEmpty
                        ? Container(
                            width: 0,
                            height: 0,
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey[700],
                            ),
                            onPressed: () => descriptionController.clear(),
                          ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kBlueLightColor, width: 2),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kOrangeLightColor),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: descriptionFocusNode.hasFocus
                          ? kOrangeLightColor
                          : kBlueLightColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Workout newWorkout = Workout(
                  name: nameController.text,
                  description: descriptionController.text);
              if (newWorkout.name.isNotEmpty) {
                await PumpPalDatabase.instance.createWorkout(newWorkout);
              }
              Navigator.pop(context, true);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: kBlueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}