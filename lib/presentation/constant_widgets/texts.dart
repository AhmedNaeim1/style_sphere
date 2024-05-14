import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/constants.dart';

Widget buildCustomTextGabarito({
  required String text,
  TextAlign align = TextAlign.start,
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
}) {
  return Text(
    text,
    textAlign: align,
    style: TextStyle(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
      fontFamily: "Gabarito",
    ),
  );
}

Widget buildCustomTextInter({
  required String text,
  TextAlign align = TextAlign.start,
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
}) {
  return Text(
    text,
    textAlign: align,
    style: TextStyle(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
      fontFamily: "Inter",
    ),
  );
}

Widget buildErrorText({
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 10.sp,
      color: redColor,
      fontFamily: "Gabarito",
    ),
  );
}
