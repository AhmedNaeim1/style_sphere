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
class NewEmail extends StatefulWidget {
  UserData user;

  NewEmail({
    super.key,
    required this.user,
  });

  @override
  State<NewEmail> createState() => _NewEmailState();
}

class _NewEmailState extends State<NewEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
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
        appBar: buildAppBar("Change Email", context, 14.sp),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/changeEmail.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.center,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildSizedBox(5.h),
                            Center(
                              child: buildCustomText(
                                  text:
                                      "We will send a verification code to make sure it’s you",
                                  fontSize: 10,
                                  color: greyBlueColor),
                            ),
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
                                      "Current E-mail",
                                      _emailController,
                                      widget.user.email!,
                                      false,
                                      errorDateOfBirth,
                                      (value) {},
                                    ),
                                    buildSizedBox(2.h),
                                    buildTextFieldSection(
                                      "New E-mail",
                                      _newEmailController,
                                      "Enter your new email",
                                      true,
                                      errorDateOfBirth,
                                      (value) {
                                        if (_newEmailController
                                                .text.isNotEmpty &&
                                            RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                .hasMatch(
                                                    _newEmailController.text)) {
                                          setState(() {
                                            buttonColor = true;
                                            errorMessage = "";
                                          });
                                        } else {
                                          setState(() {
                                            errorMessage = "Invalid Email";
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
                              text: 'Verify New Email',
                              onPressed: () {
                                if (_newEmailController.text.isEmpty) {
                                  setState(
                                    () {
                                      errorMessage =
                                          "Enter an email to continue";
                                      errorDateOfBirth = true;
                                    },
                                  );
                                } else {
                                  widget.user.email = _newEmailController.text;
                                  cubit.sendOTP(widget.user, context, "");
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
