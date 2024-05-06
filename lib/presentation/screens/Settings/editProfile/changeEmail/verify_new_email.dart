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

// ignore: must_be_immutable
class NewEmailVerification extends StatefulWidget {
  UserData user;

  NewEmailVerification({
    super.key,
    required this.user,
  });

  @override
  State<NewEmailVerification> createState() => _NewEmailVerificationState();
}

class _NewEmailVerificationState extends State<NewEmailVerification> {
  final TextEditingController _otpController = TextEditingController();
  String errorMessage = '';
  bool errorDateOfBirth = false;
  bool buttonColor = false;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<userCubit>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar("Verify New Enail", context, 14.sp),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/newEmailVerify.png"),
                        fit: BoxFit.values[6],
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildSizedBox(5.h),
                            buildCustomText(
                                text:
                                    "Code has been send to ${widget.user.email}",
                                fontSize: 10,
                                color: greyBlueColor),
                            buildCustomText(
                                text: "Enter the code to verify your account.",
                                fontSize: 10,
                                color: greyBlueColor),
                            buildSizedBox(5.h),
                            Container(
                              margin: EdgeInsets.only(top: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18.0, 0, 18, 18),
                                child: Column(
                                  children: [
                                    buildSizedBox(2.h),
                                    buildTextFieldSection(
                                      "Enter Code",
                                      _otpController,
                                      "4 digit code",
                                      true,
                                      errorDateOfBirth,
                                      (value) {
                                        if (value.length == 4) {
                                          setState(() {
                                            buttonColor = true;
                                          });
                                        } else {
                                          setState(() {
                                            buttonColor = false;
                                          });
                                        }
                                      },
                                    ),
                                    buildErrorText(
                                      text: errorMessage,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            CustomElevatedButton(
                              text: 'Continue',
                              onPressed: () {
                                if (_otpController.text.isEmpty) {
                                  setState(
                                    () {
                                      errorMessage =
                                          "Enter a valid OTP to continue";
                                      errorDateOfBirth = true;
                                    },
                                  );
                                } else {
                                  cubit.verifyEmail(
                                      widget.user.email!,
                                      _otpController.text,
                                      context,
                                      "NewEmail",
                                      widget.user.userID!);
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
