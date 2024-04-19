import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/constants.dart';

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

PreferredSizeWidget buildAppBar(String title, BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    title: Text(
      title,
      style: TextStyle(
        color: blackColor,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool color;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: color
              ? MaterialStateProperty.all<Color>(primaryColor)
              : MaterialStateProperty.all<Color>(grey20Color),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

Widget buildSizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

Widget buildCustomText({
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
    ),
  );
}

Widget buildLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(),
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
