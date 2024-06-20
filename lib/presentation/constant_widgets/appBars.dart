import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/presentation/router.dart';

PreferredSizeWidget buildAppBar(
    String title, BuildContext context, double fontSize) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: darkBlueColor,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'Gabarito',
        color: darkBlueColor,
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

PreferredSizeWidget buildLeadingAppBar(
    String title, BuildContext context, double fontSize, UserData user) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: darkBlueColor,
      ),
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.settings,
            arguments: jsonEncode(user));
      },
    ),
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'Gabarito',
        color: darkBlueColor,
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

PreferredSizeWidget buildActionsAppBar(
  String title,
  String routeName,
  dynamic arguments,
  BuildContext context,
) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: darkBlueColor,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: [
      // add skip button
      TextButton(
        onPressed: () {
          Navigator.pushNamed(context, routeName, arguments: arguments);
        },
        child: Text(
          'Skip',
          style: TextStyle(
            fontFamily: 'Gabarito',
            color: grey20Color,
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
          ),
        ),
      ),
    ],
    title: Center(
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Gabarito',
          color: darkBlueColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
