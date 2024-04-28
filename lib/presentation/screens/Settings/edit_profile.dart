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
import 'package:style_sphere/presentation/constant_widgets/textFields.dart';
import 'package:style_sphere/presentation/router.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isEditingFirst = false;
  bool isEditingSecond = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

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
          appBar: buildAppBar("Edit Profile", context, 14.sp),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/settings/editProfile.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
              ),
            ),
            child:
                BlocBuilder<userCubit, userStates>(builder: (context, state) {
              if (state is GetUserDataLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetUserDataSuccessState) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(children: [
                        Container(
                          margin: EdgeInsets.only(top: 21.5.h),
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
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 18),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: buildNameFieldEditProfile(
                                        "First Name",
                                        state.user.name
                                            .toString()
                                            .split(" ")[0],
                                        firstNameController,
                                        isEditingFirst,
                                        (newValue) {
                                          setState(() {
                                            isEditingFirst = newValue;
                                            isEditingSecond = false;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Expanded(
                                      child: buildNameFieldEditProfile(
                                        "Last Name",
                                        state.user.name
                                            .toString()
                                            .split(" ")[1],
                                        lastNameController,
                                        isEditingSecond,
                                        (newValue) {
                                          setState(() {
                                            isEditingSecond = newValue;
                                            isEditingFirst = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                buildSizedBox(2.h),
                                buildEditProfileRow(
                                  "Change Email",
                                  AppRoutes.editProfile,
                                  context,
                                  {},
                                ),
                                buildSizedBox(1.h),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 0.2,
                                ),
                                buildSizedBox(1.h),
                                buildEditProfileRow(
                                  "Change Password",
                                  AppRoutes.editProfile,
                                  context,
                                  {},
                                ),
                                buildSizedBox(1.h),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 0.2,
                                ),
                                buildSizedBox(1.h),
                                buildEditProfileRow(
                                  "Update Preferences",
                                  AppRoutes.preferences,
                                  context,
                                  {
                                    'preferences': {
                                      "Style": state.user.preferredStyles!
                                          .map((value) =>
                                              value.toLowerCase() == 'true')
                                          .toList(),
                                      "Material": state.user.preferredMaterials!
                                          .map((value) =>
                                              value.toLowerCase() == 'true')
                                          .toList(),
                                      "Occasion": state.user.preferredOccasions!
                                          .map((value) =>
                                              value.toLowerCase() == 'true')
                                          .toList(),
                                    },
                                    'profile': true,
                                    'preferencesPage': 'Style',
                                  },
                                ),
                                buildSizedBox(1.h),
                              ],
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              child: CircleAvatar(
                                radius: 14.h,
                                backgroundImage: NetworkImage(
                                  state.user.profilePictureUrl.toString() ==
                                          "null"
                                      ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                                      : state.user.profilePictureUrl.toString(),
                                ),
                                child: CircleAvatar(
                                  radius: 12.h,
                                  backgroundColor: Colors.transparent,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      backgroundColor: primaryColor,
                                      radius: 22.0,
                                      child: Icon(
                                        Icons.edit,
                                        size: 3.h,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ]),
                    ],
                  ),
                );
              } else if (state is GetUserDataErrorState) {
                return const Center(child: Text('Error loading Profile'));
              } else {
                return Container();
              }
            }),
          ),
        ),
      ),
    );
  }
}
