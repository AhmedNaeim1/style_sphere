import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/buttons.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/textFields.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool errorEmail = false;

  bool errorPassword = false;

  bool errorConfirmPassword = false;

  bool buttonColor = false;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<userCubit>(context);

    return BlocProvider<userCubit>(
      create: (context) => userCubit(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage("assets/authentication/loginPage.png"),
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
                              buildAppBar("Login", context),
                              buildSizedBox(5.h),
                              buildTextFieldSection(
                                  "Email",
                                  _emailController,
                                  "Enter your email",
                                  true,
                                  errorEmail,
                                  (value) {}),
                              buildSizedBox(1.h),
                              Column(
                                children: [
                                  buildTextFieldSection(
                                      "Password",
                                      _passwordController,
                                      "Enter your password",
                                      true,
                                      errorPassword,
                                      (value) {},
                                      hidden: true),
                                  errorMessage.isNotEmpty
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: redColor,
                                              size: 14.sp,
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            buildErrorText(text: errorMessage),
                                          ],
                                        )
                                      : buildSizedBox(0.h),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: buildCustomText(
                                      text: "Forgot Password?",
                                      color: primaryColor,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              buildSizedBox(4.h),
                              CustomElevatedButton(
                                text: "Login",
                                onPressed: () {
                                  if (_emailController.text.isEmpty &&
                                      _passwordController.text.isEmpty) {
                                    setState(() {
                                      errorEmail = true;
                                      errorPassword = true;
                                      errorMessage =
                                          "Email and Password are required";
                                    });
                                  } else if (_emailController.text.isEmpty) {
                                    setState(() {
                                      errorEmail = true;
                                      errorMessage = "Email is required";
                                    });
                                  } else if (_passwordController.text.isEmpty) {
                                    setState(() {
                                      errorPassword = true;
                                      errorMessage = "Password is required";
                                    });
                                  } else {
                                    setState(() {
                                      errorEmail = false;
                                      errorPassword = false;
                                      errorMessage = "";
                                    });
                                    cubit.loginWithEmailPassword(
                                        _emailController.text,
                                        _passwordController.text,
                                        context);
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
