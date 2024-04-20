import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_sphere/data/models/user_Data.dart';

Future<void> savePreferencesInfo(UserData userPreferencesInfo) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userPreferencesInfoJson = json.encode(userPreferencesInfo.toJson());
  print(userPreferencesInfoJson);
  UserData user = UserData.fromJson(jsonDecode(userPreferencesInfoJson));
  print(user);
  await prefs.setString('user_info', userPreferencesInfoJson);
}

Future<UserData?> getUserPreferencesInfo() async {
  print("object");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  print("ss");
  final userPreferencesInfoString = prefs.getString('user_info');
  print(userPreferencesInfoString);
  if (userPreferencesInfoString != null) {
    final userPreference =
        UserData.fromJson(json.decode(userPreferencesInfoString));
    return userPreference;
  }
  return null;
}
