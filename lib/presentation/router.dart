// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:style_sphere/main.dart';
import 'package:style_sphere/presentation/screens/Authentication/login.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/first_Step.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/second_Step.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/third_Step.dart';
import 'package:style_sphere/presentation/screens/login_Register_Page.dart';
import 'package:style_sphere/presentation/screens/preferences.dart';

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

  static const String EmailVerification = '/EmailVerification';

  static Map<String, WidgetBuilder> define() {
    return {
      home: (context) => const MyHomePage(),
      firstStep: (context) => const FirstStep(),
      loginRegisterPage: (context) => const LoginRegisterPage(),
      login: (context) => const LoginPage(),

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
      // var preferences = args["preferences"] as List;
      //
      // preferences = preferences.map((e) => e as bool).toList();

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

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
              body:
                  Center(child: Text('No route defined for ${settings.name}'))),
        );
    }
  }
}
