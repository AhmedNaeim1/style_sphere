import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/data/models/user_Data.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';

class LanguageCurrencyPage extends StatefulWidget {
  String page;

  UserData user;

  LanguageCurrencyPage({super.key, required this.page, required this.user});

  @override
  State<LanguageCurrencyPage> createState() => _LanguageCurrencyPageState();
}

class _LanguageCurrencyPageState extends State<LanguageCurrencyPage> {
  late String selectedLanguage = widget.user.languagePreference ?? "English";
  late String selectedCurrency = widget.user.currencyPreference ?? "EGP";

  @override
  void initState() {
    super.initState();
    widget.page == "Language"
        ? selectedLanguage = widget.user.languagePreference!
        : selectedCurrency = widget.user.currencyPreference!;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<userCubit>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
          widget.page == "Language" ? "Language" : "Currency", context, 14.sp),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/settings/editProfile.png"),
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildSizedBox(4.h),
              Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildLanguageCurrencyTile(
                      languageName: widget.page == "Language"
                          ? "English (US)"
                          : "Egyptian Pound (EGP)",
                      languageValue:
                          widget.page == "Language" ? "English" : "EGP",
                      selectedLanguage: widget.page == "Language"
                          ? selectedLanguage
                          : selectedCurrency,
                      onChanged: (String value) async {
                        UserData user = widget.user;
                        setState(() {
                          if (widget.page == "Language") {
                            selectedLanguage = value;
                            user.languagePreference = value;
                          } else {
                            selectedCurrency = value;
                            user.currencyPreference = value;
                          }
                        });
                        cubit.updateUser(
                          widget.user.userID!,
                          user,
                        );
                      },
                    ),
                    buildLanguageCurrencyTile(
                      languageName: widget.page == "Language"
                          ? "Arabic (AR)"
                          : "Dollars (\$)",
                      languageValue:
                          widget.page == "Language" ? "Arabic" : "USD",
                      selectedLanguage: widget.page == "Language"
                          ? selectedLanguage
                          : selectedCurrency,
                      onChanged: (String value) async {
                        UserData user = widget.user;
                        setState(() {
                          if (widget.page == "Language") {
                            selectedLanguage = value;
                            user.languagePreference = value;
                          } else {
                            selectedCurrency = value;
                            user.currencyPreference = value;
                          }
                        });
                        cubit.updateUser(
                          widget.user.userID!,
                          user,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
