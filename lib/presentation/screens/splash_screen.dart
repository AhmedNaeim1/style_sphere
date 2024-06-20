import 'package:flutter/material.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/presentation/constant_widgets/bottom_navigation_bar.dart';
import 'package:style_sphere/presentation/functions/constant_functions.dart';
import 'package:style_sphere/presentation/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  UserData? user;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: primaryColor,
    ).animate(_controller);

    getUserData();

    _controller.forward().whenComplete(() {
      Future.delayed(const Duration(seconds: 1));
      user == null
          ? Navigator.of(context)
              .pushReplacementNamed(AppRoutes.loginRegisterPage)
          // ? Navigator.of(context).pushNamed(
          //     AppRoutes.preferences,
          //     arguments: {
          //       'preferences': {
          //         "Style": user!.preferredStyles,
          //         "Material": user!.preferredMaterials,
          //         "Occasion": user!.preferredOccasions,
          //       },
          //       'profile': false,
          //       'preferencesPage': "Style",
          //     },
          //   )
          : Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    BottomNavbar(user: user!, selectedIndex: 0),
              ),
            );
    });
  }

  Future<void> getUserData() async {
    user = await getUserPreferencesInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
            backgroundColor: _colorAnimation.value,
            body: Center(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/splashScreen.png"),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center,
                  ),
                ),
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
