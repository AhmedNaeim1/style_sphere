// ignore_for_file: camel_case_types

abstract class userStates {}

class userInitialState extends userStates {}

//userLoginSuccessState stops loading and goes to home screen
class userLoginSuccessState extends userStates {}

//userLoginLoadingState starts loading
class userLoginLoadingState extends userStates {}

//userLoginErrorState
class userLoginErrorState extends userStates {
  final String? error;

  userLoginErrorState({this.error});
}

//userRegisterSuccessState stops loading and goes to confirn enail screen
class userRegisterSuccessState extends userStates {}

class UserVerificationLoadingState extends userStates {}

class UserVerificationSuccessState extends userStates {}

class UserVerificationErrorState extends userStates {}

//userRegisterLoadingState starts loading
class userRegisterLoadingState extends userStates {}

//userRegisterErrorState
class userRegisterErrorState extends userStates {
  final String? error;

  userRegisterErrorState({this.error});
}
//user stops loading and gies login screen

//UploadUserDataLoadingState
class UploadUserDataLoadingState extends userStates {}

//UploadUserDataSuccessState
class UploadUserDataSuccessState extends userStates {}

//UploadUserDataErrorState
class UploadUserDataErrorState extends userStates {
  final String? error;

  UploadUserDataErrorState({this.error});
}
