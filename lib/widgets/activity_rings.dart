import 'package:flutter/material.dart';
import 'package:activity_ring/activity_ring.dart';

class ActivityRing extends StatelessWidget {
  const ActivityRing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Ring(
        percent: 90,
        color: RingColorScheme(ringColor: Colors.purple[200]),
        radius: 50,
        width: 10,
        child: Center(
          child: Text('90%'),
        ),
      ),
    );
  }
}