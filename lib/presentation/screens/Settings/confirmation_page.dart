import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/presentation/constant_Widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/buttons.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/router.dart';

class ConfirmationPage extends StatelessWidget {
  String pageComingFrom;

  ConfirmationPage({Key? key, required this.pageComingFrom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.center,
                        image: AssetImage('assets/settings/confirmation.png'),
                      ),
                      buildSizedBox(2.h),
                      buildCustomText(
                        align: TextAlign.center,
                        text: pageComingFrom == "Preferences"
                            ? 'Your Preferences Have Been Updated Successfully!'
                            : pageComingFrom == "Password"
                                ? 'Your Password Has Been Updated Successfully!'
                                : 'Your Email Has Been Updated Successfully!',
                        fontSize: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.settings);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(whiteColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Back To Profile",
                      style: TextStyle(
                        color: Color(0xff8F959E),
                      ),
                    ),
                  ),
                ),
              ),
              buildSizedBox(2.h),
              CustomElevatedButton(
                text: 'Continue Shopping',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.home);
                },
                color: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
