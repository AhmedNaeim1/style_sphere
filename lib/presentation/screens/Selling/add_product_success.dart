import 'package:flutter/material.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/presentation/router.dart';

class AddProductSuccess extends StatefulWidget {
  final UserData user;
  final bool? page;

  const AddProductSuccess({super.key, required this.user, this.page});

  @override
  _AddProductSuccessState createState() => _AddProductSuccessState();
}

class _AddProductSuccessState extends State<AddProductSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;

          return Stack(
            children: [
              Positioned(
                top: screenHeight * 0.10,
                left: screenWidth * 0.01,
                child: Image.asset(
                  'assets/selling.png', // Replace with your woman's image path
                  height: screenHeight * 0.35,
                ),
              ),
              Positioned(
                top: -38,
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
                bottom: screenHeight * 0.09,
                left: -screenWidth * 0.1,
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
                bottom: screenHeight * 0.34,
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
                    const SizedBox(height: 100),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Successfully\n',
                                style: TextStyle(
                                  fontSize: 36.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Gabarito",
                                ),
                              ),
                              TextSpan(
                                text:
                                    widget.page! ? 'Ordered' : "Uploaded Item",
                                style: const TextStyle(
                                  fontSize: 36.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Gabarito",
                                ),
                              ),
                              TextSpan(
                                text: widget.page!
                                    ? ""
                                    : '\n\nView your uploaded items from the profile',
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
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.navbar, arguments: {
                      "selectedIndex": 0,
                      "user": widget.user,
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    decoration: BoxDecoration(
                      color: const Color(0xff0FAABC),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Continue Shopping',
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
