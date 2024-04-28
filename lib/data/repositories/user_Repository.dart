import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:style_sphere/presentation/functions/constant_functions.dart';

import '../models/user_Data.dart';

class UserRepository {
  UserRepository();

  Future<UserData> getUserData() async {
    UserData user = UserData();

    final response =
        await http.get(Uri.parse('http://localhost:3020/user/${user.userID}'));
    if (response.statusCode == 200) {
      user = UserData.fromJson(jsonDecode(response.body));
      return user;
    } else {
      return user;
    }
  }

  Future<UserData> getUserDataFromSharedPreferences() async {
    UserData user = UserData();

    user = (await getUserPreferencesInfo())!;

    return user;
  }

  Future<dynamic> logIn(String email, String password) async {
    UserData user;
    final response =
        await http.post(Uri.parse('http://127.0.0.1:3005/user/login'), body: {
      'email': email,
      'password': password,
    });
    if (response.statusCode == 200) {
      try {
        user = UserData.fromJson(jsonDecode(response.body));

        return user;
      } catch (e) {
        return response.body;
      }
    } else {
      return "Error while logging in";
    }
  }

  Future<dynamic> registerUser(UserData user) async {
    final response = await http.post(
        Uri.parse('http://127.0.0.1:3005/user/signup'),
        body: jsonEncode(user.toJson()),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      UserData user = UserData.fromJson(jsonDecode(response.body));

      return user;
    } else if (response.statusCode == 200) {
      final responses = jsonDecode(response.body);
      return responses;
    } else {
      return "error";
    }
  }

  updateUserPreferences(String userId, UserData userPreferencesInfo) async {
    userPreferencesInfo.userID = userId;
    final response = await http.put(
        Uri.parse('http://127.0.0.1:3005/user/$userId/preferences'),
        body: jsonEncode(userPreferencesInfo.toJson()),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      UserData user = UserData.fromJson(jsonDecode(response.body));

      return user;
    } else {
      return "error";
    }
  }

  // Future<void> uploadUserData(
  //     String userID, BuildContext context, UserData user) async {
  //   try {
  //     await _firestore.collection('users').doc(userID).set(user.toJson());
  //     print("success");
  //   } catch (e) {
  //     print('ERROR ---> $e');
  //   }
  // }

  List<String> generateNumberList() {
    return List<String>.generate(6, (index) => (index + 1).toString());
  }
}
