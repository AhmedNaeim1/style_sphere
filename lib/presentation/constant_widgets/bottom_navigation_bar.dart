import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/presentation/screens/Selling/add_product.dart';
import 'package:style_sphere/presentation/screens/Selling/start_selling.dart';
import 'package:style_sphere/presentation/screens/chatbot.dart';
import 'package:style_sphere/presentation/screens/home.dart';
import 'package:style_sphere/presentation/screens/profile.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final ValueChanged<int> onItemTapped;
  final int selectedIndex;

  const MyBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Sell',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: primaryColor,
      unselectedItemColor: grey20Color,
      onTap: (index) {
        widget.onItemTapped(index);
      },
    );
  }
}

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
            : SellingPage(),
        Chatbot(user: user!),
        const ProfilePage(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const ImageIcon(
            AssetImage('assets/navbarHome.png'),
          ),
          title: ("Home"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: grey20Color,
        ),
        PersistentBottomNavBarItem(
          icon: const ImageIcon(
            AssetImage('assets/navbarSell.png'),
          ),
          title: ("Sell"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: grey20Color,
        ),
        PersistentBottomNavBarItem(
          icon: const ImageIcon(
            AssetImage('assets/navbarChat.png'),
          ),
          title: ("Chat"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: grey20Color,
        ),
        PersistentBottomNavBarItem(
          icon: const ImageIcon(
            AssetImage('assets/navbarProfile.png'),
          ),
          title: ("Profile"),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: grey20Color,
        ),
      ];
    }

    PersistentTabController controller;
    controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(
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
