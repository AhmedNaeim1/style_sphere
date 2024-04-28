import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/blocs/user_state.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/repositories/user_Repository.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<userCubit>(
      create: (context) =>
          userCubit(repository: UserRepository())..getUserData(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar("Settings", context, 12.sp),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/authentication/loginPage.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 10, 18, 18),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0.2.w, 5.w, 0.2.w, 3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: BlocBuilder<userCubit, userStates>(
                      builder: (context, state) {
                        if (state is GetUserDataLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is GetUserDataSuccessState) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
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
                                buildSettingsRow(
                                  "Edit Profile",
                                  Icons.person_outline,
                                  context,
                                  AppRoutes.editProfile,
                                  state.user,
                                ),
                                buildSizedBox(2.h),
                                buildSettingsRow(
                                  "Language",
                                  Icons.language,
                                  context,
                                  AppRoutes.editProfile,
                                  state.user,
                                ),
                                buildSizedBox(2.h),
                                // buildEditProfileRow("Notifications",
                                //     Icons.notifications_outlined, context),
                                // buildSizedBox(2.h),
                                buildSettingsRow(
                                  "Currency",
                                  Icons.currency_bitcoin,
                                  context,
                                  AppRoutes.editProfile,
                                  state.user,
                                ),
                                buildSizedBox(2.h),
                                buildSettingsRow(
                                  "Region",
                                  Icons.language,
                                  context,
                                  AppRoutes.editProfile,
                                  state.user,
                                ),
                                buildSizedBox(4.h),
                                buildCustomText(
                                  text: "Saved Items",
                                  color: blackColor,
                                  fontSize: 16,
                                  align: TextAlign.left,
                                  fontWeight: FontWeight.normal,
                                ),
                                buildSizedBox(2.h),
                                buildSettingsRow(
                                  "Saved Cards",
                                  Icons.favorite_border,
                                  context,
                                  AppRoutes.editProfile,
                                  state.user,
                                ),
                                buildSizedBox(2.h),
                                buildSettingsRow(
                                  "Saved Address",
                                  Icons.remove_red_eye,
                                  context,
                                  AppRoutes.editProfile,
                                  state.user,
                                ),
                              ],
                            ),
                          );
                        } else if (state is GetUserDataErrorState) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildCustomText(
                                  text: "Error",
                                  color: blackColor,
                                  fontSize: 16,
                                  align: TextAlign.left,
                                  fontWeight: FontWeight.normal,
                                ),
                                buildSizedBox(2.h),
                                buildCustomText(
                                  text: "An error occurred",
                                  color: blackColor,
                                  fontSize: 16,
                                  align: TextAlign.left,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
