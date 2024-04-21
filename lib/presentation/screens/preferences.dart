import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_Data.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/buttons.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/preferencesBox.dart';
import 'package:style_sphere/presentation/functions/constant_functions.dart';
import 'package:style_sphere/presentation/router.dart';

import '../constant_widgets/texts.dart';

class PreferencesPage extends StatefulWidget {
  final Map<String, List<bool>> preferences;
  final bool profile;
  final String preferencesPage;

  const PreferencesPage(
      {super.key,
      required this.preferences,
      required this.profile,
      required this.preferencesPage});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  List<bool> stylePreferenceStates = [];
  List<bool> materialPreferenceStates = [];
  List<bool> occasionPreferenceStates = [];

  @override
  void initState() {
    setState(() {
      if (widget.preferences["Style"].toString() == [].toString()) {
        stylePreferenceStates = List.generate(6, (index) => false);
      } else {
        stylePreferenceStates = widget.preferences["Style"]!;
      }
      if (widget.preferences["Material"].toString() == [].toString()) {
        materialPreferenceStates = List.generate(6, (index) => false);
      } else {
        materialPreferenceStates = widget.preferences["Material"]!;
      }
      if (widget.preferences["Occasion"].toString() == [].toString()) {
        occasionPreferenceStates = List.generate(6, (index) => false);
      } else {
        occasionPreferenceStates = widget.preferences["Occasion"]!;
      }
    });

    super.initState();
  }

  void updatePreferenceState(int index, bool isClicked) {
    setState(
      () {
        widget.preferencesPage == "Style"
            ? stylePreferenceStates[index] = isClicked
            : widget.preferencesPage == "Material"
                ? materialPreferenceStates[index] = isClicked
                : occasionPreferenceStates[index] = isClicked;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<userCubit>(context);

    return BlocProvider<userCubit>(
      create: (context) => userCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.preferencesPage == "Style"
            ? buildActionsAppBar(
                "Preferences",
                AppRoutes.preferences,
                {
                  'preferences': {"Style": [], "Material": [], "Occasion": []},
                  'profile': widget.profile,
                  'preferencesPage': "Material",
                },
                context)
            : widget.preferencesPage == "Material"
                ? buildActionsAppBar(
                    "Preferences",
                    AppRoutes.preferences,
                    {
                      'preferences': {
                        "Style": stylePreferenceStates,
                        "Material": [],
                        "Occasion": []
                      },
                      'profile': widget.profile,
                      'preferencesPage': "Occasion",
                    },
                    context)
                : buildActionsAppBar(
                    "Preferences", AppRoutes.home, {}, context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: buildCustomText(
                    text: widget.preferencesPage == "Style"
                        ? "1/3"
                        : widget.preferencesPage == "Material"
                            ? "2/3"
                            : "3/3",
                    color: grey20Color,
                    fontSize: 10,
                    align: TextAlign.center,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                buildSizedBox(1.h),
                buildCustomText(
                  text:
                      "What’s your preferred ${widget.preferencesPage.toLowerCase()}?",
                  fontSize: widget.preferencesPage == "Style"
                      ? 21
                      : widget.preferencesPage == "Material"
                          ? 19
                          : 18,
                  fontWeight: FontWeight.w500,
                  color: darkBlueColor,
                ),
                buildSizedBox(1.h),
                buildCustomText(
                  text: "So we can personalize your StyleSphere experience!",
                  fontSize: 10,
                  color: greyBlueColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 10, 5, 0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: widget.preferencesPage == "Style"
                          ? stylePreferenceStates.length
                          : widget.preferencesPage == "Material"
                              ? materialPreferenceStates.length
                              : occasionPreferenceStates.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 25,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return CustomPreferenceBox(
                          text: widget.preferencesPage,
                          index: index,
                          isClicked: widget.preferencesPage == "Style"
                              ? stylePreferenceStates[index]
                              : widget.preferencesPage == "Material"
                                  ? materialPreferenceStates[index]
                                  : occasionPreferenceStates[index],
                          onChanged: (clicked) {
                            updatePreferenceState(index, clicked);
                          },
                          image:
                              "assets/preferences/${widget.preferencesPage.toLowerCase()}/$index.jpg",
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomElevatedButton(
            text: 'Continue',
            onPressed: () async {
              if (widget.preferencesPage == "Style" &&
                  stylePreferenceStates.contains(true)) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.preferences,
                  arguments: {
                    'preferences': {
                      "Style": stylePreferenceStates,
                      "Material": [],
                      "Occasion": []
                    },
                    'profile': widget.profile,
                    'preferencesPage': "Material",
                  },
                );
              } else if (widget.preferencesPage == "Material" &&
                  materialPreferenceStates.contains(true)) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.preferences,
                  arguments: {
                    'preferences': {
                      "Style": stylePreferenceStates,
                      "Material": materialPreferenceStates,
                      "Occasion": []
                    },
                    'profile': widget.profile,
                    'preferencesPage': "Occasion",
                  },
                );
              } else if (widget.preferencesPage == "Occasion" &&
                  occasionPreferenceStates.contains(true)) {
                UserData? userData = await getUserPreferencesInfo();
                userData!.preferredMaterials = materialPreferenceStates;
                userData.preferredStyles = stylePreferenceStates;
                userData.preferredOccasions = occasionPreferenceStates;
                cubit.updateUserPreferences(userData.userID!, userData);
                Navigator.pushNamed(
                  context,
                  AppRoutes.home,
                );
              }
            },
            color: true,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
