import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/presentation/constant_Widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
          appBar: buildAppBar("Settings", context),
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
                          child: Container(
                            padding:
                                EdgeInsets.fromLTRB(0.2.w, 5.w, 0.2.w, 3.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildCustomText(
                                    text: "Account",
                                    color: blackColor,
                                    fontSize: 16,
                                    align: TextAlign.left,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  buildSizedBox(2.h),
                                  buildEditProfileRow("Edit Profile",
                                      Icons.person_outline, context),
                                  buildSizedBox(2.h),
                                  buildEditProfileRow(
                                      "Language", Icons.language, context),
                                  buildSizedBox(2.h),
                                  buildEditProfileRow("Notifications",
                                      Icons.notifications_outlined, context),
                                  buildSizedBox(2.h),
                                  buildEditProfileRow("Currency",
                                      Icons.currency_bitcoin, context),
                                  buildSizedBox(2.h),
                                  buildEditProfileRow(
                                      "Region", Icons.language, context),
                                  buildSizedBox(4.h),
                                  buildCustomText(
                                    text: "Saved Items",
                                    color: blackColor,
                                    fontSize: 16,
                                    align: TextAlign.left,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  buildSizedBox(2.h),
                                  buildEditProfileRow("Saved Cards",
                                      Icons.favorite_border, context),
                                  buildSizedBox(2.h),
                                  buildEditProfileRow("Saved Address",
                                      Icons.remove_red_eye, context),
                                ],
                              ),
                            ),
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
