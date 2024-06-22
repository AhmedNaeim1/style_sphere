import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/presentation/screens/Selling/add_product.dart';
import 'package:style_sphere/presentation/screens/Selling/start_selling.dart';
import 'package:style_sphere/presentation/screens/chatbot.dart';
import 'package:style_sphere/presentation/screens/home.dart';
import 'package:style_sphere/presentation/screens/profile.dart';

class BottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final UserData? user;

  const BottomNavbar({super.key, required this.selectedIndex, this.user});

  @override
  Widget build(BuildContext context) {
    List<Widget> buildScreens() {
      return [
        MyHomePage(
          user: user,
        ),
        user!.businessID == null
            ? StartSelling(
                user: user!,
              )
            : const SellingPage(),
        Chatbot(user: user!),
        const ProfilePage(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Image.asset(
            "assets/navbarHomeActive.png",
            fit: BoxFit.fitHeight,
          ),
          inactiveIcon: Image.asset(
            "assets/navbarHome.png",
            fit: BoxFit.fitHeight,
          ),
          title: ("Home"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: grey20Color,
        ),
        PersistentBottomNavBarItem(
          icon: Image.asset("assets/navbarSellActive.png"),
          inactiveIcon: Image.asset("assets/navbarSell.png"),
          title: ("Sell"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: grey20Color,
        ),
        PersistentBottomNavBarItem(
          icon: Image.asset("assets/navbarChatActive.png"),
          inactiveIcon: Image.asset("assets/navbarChat.png"),
          title: ("Chat"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: grey20Color,
        ),
        PersistentBottomNavBarItem(
          icon: Image.asset("assets/navbarProfileActive.png"),
          inactiveIcon: Image.asset("assets/navbarProfile.png"),
          title: ("Profile"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: grey20Color,
        ),
      ];
    }

    PersistentTabController controller;
    controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(
      navBarHeight: 70,
      context,
      controller: controller,
      screens: buildScreens(),
      items: navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style14,
    );
  }
}
