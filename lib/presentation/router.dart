import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:style_sphere/data/models/products_data.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/presentation/constant_widgets/bottom_navigation_bar.dart';
import 'package:style_sphere/presentation/screens/Authentication/login/forgot_password.dart';
import 'package:style_sphere/presentation/screens/Authentication/login/login.dart';
import 'package:style_sphere/presentation/screens/Authentication/login/newPassword.dart';
import 'package:style_sphere/presentation/screens/Authentication/login_Register_Page.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/email_verification.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/first_Step.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/second_Step.dart';
import 'package:style_sphere/presentation/screens/Authentication/register/third_Step.dart';
import 'package:style_sphere/presentation/screens/Selling/add_product.dart';
import 'package:style_sphere/presentation/screens/Selling/add_product_success.dart';
import 'package:style_sphere/presentation/screens/Settings/addresses/add_address.dart';
import 'package:style_sphere/presentation/screens/Settings/addresses/saved_address.dart';
import 'package:style_sphere/presentation/screens/Settings/cards/add_card.dart';
import 'package:style_sphere/presentation/screens/Settings/cards/saved_cards.dart';
import 'package:style_sphere/presentation/screens/Settings/confirmation_page.dart';
import 'package:style_sphere/presentation/screens/Settings/editProfile/changeEmail/new_email.dart';
import 'package:style_sphere/presentation/screens/Settings/editProfile/changeEmail/verify_new_email.dart';
import 'package:style_sphere/presentation/screens/Settings/editProfile/change_password.dart';
import 'package:style_sphere/presentation/screens/Settings/editProfile/edit_profile.dart';
import 'package:style_sphere/presentation/screens/Settings/language_currency.dart';
import 'package:style_sphere/presentation/screens/Settings/region.dart';
import 'package:style_sphere/presentation/screens/Settings/settings.dart';
import 'package:style_sphere/presentation/screens/VTO/VTO.dart';
import 'package:style_sphere/presentation/screens/home.dart';
import 'package:style_sphere/presentation/screens/preferences.dart';
import 'package:style_sphere/presentation/screens/products_details.dart';
import 'package:style_sphere/presentation/screens/profile.dart';
import 'package:style_sphere/presentation/screens/search_result.dart';
import 'package:style_sphere/presentation/screens/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/home';
  static const String splashScreen = '/splashScreen';
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
  static const String changePassword = '/changePassword';
  static const String newPassword = '/newPassword';
  static const String forgotPassword = '/forgotPassword';
  static const String savedCards = '/savedCards';
  static const String savedAddress = '/savedAddress';
  static const String addCard = '/addCard';
  static const String addAddress = '/addAddress';
  static const String virtualTryOn = '/virtualTryOn';
  static const String productsDetails = '/productsDetails';
  static const String emailVerification = '/emailVerification';
  static const String newEmailVerification = '/newEmailVerification';
  static const String addProductSuccess = '/addProductSuccess';
  static const String addProduct = '/addProduct';
  static const String searchResult = '/searchResult';

  static Map<String, WidgetBuilder> define() {
    return {
      home: (context) => const MyHomePage(),
      firstStep: (context) => const FirstStep(),
      loginRegisterPage: (context) => const LoginRegisterPage(),
      login: (context) => const LoginPage(),
      profile: (context) => const ProfilePage(),
      forgotPassword: (context) => const ForgotPassword(),
      splashScreen: (context) => SplashScreen(),
      addProduct: (context) => SellingPage(),
    };
  }

  static MaterialPageRoute? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case AppRoutes.addProduct:
        return MaterialPageRoute(builder: (_) => SellingPage());
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
      case AppRoutes.addCard:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
            builder: (_) => AddCard(
                  userID: args["userID"].toString(),
                  paymentMethodID: args["paymentMethodID"],
                  // page: args["page"],
                ));
      case AppRoutes.addAddress:
        final args = settings.arguments as Map<String, dynamic>;
        final user = UserData.fromJson(json.decode(args["user"]));
        return MaterialPageRoute(
            builder: (_) => AddAddress(
                  user: user,
                  shipmentMethodID: args["shipmentMethodID"],
                  page: args["page"],
                ));
      case AppRoutes.loginRegisterPage:
        return MaterialPageRoute(builder: (_) => const LoginRegisterPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.settings:
        final args = settings.arguments as String;

        final userPreference = UserData.fromJson(json.decode(args));

        return MaterialPageRoute(
            builder: (_) => SettingsPage(user: userPreference));
      case AppRoutes.addProductSuccess:
        final args = settings.arguments as String;

        final userPreference = UserData.fromJson(json.decode(args));

        return MaterialPageRoute(
            builder: (_) => AddProductSuccess(user: userPreference));
      case AppRoutes.virtualTryOn:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => VirtualTryOn(
                  productUrl: args["productUrl"].toString(),
                  userId: args["userId"].toString(),
                  productId: args["productId"].toString(),
                  description: args["description"].toString(),
                ));
      case AppRoutes.editProfile:
        final args = settings.arguments as String;

        final userPreference = UserData.fromJson(json.decode(args));

        return MaterialPageRoute(
            builder: (_) => EditProfilePage(user: userPreference));
      case AppRoutes.productsDetails:
        final args = settings.arguments as Map<String, dynamic>;

        final product = ProductModel.fromJson(json.decode(args["product"]));
        final userPreference = UserData.fromJson(json.decode(args["user"]));

        return MaterialPageRoute(
            builder: (_) =>
                ProductsDetails(product: product, user: userPreference));
      case AppRoutes.confirmationPage:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ConfirmationPage(
            pageComingFrom: args,
          ),
        );
      case AppRoutes.savedCards:
        final args = settings.arguments as String;
        final userData = UserData.fromJson(json.decode(args));
        return MaterialPageRoute(
          builder: (_) => SavedCards(
            user: userData,
          ),
        );
      case AppRoutes.searchResult:
        final args = settings.arguments as Map<String, dynamic>;
        final userData = UserData.fromJson(json.decode(args["user"]));
        return MaterialPageRoute(
          builder: (_) => ResultPage(
            user: userData,
            image: args["image"],
            search: args["search"],
            name: args["name"],
          ),
        );
      case AppRoutes.savedAddress:
        final args = settings.arguments as String;
        final userData = UserData.fromJson(json.decode(args));

        return MaterialPageRoute(
          builder: (_) => SavedAddress(
            user: userData,
          ),
        );
      case AppRoutes.emailVerification:
        final args = settings.arguments as Map<String, dynamic>;
        final userData = UserData.fromJson(json.decode(args["user"]));

        return MaterialPageRoute(
          builder: (_) => EmailVerification(
            user: userData,
            page: args["page"],
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
      case AppRoutes.changePassword:
        final args = settings.arguments as Map<String, dynamic>;
        final userData = UserData.fromJson(json.decode(args["user"]));

        return MaterialPageRoute(
          builder: (_) => ChangePassword(
            user: userData,
          ),
        );
      case AppRoutes.newPassword:
        final args = settings.arguments as Map<String, dynamic>;
        final userData = UserData.fromJson(json.decode(args["user"]));

        return MaterialPageRoute(
          builder: (_) => NewPassword(
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
        final Map<String, dynamic> preferencesMap = args["preferences"];

        // Corresponding string arrays for the preferences
        List<String> types = [
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

        final List<String> seasons = [
          'Spring',
          'Summer',
          'Fall',
          'Winter',
        ];

        final List<String> styles = [
          "Casual",
          "Sports",
          "Formal",
          "Party",
          "Smart Casual",
          "Travel",
        ];

        List<bool> mapToBooleanArray(
            List<String> items, List<dynamic> preferences) {
          List<bool> booleanArray = List.filled(items.length, false);
          for (var preference in preferences) {
            int index = items.indexOf(preference as String);
            if (index != -1) {
              booleanArray[index] = true;
            }
          }
          return booleanArray;
        }

        final Map<String, List<bool>> preferences = {
          "Material":
              mapToBooleanArray(types, preferencesMap["Material"] ?? []),
          "Style": mapToBooleanArray(styles, preferencesMap["Style"] ?? []),
          "Occasion":
              mapToBooleanArray(seasons, preferencesMap["Occasion"] ?? []),
        };

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
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BottomNavbar(
            selectedIndex: args["selectedIndex"] ?? 0,
            user: args["user"],
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
