import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/buttons.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/textFields.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/router.dart';

// ignore: must_be_immutable
class FirstStep extends StatefulWidget {
  const FirstStep({super.key});

  @override
  State<FirstStep> createState() => _FirstStepState();
}

class _FirstStepState extends State<FirstStep> {
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  bool errorFirstName = false;

  bool errorLastName = false;

  bool buttonColor = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar("Register", context, 20.sp),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/authentication/emailRegister1.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: buildCustomText(
                                text: "1/3",
                                color: darkBlueColor,
                                fontSize: 10,
                                align: TextAlign.center,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            buildSizedBox(3.h),
                            buildCustomText(
                              text: "What's your name?",
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                              color: darkBlueColor,
                            ),
                            buildSizedBox(1.h),
                            buildCustomText(
                              text:
                                  "So we can personalize your StyleSphere experience!",
                              fontSize: 10,
                              color: greyBlueColor,
                            ),
                            buildSizedBox(2.h),
                            Row(
                              children: [
                                Expanded(
                                  child: buildTextFieldSection(
                                      "First Name",
                                      _firstNameController,
                                      "First Name",
                                      true,
                                      errorFirstName, (value) {
                                    if (_firstNameController.text.isNotEmpty &&
                                        _lastNameController.text.isNotEmpty) {
                                      setState(() {
                                        buttonColor = true;
                                      });
                                    } else {
                                      setState(() {
                                        errorFirstName = true;
                                        buttonColor = false;
                                      });
                                    }
                                  }),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Expanded(
                                  child: buildTextFieldSection(
                                      "Last Name",
                                      _lastNameController,
                                      "Last Name",
                                      true,
                                      errorLastName, (value) {
                                    if (_firstNameController.text.isNotEmpty &&
                                        _lastNameController.text.isNotEmpty) {
                                      setState(() {
                                        buttonColor = true;
                                      });
                                    } else {
                                      setState(() {
                                        errorLastName = true;
                                        buttonColor = false;
                                      });
                                    }
                                  }),
                                ),
                              ],
                            ),
                            const Spacer(),
                            CustomElevatedButton(
                              text: 'Continue',
                              onPressed: () {
                                if (_firstNameController.text.isNotEmpty &&
                                    _lastNameController.text.isNotEmpty) {
                                  Navigator.pushNamed(
                                      context, AppRoutes.secondStep,
                                      arguments:
                                          "${_firstNameController.text} ${_lastNameController.text}");
                                } else {
                                  if (_firstNameController.text.isEmpty) {
                                    setState(() {
                                      errorFirstName = true;
                                    });
                                  }
                                  if (_lastNameController.text.isEmpty) {
                                    setState(() {
                                      errorLastName = true;
                                    });
                                  }
                                }
                              },
                              color: buttonColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
