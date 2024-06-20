import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/data/repositories/user_repository.dart';
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
  List<bool> typePreferenceStates = [];
  List<bool> seasonPreferenceStates = [];
  List<String> type = [
    'Tshirts',
    'Shirts',
    'Casual Shoes',
    'Watches',
    'Sports Shoes',
    'Tops',
    'Handbags',
    'Heels',
    'Sunglasses',
    'Wallets',
    'Flip Flops',
    'Sandals',
    'Belts'
  ];

  List<String> season = [
    'Spring',
    'Summer',
    'Fall',
    'Winter',
  ];

  List<String> styles = [
    "Casual",
    "Sports",
    "Formal",
    "Party",
    "Smart Casual",
    "Travel",
  ];

  List<String> mapPreferences(List<bool> states, List<String> preferences) {
    List<String> selectedPreferences = [];
    for (int i = 0; i < states.length; i++) {
      if (states[i]) {
        selectedPreferences.add(preferences[i]);
      }
    }
    return selectedPreferences;
  }

  @override
  void initState() {
    setState(() {
      if (widget.preferences["Style"].toString() == [].toString() &&
          stylePreferenceStates.isEmpty) {
        stylePreferenceStates = List.generate(6, (index) => false);
      } else {
        stylePreferenceStates = widget.preferences["Style"]!;
        print(stylePreferenceStates);
        print(typePreferenceStates);
        print(seasonPreferenceStates);
      }
      if (widget.preferences["Material"].toString() == [].toString() &&
          typePreferenceStates.isEmpty) {
        typePreferenceStates = List.generate(13, (index) => false);
      } else {
        typePreferenceStates = widget.preferences["Material"]!;
        print(typePreferenceStates);
      }
      if (widget.preferences["Occasion"].toString() == [].toString() &&
          seasonPreferenceStates.isEmpty) {
        seasonPreferenceStates = List.generate(4, (index) => false);
      } else {
        seasonPreferenceStates = widget.preferences["Occasion"]!;
        print(seasonPreferenceStates);
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
                ? typePreferenceStates[index] = isClicked
                : seasonPreferenceStates[index] = isClicked;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<userCubit>(context);

    return BlocProvider<userCubit>(
      create: (context) => userCubit(repository: UserRepository()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.preferencesPage == "Style"
            ? buildActionsAppBar(
                "Preferences",
                AppRoutes.preferences,
                {
                  'preferences': {
                    "Style": stylePreferenceStates,
                    "Material": typePreferenceStates,
                    "Occasion": seasonPreferenceStates
                  },
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
                        "Material": typePreferenceStates,
                        "Occasion": seasonPreferenceStates
                      },
                      'profile': widget.profile,
                      'preferencesPage': "Occasion",
                    },
                    context)
                : buildActionsAppBar(
                    "Preferences",
                    widget.profile
                        ? AppRoutes.confirmationPage
                        : AppRoutes.navbar,
                    widget.profile ? "Preferences" : {},
                    context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: buildCustomTextGabarito(
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
                buildCustomTextGabarito(
                  text:
                      "What’s your preferred ${widget.preferencesPage.toLowerCase() == "material" ? "type" : widget.preferencesPage.toLowerCase() == "occasion" ? "season" : widget.preferencesPage.toLowerCase()}?",
                  fontSize: widget.preferencesPage == "Style"
                      ? 21
                      : widget.preferencesPage == "Material"
                          ? 19
                          : 18,
                  fontWeight: FontWeight.w500,
                  color: darkBlueColor,
                ),
                buildSizedBox(1.h),
                buildCustomTextGabarito(
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
                              ? typePreferenceStates.length
                              : seasonPreferenceStates.length,
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
                                  ? typePreferenceStates[index]
                                  : seasonPreferenceStates[index],
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
            text: widget.profile == true && widget.preferencesPage == "Occasion"
                ? 'Done'
                : 'Continue',
            onPressed: () async {
              if (widget.preferencesPage == "Style" &&
                  stylePreferenceStates.contains(true)) {
                print(stylePreferenceStates);
                print(typePreferenceStates);
                print(seasonPreferenceStates);
                Navigator.pushNamed(
                  context,
                  AppRoutes.preferences,
                  arguments: {
                    'preferences': {
                      "Style": mapPreferences(stylePreferenceStates, styles),
                      "Material": mapPreferences(typePreferenceStates, type),
                      "Occasion":
                          mapPreferences(seasonPreferenceStates, season),
                    },
                    'profile': widget.profile,
                    'preferencesPage': "Material",
                  },
                );
              } else if (widget.preferencesPage == "Material" &&
                  typePreferenceStates.contains(true)) {
                print(typePreferenceStates);
                print(mapPreferences(typePreferenceStates, type));
                Navigator.pushNamed(
                  context,
                  AppRoutes.preferences,
                  arguments: {
                    'preferences': {
                      "Style": mapPreferences(stylePreferenceStates, styles),
                      "Material": mapPreferences(typePreferenceStates, type),
                      "Occasion":
                          mapPreferences(seasonPreferenceStates, season),
                    },
                    'profile': widget.profile,
                    'preferencesPage': "Occasion",
                  },
                );
              } else if (widget.preferencesPage == "Occasion" &&
                  seasonPreferenceStates.contains(true)) {
                UserData? userData = await getUserPreferencesInfo();

                userData!.preferredMaterials =
                    mapPreferences(typePreferenceStates, type);
                userData.preferredStyles =
                    mapPreferences(stylePreferenceStates, styles);
                userData.preferredOccasions =
                    mapPreferences(seasonPreferenceStates, season);
                cubit.updateUserPreferences(userData.userID!, userData);
                widget.profile
                    ? Navigator.pushNamed(
                        context,
                        AppRoutes.confirmationPage,
                        arguments: "Preferences",
                      )
                    : Navigator.pushNamed(
                        context,
                        AppRoutes.navbar,
                        arguments: {"user": userData},
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
