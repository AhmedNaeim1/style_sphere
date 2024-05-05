import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/data/repositories/user_repository.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/buttons.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/textFields.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';

// ignore: must_be_immutable
class ThirdStep extends StatefulWidget {
  String name;
  String dateOfBirth;

  ThirdStep({
    super.key,
    required this.name,
    required this.dateOfBirth,
  });

  @override
  State<ThirdStep> createState() => _ThirdStepState();
}

class _ThirdStepState extends State<ThirdStep> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool errorEmail = false;

  bool errorPassword = false;

  bool errorConfirmPassword = false;
  bool contains8Char = false;
  bool lowerCaseChar = false;
  bool upperCaseChar = false;
  bool numbers = false;
  bool symbols = false;

  bool buttonColor = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<userCubit>(context);

    return BlocProvider<userCubit>(
      create: (context) => userCubit(
        repository: UserRepository(),
      ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                              "assets/authentication/emailRegister.png"),
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
                              Center(
                                child: buildCustomText(
                                  text: "3/3",
                                  fontSize: 10,
                                  color: grey20Color,
                                  align: TextAlign.center,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              buildCustomText(
                                text: "What's your Email?",
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                                color: darkBlueColor,
                              ),
                              buildSizedBox(1.h),
                              buildCustomText(
                                text:
                                    "We will send a verification code to make sure it’s you.",
                                fontSize: 10,
                                color: greyBlueColor,
                              ),
                              buildSizedBox(2.h),
                              buildTextFieldSection(
                                  "Email",
                                  _emailController,
                                  "Enter your email",
                                  true,
                                  errorEmail, (value) {
                                if (_emailController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty &&
                                    _confirmPasswordController
                                        .text.isNotEmpty) {
                                  setState(() {
                                    buttonColor = true;
                                  });
                                } else {
                                  setState(() {
                                    buttonColor = false;
                                  });
                                }
                              }),
                              buildSizedBox(1.h),
                              buildTextFieldSection(
                                  "Password",
                                  _passwordController,
                                  "Enter your password",
                                  true,
                                  errorPassword, (value) {
                                if (_emailController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty &&
                                    _confirmPasswordController
                                        .text.isNotEmpty) {
                                  setState(() {
                                    buttonColor = true;
                                  });
                                }
                                if (_passwordController.text.length < 8) {
                                  setState(() {
                                    contains8Char = false;
                                  });
                                } else {
                                  setState(() {
                                    contains8Char = true;
                                  });
                                }
                                if (!RegExp(r'[a-z]')
                                    .hasMatch(_passwordController.text)) {
                                  setState(() {
                                    lowerCaseChar = false;
                                  });
                                } else {
                                  setState(() {
                                    lowerCaseChar = true;
                                  });
                                }
                                if (!RegExp(r'[A-Z]')
                                    .hasMatch(_passwordController.text)) {
                                  setState(() {
                                    upperCaseChar = false;
                                  });
                                } else {
                                  setState(() {
                                    upperCaseChar = true;
                                  });
                                }
                                if (!RegExp(r'[0-9]')
                                    .hasMatch(_passwordController.text)) {
                                  setState(() {
                                    numbers = false;
                                  });
                                } else {
                                  setState(() {
                                    numbers = true;
                                  });
                                }
                                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                    .hasMatch(_passwordController.text)) {
                                  setState(() {
                                    symbols = false;
                                  });
                                } else {
                                  setState(() {
                                    symbols = true;
                                  });
                                }
                                if (_passwordController.text.length >= 8 &&
                                    RegExp(r'[a-z]')
                                        .hasMatch(_passwordController.text) &&
                                    RegExp(r'[A-Z]')
                                        .hasMatch(_passwordController.text) &&
                                    RegExp(r'[0-9]')
                                        .hasMatch(_passwordController.text) &&
                                    RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                        .hasMatch(_passwordController.text)) {
                                  setState(() {
                                    contains8Char = true;
                                    lowerCaseChar = true;
                                    upperCaseChar = true;
                                    numbers = true;
                                    symbols = true;
                                    buttonColor = false;
                                  });
                                }
                              }, hidden: true),
                              buildPasswordInfoRow(
                                "Contains at least 8 characters",
                                contains8Char,
                                _passwordController,
                              ),
                              buildPasswordInfoRow(
                                "Contains at least 1 lowercase letter",
                                lowerCaseChar,
                                _passwordController,
                              ),
                              buildPasswordInfoRow(
                                "Contains at least 1 uppercase letter",
                                upperCaseChar,
                                _passwordController,
                              ),
                              buildPasswordInfoRow(
                                "Contains at least 1 number",
                                numbers,
                                _passwordController,
                              ),
                              buildPasswordInfoRow(
                                "Contains at least 1 symbol",
                                symbols,
                                _passwordController,
                              ),
                              buildSizedBox(2.h),
                              buildTextFieldSection(
                                  "Confirm Password",
                                  _confirmPasswordController,
                                  "Re-enter your password",
                                  true,
                                  errorConfirmPassword, (value) {
                                if ((_emailController.text.isNotEmpty &&
                                        _passwordController.text.isNotEmpty &&
                                        _confirmPasswordController
                                            .text.isNotEmpty) &&
                                    (_passwordController.text ==
                                        _confirmPasswordController.text)) {
                                  setState(() {
                                    buttonColor = true;
                                    errorMessage = "";
                                  });
                                } else if (_passwordController.text !=
                                    _confirmPasswordController.text) {
                                  setState(() {
                                    errorMessage = "Passwords do not match";
                                  });
                                } else {
                                  setState(() {
                                    buttonColor = false;
                                  });
                                }
                              }, hidden: true),
                              buildErrorText(
                                text: errorMessage,
                              ),
                              const Spacer(),
                              CustomElevatedButton(
                                text: 'Create Account',
                                onPressed: () {
                                  if (_emailController.text.isEmpty ||
                                      !RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(_emailController.text)) {
                                    setState(() {
                                      errorEmail = true;
                                      errorMessage = "Invalid Email";
                                    });
                                  } else if (_passwordController.text.isEmpty) {
                                    setState(() {
                                      errorPassword = true;
                                    });
                                  } else if (_confirmPasswordController
                                      .text.isEmpty) {
                                    setState(() {
                                      errorConfirmPassword = true;
                                    });
                                  } else {
                                    setState(() {
                                      errorMessage = "";
                                    });

                                    UserData user = UserData(
                                      userName: widget.name.split(" ")[0] +
                                          widget.name.split(" ")[1],
                                      name: widget.name,
                                      dateOfBirth:
                                          widget.dateOfBirth.toString(),
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      location: "Egypt",
                                      profilePictureUrl: "",
                                      registrationDate:
                                          DateTime.now().toString(),
                                      followingCount: 0,
                                      followersCount: 0,
                                      businessID: 0,
                                      languagePreference: "English",
                                      currencyPreference: "EGP",
                                      regionPreference: "Egypt",
                                      preferredStyles: [],
                                      preferredMaterials: [],
                                      preferredOccasions: [],
                                      isVerified: false,
                                    );
                                    cubit.registerWithEmailPassword(
                                        user, context);
                                  }
                                },
                                color: buttonColor,
                              ),
                              buildSizedBox(1.h),
                              Center(
                                child: buildCustomText(
                                  text:
                                      "By continuing, you agree to our Terms of Service and Privacy Policy.",
                                  fontSize: 10,
                                  align: TextAlign.center,
                                ),
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
      ),
    );
  }
}
