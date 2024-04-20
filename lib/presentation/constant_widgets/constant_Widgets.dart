import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';

Widget buildSizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

Column buildPasswordInfoRow(
    String text, bool followsRules, TextEditingController controller) {
  Color iconColor = controller.text.isEmpty
      ? greyColor
      : followsRules
          ? greenColor
          : redColor;
  return Column(
    children: [
      Row(
        children: [
          Icon(
            Icons.info_outline,
            color: iconColor,
            size: 14.sp,
          ),
          SizedBox(
            width: 1.w,
          ),
          buildCustomText(
            text: text,
            fontSize: 10,
            color: iconColor,
          ),
        ],
      ),
      buildSizedBox(0.5.h),
    ],
  );
}
