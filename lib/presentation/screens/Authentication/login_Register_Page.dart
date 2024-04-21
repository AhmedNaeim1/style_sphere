import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/presentation/constant_widgets/buttons.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/router.dart';

class LoginRegisterPage extends StatelessWidget {
  const LoginRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildSizedBox(10.h),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/authentication/loginRegisterPage.png"),
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 6.h,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.firstStep);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(color: Colors.black)),
                                elevation: MaterialStateProperty.all(0),
                              ),
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          buildSizedBox(2.h),
                          CustomElevatedButton(
                            text: 'Login',
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.login,
                              );
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
