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
class EmailVerification extends StatefulWidget {
  UserData user;
  String page;

  EmailVerification({
    super.key,
    required this.user,
    required this.page,
  });

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
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
                            "assets/authentication/emailRegister2.png"),
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
                              child: buildCustomTextGabarito(
                                text: "3/3",
                                fontSize: 10,
                                color: grey20Color,
                                align: TextAlign.center,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            buildSizedBox(3.h),
                            buildCustomTextGabarito(
                              text: "Verify Account",
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                              color: darkBlueColor,
                            ),
                            buildSizedBox(1.h),
                            buildCustomTextGabarito(
                                text: "Code has been send to ${widget.user}",
                                fontSize: 10,
                                color: greyBlueColor),
                            buildCustomTextGabarito(
                                text: "Enter the code to verify your account.",
                                fontSize: 10,
                                color: greyBlueColor),
                            buildSizedBox(5.h),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildCustomTextGabarito(
                                  text: "Didn't receive code?",
                                  fontSize: 10,
                                  color: greyBlueColor,
                                ),
                                buildCustomTextGabarito(
                                  text: " Resend",
                                  fontSize: 10,
                                  color: darkBlueColor,
                                ),
                              ],
                            ),
                            const Spacer(),
                            CustomElevatedButton(
                              text: 'Verify Account',
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
                                  if (widget.page == "SignUp") {
                                    cubit.verifyEmail(
                                      widget.user.email!,
                                      _otpController.text,
                                      context,
                                      "SignUp",
                                      widget.user.userID!,
                                    );
                                  } else if (widget.page == "Forgot Password") {
                                    cubit.verifyEmail(
                                      widget.user.email!,
                                      _otpController.text,
                                      context,
                                      "Forgot Password",
                                      widget.user.userID ?? "",
                                    );
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
