import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:physique/constants.dart';

class BottomNavItem extends StatelessWidget {
  final String svgSrc;
  final String title;
  final VoidCallback press;
  final bool isActive;

  const BottomNavItem(
      {Key? key,
      required this.svgSrc,
      required this.title,
      required this.press,
      required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            svgSrc,
            color: isActive ? kActiveIconColor : kTextColor,
          ),
          Text(
            title,
            style: TextStyle(color: isActive ? kActiveIconColor : kTextColor),
          ),
        ],
      ),
    );
  }
}