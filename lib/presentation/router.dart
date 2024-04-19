// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:style_sphere/main.dart';
import 'package:style_sphere/presentation/screens/Authentication/login.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/first_Step.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/second_Step.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/third_Step.dart';
import 'package:style_sphere/presentation/screens/login_Register_Page.dart';

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

  static const String EmailVerification = '/EmailVerification';

  static Map<String, WidgetBuilder> define() {
    return {
      home: (context) => const MyHomePage(),
      firstStep: (context) => FirstStep(),
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
        return MaterialPageRoute(builder: (_) => FirstStep());
      case AppRoutes.secondStep:
        final name = settings.arguments as String;

        return MaterialPageRoute(builder: (_) => SecondStep(name: name));
      case AppRoutes.loginRegisterPage:
        return MaterialPageRoute(builder: (_) => const LoginRegisterPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      // case AppRoutes.signup:
      //   return MaterialPageRoute(builder: (_) => SignUpScreen());
      // case AppRoutes.profile:
      //  return MaterialPageRoute(builder: (_) => const ProfileScreen());
      //
      //   case AppRoutes.EmailVerification:
      //     return MaterialPageRoute(builder: (_) => const EmailVerificationPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
              body:
                  Center(child: Text('No route defined for ${settings.name}'))),
        );
    }
  }
}
