import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';

class LanguageCurrencyPage extends StatefulWidget {
  String language;
  String page;
  String currency;

  LanguageCurrencyPage(
      {super.key,
      required this.language,
      required this.page,
      required this.currency});

  @override
  State<LanguageCurrencyPage> createState() => _LanguageCurrencyPageState();
}

class _LanguageCurrencyPageState extends State<LanguageCurrencyPage> {
  late String selectedLanguage = widget.language;
  late String selectedCurrency = widget.currency;

  @override
  void initState() {
    super.initState();
    widget.page == "Language"
        ? selectedLanguage = widget.language
        : selectedCurrency = widget.currency;
  }

  @override
  Widget build(BuildContext context) {
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
                    buildLanguageTile(
                      languageName: widget.page == "Language"
                          ? "English (US)"
                          : "Egyptian Pound (EGP)",
                      languageValue:
                          widget.page == "Language" ? "English" : "EGP",
                      selectedLanguage: widget.page == "Language"
                          ? selectedLanguage
                          : selectedCurrency,
                      onChanged: (String value) {
                        setState(() {
                          widget.page == "Language"
                              ? selectedLanguage = value
                              : selectedCurrency = value;
                        });
                      },
                    ),
                    buildLanguageTile(
                      languageName: widget.page == "Language"
                          ? "Arabic (AR)"
                          : "Dollars (\$)",
                      languageValue:
                          widget.page == "Language" ? "Arabic" : "USD",
                      selectedLanguage: widget.page == "Language"
                          ? selectedLanguage
                          : selectedCurrency,
                      onChanged: (String value) {
                        setState(() {
                          widget.page == "Language"
                              ? selectedLanguage = value
                              : selectedCurrency = value;
                        });
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
