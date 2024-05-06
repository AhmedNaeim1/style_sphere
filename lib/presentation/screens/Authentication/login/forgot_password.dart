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

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    bool errorEmail = false;
    String errorMessage = '';

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
                            text: "Forgot Password",
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                            color: darkBlueColor,
                          ),
                          buildSizedBox(1.h),
                          buildCustomText(
                            align: TextAlign.center,
                            text:
                                "No worries! Enter your email address below and we will send you a code to reset password.",
                            fontSize: 10,
                            color: greyBlueColor,
                          ),
                          buildSizedBox(2.h),
                          buildTextFieldSection("Email", emailController,
                              "Enter your email", true, errorEmail, (value) {}),
                          buildErrorText(
                            text: errorMessage,
                          ),
                          const Spacer(),
                          CustomElevatedButton(
                            text: "Send Reset Code",
                            onPressed: () {
                              if (emailController.text.isNotEmpty &&
                                  RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(emailController.text)) {
                                setState(() {
                                  errorMessage = "";
                                });

                                final cubit =
                                    BlocProvider.of<userCubit>(context);
                                UserData user = UserData(
                                  email: emailController.text,
                                );
                                cubit.sendOTP(user, context, "Forgot Password");
                              } else {
                                setState(() {
                                  errorMessage = "Invalid Email";
                                });
                              }
                            },
                            color: true,
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
