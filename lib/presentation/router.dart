import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/main.dart';
import 'package:style_sphere/presentation/constant_widgets/botton_navigation_bar.dart';
import 'package:style_sphere/presentation/screens/Authentication/login.dart';
import 'package:style_sphere/presentation/screens/Authentication/login_Register_Page.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/email_verification.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/first_Step.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/second_Step.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/third_Step.dart';
import 'package:style_sphere/presentation/screens/Settings/confirmation_page.dart';
import 'package:style_sphere/presentation/screens/Settings/editProfile/changeEmail/new_email.dart';
import 'package:style_sphere/presentation/screens/Settings/editProfile/changeEmail/verify_new_email.dart';
import 'package:style_sphere/presentation/screens/Settings/editProfile/edit_profile.dart';
import 'package:style_sphere/presentation/screens/Settings/language_currency.dart';
import 'package:style_sphere/presentation/screens/Settings/region.dart';
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
  static const String region = '/region';
  static const String newEmail = '/newEmail';

  static const String emailVerification = '/emailVerification';
  static const String newEmailVerification = '/newEmailVerification';

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
      case AppRoutes.emailVerification:
        final args = settings.arguments as Map<String, dynamic>;
        final userData = UserData.fromJson(json.decode(args["user"]));

        return MaterialPageRoute(
          builder: (_) => EmailVerification(
            user: userData,
          ),
        );
      case AppRoutes.newEmailVerification:
        final args = settings.arguments as Map<String, dynamic>;
        final userData = UserData.fromJson(json.decode(args["user"]));

        return MaterialPageRoute(
          builder: (_) => NewEmailVerification(
            user: userData,
          ),
        );
      case AppRoutes.region:
        final args = settings.arguments as Map<String, dynamic>;
        final userData = UserData.fromJson(json.decode(args["user"]));

        return MaterialPageRoute(
          builder: (_) => RegionPage(
            region: args["region"],
            user: userData,
          ),
        );
      case AppRoutes.newEmail:
        final args = settings.arguments as Map<String, dynamic>;
        final userData = UserData.fromJson(json.decode(args["user"]));

        return MaterialPageRoute(
          builder: (_) => NewEmail(
            user: userData,
          ),
        );
      case AppRoutes.languages:
        final args = settings.arguments as Map<String, dynamic>;
        final userData = UserData.fromJson(json.decode(args["user"]));
        return MaterialPageRoute(
          builder: (_) => LanguageCurrencyPage(
            page: args["page"],
            user: userData,
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
