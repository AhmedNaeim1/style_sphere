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

Widget buildEditProfileRow(String text, IconData icon, BuildContext context) {
  return GestureDetector(
    onTap: () {},
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: blackColor,
          size: 22.sp,
          weight: 0.1,
        ),
        buildCustomText(
          text: text,
          color: grey80Color,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        const Spacer(),
        Icon(
          Icons.arrow_forward_ios,
          color: blackColor,
          size: 15.sp,
        ),
      ],
    ),
  );
}
