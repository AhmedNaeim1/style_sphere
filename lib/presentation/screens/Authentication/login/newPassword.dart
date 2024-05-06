import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/buttons.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/textFields.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';

class NewPassword extends StatefulWidget {
  UserData user;

  NewPassword({
    super.key,
    required this.user,
  });

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<userCubit>(context);

    final TextEditingController newConfirmPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    String errorMessage = '';
    bool errorDateOfBirth = false;
    bool buttonColor = false;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar("", context, 20.sp),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildSizedBox(3.h),
                          buildCustomText(
                            text: "Create New Password",
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                            color: darkBlueColor,
                          ),
                          buildSizedBox(1.h),
                          buildCustomText(
                            text: "Please enter and confirm your new password.",
                            fontSize: 10,
                            color: greyBlueColor,
                          ),
                          buildSizedBox(1.h),
                          buildCustomText(
                            text: "You will need to login after you reset.",
                            fontSize: 10,
                            color: greyBlueColor,
                          ),
                          buildSizedBox(2.h),
                          buildTextFieldSection(
                            "New Password",
                            newPasswordController,
                            "********",
                            true,
                            errorDateOfBirth,
                            (value) {
                              // if (newPasswordController.text.length >= 8 &&
                              //     RegExp(r'[a-z]')
                              //         .hasMatch(newPasswordController.text) &&
                              //     RegExp(r'[A-Z]')
                              //         .hasMatch(newPasswordController.text) &&
                              //     RegExp(r'[0-9]')
                              //         .hasMatch(newPasswordController.text) &&
                              //     RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                              //         .hasMatch(newPasswordController.text)) {
                              //   setState(() {
                              //     errorMessage = "";
                              //   });
                              // } else {
                              //   setState(() {
                              //     errorMessage = "Invalid Password";
                              //     buttonColor = false;
                              //   });
                              // }
                            },
                            hidden: true,
                          ),
                          buildSizedBox(2.h),
                          buildTextFieldSection(
                            "Confirm New Password",
                            newConfirmPasswordController,
                            "********",
                            true,
                            errorDateOfBirth,
                            (value) {
                              // if (newConfirmPasswordController.text ==
                              //     newPasswordController.text) {
                              //   setState(() {
                              //     buttonColor = true;
                              //     errorMessage = "";
                              //   });
                              // } else {
                              //   setState(() {
                              //     errorMessage = "Not Matched";
                              //     buttonColor = false;
                              //   });
                              // }
                            },
                            hidden: true,
                          ),
                          buildErrorText(
                            text: errorMessage,
                          ),
                          const Spacer(),
                          CustomElevatedButton(
                            text: 'Reset Password',
                            onPressed: () {
                              if (newPasswordController.text.isEmpty ||
                                  newConfirmPasswordController.text.isEmpty) {
                                setState(
                                  () {
                                    errorMessage =
                                        "Fill all fields to continue";
                                    errorDateOfBirth = true;
                                  },
                                );
                              } else {
                                print(widget.user.userID);
                                cubit.changePassword(
                                    widget.user.userID!,
                                    "",
                                    newPasswordController.text,
                                    context,
                                    "Forgot Password");
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
            );
          },
        ),
      ),
    );
  }
}
