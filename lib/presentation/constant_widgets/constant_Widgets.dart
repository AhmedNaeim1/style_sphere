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

Widget buildSettingsRow(String text, IconData icon, BuildContext context,
    String routeName, dynamic arguments) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    },
    child: Row(
      children: [
        Icon(
          icon,
          color: blackColor,
          size: 22.sp,
          weight: 0.1,
        ),
        SizedBox(
          width: 4.w,
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

Widget buildEditProfileRow(String labelText, String routeName,
    BuildContext context, dynamic arguments) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildCustomText(
          text: labelText,
          color: Colors.black,
          fontSize: 11,
          align: TextAlign.left,
          fontWeight: FontWeight.normal,
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size: 15,
        )
      ],
    ),
  );
}

Widget buildLanguageTile({
  required String languageName,
  required String languageValue,
  required String selectedLanguage,
  required void Function(String) onChanged,
}) {
  bool isSelected = selectedLanguage == languageValue;

  return ListTile(
    onTap: () {
      onChanged(languageValue);
    },
    title: buildCustomText(
      text: languageName,
      color: blackColor,
      fontSize: 12,
      align: TextAlign.left,
      fontWeight: FontWeight.normal,
    ),
    trailing: Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(
                color: Colors.transparent,
              )
            : Border.all(
                color: Colors.black,
                width: 1.5,
              ),
        color: isSelected ? const Color(0xff4AC76D) : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 18.0,
              color: Colors.white,
            )
          : null,
    ),
  );
}
