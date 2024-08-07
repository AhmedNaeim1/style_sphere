import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:style_sphere/presentation/functions/constant_functions.dart';

import '../models/user_data.dart';

class UserRepository {
  UserRepository();

  Future<UserData> getUserData() async {
    UserData user = UserData();

    final response =
        await http.get(Uri.parse('http://127.0.0.1:3020/user/${user.userID}'));
    if (response.statusCode == 200) {
      user = UserData.fromJson(jsonDecode(response.body));
      return user;
    } else {
      return user;
    }
  }

  Future<UserData> getUserDataFromSharedPreferences() async {
    UserData? user = UserData();

    user = (await getUserPreferencesInfo());

    return user!;
  }

  Future<dynamic> logIn(String email, String password) async {
    UserData user;
    final response =
        await http.post(Uri.parse('http://127.0.0.1:3020/user/login'), body: {
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
        Uri.parse('http://127.0.0.1:3020/user/signup'),
        body: jsonEncode(user.toJson()),
        headers: {'Content-Type': 'application/json'});
    print("response");
    if (response.statusCode == 201) {
      UserData user = UserData.fromJson(jsonDecode(response.body));
      print(user);
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
        Uri.parse('http://127.0.0.1:3020/user/$userId/preferences'),
        body: jsonEncode(userPreferencesInfo.toJson()),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      UserData user = UserData.fromJson(jsonDecode(response.body));

      return user;
    } else {
      return "error";
    }
  }

  updateUser(String userId, UserData userInfo) async {
    userInfo.userID = userId;
    final response = await http.put(
        Uri.parse('http://127.0.0.1:3020/user/$userId'),
        body: jsonEncode(userInfo.toJson()),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      UserData user = UserData.fromJson(jsonDecode(response.body));

      return user;
    } else {
      return "error";
    }
  }

  changePassword(String userId, String oldPassword, String newPassword) async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:3020/user/$userId/changePassword'),
      body: {"oldPassword": oldPassword, "newPassword": newPassword},
    );

    if (response.statusCode == 200) {
      UserData user = UserData.fromJson(jsonDecode(response.body));

      return user;
    } else {
      return "error";
    }
  }

  sendOTP(String email) async {
    final response = await http
        .post(Uri.parse('http://127.0.0.1:3020/user/userOTPSending'), body: {
      "email": email,
    });

    if (response.statusCode == 200) {
      dynamic otp = jsonDecode(response.body);

      return otp["message"];
    } else {
      return "error";
    }
  }

  verifyOTP(String email, String otp, String id) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:3020/user/userOTPVerification'),
      body: {"email": email, "otp": otp, "id": id},
    );
    if (response.statusCode == 200) {
      UserData user = UserData.fromJson(jsonDecode(response.body));
      return user;
    } else {
      return "error";
    }
  }

  // checkOTP(String email, String otp) async {
  //   final response = await http.post(
  //       Uri.parse('http://' + serverIP + ':3020/user/otp'),
  //       body: jsonEncode({"email": email, "otp": otp}),
  //       headers: {'Content-Type': 'application/json'});
  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<void> uploadImage(File imageFile) async {
    const String uploadUrl =
        'https://storage.googleapis.com/style-sphere-graduation.appspot.com';

    try {
      // Read the image file as bytes
      List<int> imageBytes = await imageFile.readAsBytes();

      // Encode the image bytes to base64
      String base64Image = base64Encode(imageBytes);

      // Make a POST request to the Cloud Storage upload URL
      http.Response response = await http.post(
        Uri.parse(uploadUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          'image': base64Image,
        }),
      );

      // Check the response status
      if (response.statusCode == 200) {
        print('Image uploaded successfully.');
      } else {
        print('Error uploading image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
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
