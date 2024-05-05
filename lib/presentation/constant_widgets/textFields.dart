import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/presentation/constant_Widgets/constant_Widgets.dart';

Widget buildTextFieldSection(String title, TextEditingController controller,
    String hintText, bool enabled, bool error, Function(String) onChanged,
    {bool hidden = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title),
      buildSizedBox(0.5.h),
      enabled == true
          ? buildTextField(controller, hintText, error, onChanged,
              hidden: hidden)
          : buildDisabledTextField(controller, hintText, error, onChanged),
      buildSizedBox(1.h),
    ],
  );
}

Widget buildTextField(TextEditingController controller, String hintText,
    bool error, Function(String) onChanged,
    {bool hidden = false}) {
  return SizedBox(
    height: 6.h,
    child: TextField(
      onChanged: onChanged,
      obscureText: hidden,
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: error ? redColor : grey20Color, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: greyColor, width: 2),
        ),
      ),
    ),
  );
}

Widget buildDisabledTextField(TextEditingController controller, String hintText,
    bool error, Function(String) onChanged) {
  // controller.addListener(() {
  //   // Call the onChanged function when the hint text changes
  //   // onChanged(controller.text);
  // });
  return SizedBox(
    height: 6.h,
    child: TextField(
      enabled: false,
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: error == true ? redColor : grey20Color),
        ),
      ),
    ),
  );
}

Widget buildNameFieldEditProfile(
    String labelText,
    String hintText,
    TextEditingController controller,
    bool isEditing,
    void Function(bool) onPressed) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Gabarito',
          fontSize: 12.sp,
        ),
      ),
      SizedBox(
        height: 5.h,
        child: GestureDetector(
          onTap: () {
            onPressed(!isEditing);
          },
          child: TextField(
            controller: controller,
            enabled: isEditing,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: grey20Color,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: greyColor,
                  width: 2,
                ),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  onPressed(!isEditing);
                },
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
