// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_sphere/businessLogic/blocs/user_state.dart';
import 'package:style_sphere/data/models/user_Data.dart';
import 'package:style_sphere/data/repositories/user_Repository.dart';
import 'package:style_sphere/presentation/functions/constant_functions.dart';
import 'package:style_sphere/presentation/router.dart';

// ignore: camel_case_types
class userCubit extends Cubit<userStates> {
  userCubit({required UserRepository repository}) : super(userInitialState());
  final UserRepository _userRepository = UserRepository();

  static userCubit get(context) => BlocProvider.of(context);

  void getUserData() async {
    emit(GetUserDataLoadingState());
    try {
      final user = await _userRepository.getUserDataFromSharedPreferences();

      emit(GetUserDataSuccessState(user: user));
    } catch (_) {
      emit(GetUserDataErrorState());
    }
  }

  void registerWithEmailPassword(
    UserData userData,
    BuildContext context,
  ) async {
    emit(userInitialState());
    emit(userRegisterLoadingState());

    try {
      final user = await _userRepository.registerUser(userData);

      if (user.runtimeType == UserData) {
        emit(userRegisterSuccessState());
        await savePreferencesInfo(user);
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.preferences,
          arguments: {
            'preferences': {"Style": [], "Material": [], "Occasion": []},
            'profile': false,
            'preferencesPage': 'Style',
          },
        );
      } else if (user["message"] != null) {
        emit(userRegisterErrorState());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${user["message"]}"),
            backgroundColor: Colors.red,
          ),
        );
      } else if (user == "error") {
        emit(userRegisterErrorState());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Error while registering your email. Please try again!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      emit(userRegisterErrorState());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Error while registering your email. Please try again!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //
  // Future<void> checkEmailVerification(BuildContext context) async {
  //   final User? user = _auth.currentUser;
  //   if (user != null) {
  //     await user
  //         .reload(); // Reload user data to get updated email verification status
  //     if (user.emailVerified) {
  //       // Email is verified, navigate to the dashboard
  //       Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
  //     }
  //   }
  // }

  //function for login with email and password
  void loginWithEmailPassword(
      String email, String password, BuildContext context) async {
    emit(userInitialState());

    emit(userLoginLoadingState());
    try {
      final user = await _userRepository.logIn(email, password);

      if (user.runtimeType == UserData) {
        emit(userLoginSuccessState());
        await savePreferencesInfo(user);

        Navigator.of(context).pushReplacementNamed(AppRoutes.navbar);
      } else if (user == "Error while logging in") {
        emit(userLoginErrorState());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error while logging in. Please try again!"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        emit(userLoginErrorState());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$user"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      //snackbar to show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect Email. Please try again!"),
          backgroundColor: Colors.red,
        ),
      );
      emit(userLoginErrorState());
    }
  }

  void updateUserPreferences(
      String userId, UserData userPreferencesInfo) async {
    try {
      final user = await _userRepository.updateUserPreferences(
          userId, userPreferencesInfo);

      savePreferencesInfo(user);
    } catch (e) {
      emit(UploadUserDataErrorState(error: e.toString()));
    }
  }
}

enum UserVerificationStatus {
  Verified,
  Unverified,
}
