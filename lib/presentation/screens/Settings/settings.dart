import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/blocs/user_state.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/data/repositories/user_repository.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/router.dart';

class SettingsPage extends StatefulWidget {
  final UserData user;

  SettingsPage({super.key, required this.user});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<userCubit>(context);

    return BlocProvider<userCubit>(
      create: (context) =>
          userCubit(repository: UserRepository())..getUserPreferencesData(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: darkBlueColor,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.navbar,
                    arguments: {
                      "selectedIndex": 3,
                      "user": widget.user,
                    });
                cubit.getUserPreferencesData();
              },
            ),
            title: Text(
              "Settings",
              style: TextStyle(
                fontFamily: 'Gabarito',
                color: darkBlueColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
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
                                buildCustomTextGabarito(
                                  text: "Account",
                                  color: blackColor,
                                  fontSize: 16,
                                  align: TextAlign.left,
                                  fontWeight: FontWeight.normal,
                                ),
                                buildSizedBox(2.h),
                                buildSettingsRow(
                                  "Edit Profile",
                                  "assets/iconPerson.png",
                                  context,
                                  AppRoutes.editProfile,
                                  json.encode(state.user),
                                ),
                                buildSizedBox(2.h),
                                buildSettingsRow(
                                    "Language",
                                    "assets/iconLanguages.png",
                                    context,
                                    AppRoutes.languages, {
                                  "language": state.user.languagePreference ??
                                      "English",
                                  "currency":
                                      state.user.currencyPreference ?? "EGP",
                                  "page": "Language",
                                  "user": json.encode(state.user),
                                }),
                                buildSizedBox(2.h),
                                buildSettingsRow(
                                    "Currency",
                                    "assets/iconCurrency.png",
                                    context,
                                    AppRoutes.languages, {
                                  "page": "Currency",
                                  "user": json.encode(state.user),
                                }),
                                buildSizedBox(2.h),
                                buildSettingsRow(
                                  "Region",
                                  "assets/iconRegion.png",
                                  context,
                                  AppRoutes.region,
                                  {
                                    "region":
                                        state.user.regionPreference ?? "Egypt",
                                    "user": json.encode(state.user),
                                  },
                                ),
                                buildSizedBox(4.h),
                                buildCustomTextGabarito(
                                  text: "Saved Items",
                                  color: blackColor,
                                  fontSize: 16,
                                  align: TextAlign.left,
                                  fontWeight: FontWeight.normal,
                                ),
                                buildSizedBox(2.h),
                                buildSettingsRow(
                                  "Saved Cards",
                                  "assets/iconSavedCards.png",
                                  context,
                                  AppRoutes.savedCards,
                                  state.user,
                                ),
                                buildSizedBox(2.h),
                                buildSettingsRow(
                                  "Saved Addresses",
                                  "assets/iconSavedAddress.png",
                                  context,
                                  AppRoutes.savedAddress,
                                  jsonEncode(state.user),
                                ),
                              ],
                            ),
                          );
                        } else if (state is GetUserDataErrorState) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildCustomTextGabarito(
                                  text: "Error",
                                  color: blackColor,
                                  fontSize: 16,
                                  align: TextAlign.left,
                                  fontWeight: FontWeight.normal,
                                ),
                                buildSizedBox(2.h),
                                buildCustomTextGabarito(
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
