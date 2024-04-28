// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:style_sphere/data/models/user_Data.dart';
import 'package:style_sphere/main.dart';
import 'package:style_sphere/presentation/constant_widgets/botton_navigation_bar.dart';
import 'package:style_sphere/presentation/screens/Authentication/login.dart';
import 'package:style_sphere/presentation/screens/Authentication/login_Register_Page.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/first_Step.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/second_Step.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/third_Step.dart';
import 'package:style_sphere/presentation/screens/Settings/confirmation_page.dart';
import 'package:style_sphere/presentation/screens/Settings/edit_profile.dart';
import 'package:style_sphere/presentation/screens/Settings/language_currency.dart';
import 'package:style_sphere/presentation/screens/Settings/settings.dart';
import 'package:style_sphere/presentation/screens/preferences.dart';
import 'package:style_sphere/presentation/screens/profile.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String thirdStep = '/thirdStep/:args';
  static const String signup = '/signup';
  static const String profile = '/profile';
  static const String loginRegisterPage = '/loginRegisterPage';
  static const String firstStep = '/firstStep';
  static const String secondStep = '/secondStep/:name';
  static const String login = '/login';
  static const String preferences = '/preferences';
  static const String navbar = '/navbar';
  static const String settings = '/settings';
  static const String editProfile = '/editProfile';
  static const String confirmationPage = '/confirmationPage';
  static const String languages = '/languages';

  static const String EmailVerification = '/EmailVerification';

  static Map<String, WidgetBuilder> define() {
    return {
      home: (context) => const MyHomePage(),
      firstStep: (context) => const FirstStep(),
      loginRegisterPage: (context) => const LoginRegisterPage(),
      login: (context) => const LoginPage(),
      profile: (context) => const ProfilePage(),
      navbar: (context) => const BottomNavbar(),
      settings: (context) => const SettingsPage(),

      // signup: (context) => SignUpScreen(),
      // profile: (context) => const ProfileScreen(),
      // EmailVerification: (context) => const EmailVerificationPage(),
    };
  }

  static MaterialPageRoute? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case AppRoutes.thirdStep:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
            builder: (_) => ThirdStep(
                name: args["name"].toString(),
                dateOfBirth: args["dob"].toString()));
      case AppRoutes.firstStep:
        return MaterialPageRoute(builder: (_) => const FirstStep());
      case AppRoutes.secondStep:
        final name = settings.arguments as String;

        return MaterialPageRoute(builder: (_) => SecondStep(name: name));
      case AppRoutes.loginRegisterPage:
        return MaterialPageRoute(builder: (_) => const LoginRegisterPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case AppRoutes.editProfile:
        final args = settings.arguments as String;

        final userPreference = UserData.fromJson(json.decode(args));

        return MaterialPageRoute(
            builder: (_) => EditProfilePage(user: userPreference));
      case AppRoutes.confirmationPage:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ConfirmationPage(
            pageComingFrom: args,
          ),
        );

      case AppRoutes.languages:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => LanguageCurrencyPage(
            language: args["language"],
            page: args["page"],
            currency: args["currency"],
          ),
        );

      case AppRoutes.preferences:
        final args = settings.arguments as Map<String, dynamic>;

        final Map<String, List<dynamic>> preferencesMap = args["preferences"];

        final Map<String, List<bool>> preferences = preferencesMap
            .map((key, value) => MapEntry(key, value.cast<bool>()));

        return MaterialPageRoute(
          builder: (_) => PreferencesPage(
            preferences: preferences,
            preferencesPage: args["preferencesPage"],
            profile: args["profile"],
          ),
        );
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case AppRoutes.navbar:
        return MaterialPageRoute(builder: (_) => const BottomNavbar());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
              body:
                  Center(child: Text('No route defined for ${settings.name}'))),
        );
    }
  }
}
