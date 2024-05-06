// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_sphere/businessLogic/blocs/user_state.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/data/repositories/user_repository.dart';
import 'package:style_sphere/presentation/functions/constant_functions.dart';
import 'package:style_sphere/presentation/router.dart';

// ignore: camel_case_types
class userCubit extends Cubit<userStates> {
  userCubit({required UserRepository repository}) : super(userInitialState());
  final UserRepository _userRepository = UserRepository();

  static userCubit get(context) => BlocProvider.of(context);

  void getUserPreferencesData() async {
    emit(GetUserDataLoadingState());
    try {
      final user = await _userRepository.getUserDataFromSharedPreferences();

      emit(GetUserDataSuccessState(user: user));
    } catch (_) {
      emit(GetUserDataErrorState());
    }
  }

  void getUserData() async {
    emit(GetUserDataLoadingState());
    try {
      final user = await _userRepository.getUserData();
      savePreferencesInfo(user);

      emit(GetUserDataSuccessState(user: user));
    } catch (_) {
      emit(GetUserDataErrorState());
    }
  }

  void updateUser(String userId, UserData userInfo) async {
    try {
      final user = await _userRepository.updateUser(userId, userInfo);

      savePreferencesInfo(user);
    } catch (e) {
      emit(UploadUserDataErrorState(error: e.toString()));
    }
  }

  void changePassword(String userId, String oldPassword, String newPassword,
      context, String page) async {
    try {
      final user = await _userRepository.changePassword(
          userId, oldPassword, newPassword);
      if (user.runtimeType == UserData) {
        savePreferencesInfo(user);
        if (page == "Forgot Password") {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.loginRegisterPage,
          );
        } else if (page == "Change Password") {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.confirmationPage,
            arguments: "Password",
          );
        }
      }
    } catch (e) {
      emit(UploadUserDataErrorState(error: e.toString()));
    }
  }

  void sendOTP(UserData user, BuildContext context, String page) async {
    emit(userInitialState());
    emit(userRegisterLoadingState());

    try {
      final otp = await _userRepository.sendOTP(user.email!);

      if (otp == "Success") {
        emit(userRegisterSuccessState());
        if (page == "Forgot Password") {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.emailVerification,
            arguments: {"user": json.encode(user), "page": "Forgot Password"},
          );
        } else {
          Navigator.pushReplacementNamed(
              context, AppRoutes.newEmailVerification,
              arguments: {"user": json.encode(user)});
        }
      } else {
        emit(userRegisterErrorState());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error while sending OTP. Please try again!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      emit(userRegisterErrorState());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error while sending OTP. Please try again!"),
          backgroundColor: Colors.red,
        ),
      );
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

      final otp = await _userRepository.sendOTP(user.user!.toString());

      if (user.runtimeType == UserData && otp == "Success") {
        emit(userRegisterSuccessState());
        await savePreferencesInfo(user);
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.emailVerification,
          arguments: {"user": json.encode(user), "page": "SignUp"},
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

  void verifyEmail(String email, String otp, BuildContext context, String page,
      String id) async {
    emit(userInitialState());
    emit(userRegisterLoadingState());

    try {
      final user = await _userRepository.verifyOTP(email, otp, id);
      print(user);
      if (user.runtimeType == UserData) {
        emit(userRegisterSuccessState());
        await savePreferencesInfo(user);
        if (page == "NewEmail") {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.confirmationPage,
            arguments: "",
          );
        } else if (page == "SignUp") {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.preferences,
            arguments: {
              'preferences': {"Style": [], "Material": [], "Occasion": []},
              'profile': false,
              'preferencesPage': 'Style',
            },
          );
        } else if (page == "Forgot Password") {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.newPassword,
            arguments: {"user": json.encode(user)},
          );
        }
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
