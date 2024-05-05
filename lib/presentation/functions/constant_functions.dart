import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_sphere/data/models/user_data.dart';

Future<void> savePreferencesInfo(UserData userPreferencesInfo) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userPreferencesInfoJson = json.encode(userPreferencesInfo.toJson());
  await prefs.setString('user_info', userPreferencesInfoJson);
}

Future<UserData> getUserPreferencesInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userPreferencesInfoString = prefs.getString('user_info');

  final userPreference =
      UserData.fromJson(json.decode(userPreferencesInfoString!));
  return userPreference;
}
