import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_sphere/data/models/user_data.dart';

Future<void> savePreferencesInfo(UserData userPreferencesInfo) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userPreferencesInfoJson = json.encode(userPreferencesInfo.toJson());
  await prefs.setString('user_info', userPreferencesInfoJson);
}

Future<UserData?> getUserPreferencesInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userPreferencesInfoString = prefs.getString('user_info');

  if (userPreferencesInfoString != null) {
    final userPreference =
        UserData.fromJson(json.decode(userPreferencesInfoString));
    return userPreference;
  }
  return null;
}

String formatCardNumber(String cardNumber) {
  String formattedCardNumber = '';
  for (int i = 0; i < cardNumber.length; i++) {
    if (i != 0 && i % 4 == 0 && i != cardNumber.length - 1) {
      formattedCardNumber += ' ';
    }
    if (i >= cardNumber.length / 2 - 4 && i < cardNumber.length / 2 + 4) {
      formattedCardNumber += '*';
    } else {
      formattedCardNumber += cardNumber[i];
    }
  }
  return formattedCardNumber;
}

Future uploadImageFile(File file, String name) async {
  UploadTask uploadTask;
  final ref = FirebaseStorage.instance.ref().child(name);
  uploadTask = ref.putFile(file);
  final snapshot = await uploadTask.whenComplete(() {});
  final urlDownload = await snapshot.ref.getDownloadURL();
  return urlDownload;
}

Future<String> handleImage() async {
  final ImagePicker picker = ImagePicker();

  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  String imags = image!.path;
  return imags;
}
