import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/screens/VTO/loading_screen.dart';
import 'package:style_sphere/presentation/screens/VTO/results_screen.dart';

class VirtualTryOn extends StatefulWidget {
  final String productUrl;
  final String userId;
  final String productId;
  final String description;

  const VirtualTryOn(
      {super.key,
      required this.productUrl,
      required this.userId,
      required this.productId,
      required this.description});

  @override
  _VirtualTryOnState createState() => _VirtualTryOnState();
}

class _VirtualTryOnState extends State<VirtualTryOn> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Create a stream controller for progress updates
      final progressController = StreamController<double>();

      // Navigate to the loading screen with the progress stream
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoadingScreen(progressStream: progressController.stream)),
      );

      try {
        firebase_storage.FirebaseStorage storage =
            firebase_storage.FirebaseStorage.instance;
        firebase_storage.Reference ref = storage
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}');

        // Upload the file and update progress
        firebase_storage.UploadTask uploadTask = ref.putFile(_image!);

        uploadTask.snapshotEvents
            .listen((firebase_storage.TaskSnapshot snapshot) {
          double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          progressController
              .add(progress * 0.5); // Update progress for upload (up to 50%)
        });

        await uploadTask.whenComplete(() async {
          String downloadURL = await ref.getDownloadURL();
          String clothURL = widget.productUrl;
          print('File Uploaded. Download URL: $downloadURL');

          const apiUrl = "https://vton.loca.lt/StyleSphereVirtualTryOn";

          var response = await http.post(
            Uri.parse(apiUrl),
            body: jsonEncode({
              'person_img': downloadURL,
              "cloth_img": clothURL,
              "userID": widget.userId,
              "productID": widget.productId,
              "description": widget.description,
            }),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );

          // Check if the request was successful (status code 200)
          if (response.statusCode == 200) {
            // Parse the JSON response
            Map<String, dynamic> jsonResponse = json.decode(response.body);
            var newImageUrl = jsonResponse['output'];
            // var error = jsonResponse['Error'];
            // if (error.toString().isNotEmpty) {
            //   print('Error: $error');
            //   progressController.close(); // Close the progress controller
            //   Navigator.pop(context); // Go back to the previous screen
            //   return;
            // } else {
            print('New Image URL: $newImageUrl');

            // Update progress to complete
            progressController.add(1.0);

            // Close the progress controller
            await Future.delayed(const Duration(seconds: 1));
            progressController.close();

            // Navigate to result page with the result image URL
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(imageUrl: newImageUrl),
              ),
            );
          } else {
            // Request failed with an error status code
            print('Request failed with status: ${response.statusCode}');
            progressController.close(); // Close the progress controller
            Navigator.pop(context); // Go back to the previous screen
          }
        });
      } catch (e) {
        print('Error uploading file: $e');
        progressController.close(); // Close the progress controller
        Navigator.pop(context); // Go back to the previous screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar("Virtual Try On", context, 14.sp),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;

          return Stack(
            children: [
              Positioned(
                top: screenHeight * 0.15,
                left: screenWidth * 0.1,
                child: Image.asset(
                  'assets/vto/woman.png',
                  // Replace with your woman's image path
                  height: screenHeight * 0.4,
                ),
              ),
              Positioned(
                top: 5,
                right: -screenWidth * 0.1,
                child: Transform.rotate(
                  angle: 0,
                  child: Opacity(
                    opacity: 0.56,
                    child: Image.asset(
                      'assets/vto/tshirt.png',
                      height: screenHeight * 0.25,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.11,
                left: -screenWidth * 0.05,
                child: Transform.rotate(
                  angle: 0,
                  child: Opacity(
                    opacity: 0.56,
                    child: Image.asset(
                      'assets/vto/Jacket.png',
                      height: screenHeight * 0.3,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.35,
                right: 0,
                child: Opacity(
                  opacity: 0.70,
                  child: Image.asset(
                    'assets/vto/hanger.png',
                    // Replace with your "ll" image path
                    height: screenHeight * 0.25,
                  ),
                ),
              ),
              Positioned(
                bottom: -screenHeight * 0.39,
                right: -screenWidth * 0.65,
                child: Opacity(
                  opacity: 0.7,
                  child: Image.asset(
                    'assets/vto/cart.png', // Replace with your cart image path
                    height: screenHeight,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 300),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Virtually Try This Item On Styl',
                                style: TextStyle(
                                  fontSize: 36.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Gabarito",
                                ),
                              ),
                              WidgetSpan(
                                child: Image.asset(
                                  'assets/vto/e.png',
                                  // Replace with your image path
                                  height: 36,
                                  // Adjust the height of the image as needed
                                  width:
                                      36, // Adjust the width of the image as needed
                                ),
                              ),
                              const TextSpan(
                                text: 'Sphere\n',
                                style: TextStyle(
                                  fontSize: 36.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Gabarito",
                                ),
                              ),
                              const TextSpan(
                                text:
                                    '\nUpload a Full Body Image To Virtually try On this Item On!',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontFamily: "Gabarito",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.1,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    decoration: BoxDecoration(
                      color: const Color(0xff0FAABC),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Upload Photo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
