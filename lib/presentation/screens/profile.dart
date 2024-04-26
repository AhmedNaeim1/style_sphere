import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_Data.dart';
import 'package:style_sphere/presentation/router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData userData = UserData();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userDataResult =
        await BlocProvider.of<userCubit>(context).getUserData();
    setState(() {
      userData = userDataResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<userCubit>(context);
    return BlocProvider<userCubit>(
      create: (context) => userCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: darkBlueColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: greyBlueColor,
                size: 20.sp,
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
          ],
          title: Center(
            child: Text(
              "Profile",
              style: TextStyle(
                fontFamily: 'Gabarito',
                color: darkBlueColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(children: [
                    CircleAvatar(
                      radius: 30.sp,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 30.sp,
                        backgroundImage:
                            const AssetImage("assets/images/profile.png"),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 20.sp,
                        width: 20.sp,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 13.sp,
                            )),
                      ),
                    ),
                  ]),
                  Column(
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        "Selling",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        userData.followersCount.toString() == "null"
                            ? "0"
                            : userData.followersCount.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        "Followers",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        userData.followingCount.toString() == "null"
                            ? "0"
                            : userData.followingCount.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        "Following",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabAlignment: TabAlignment.center,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4)),
                          color: Colors.white,
                        ),
                        indicatorWeight: 3,
                        tabs: [
                          Text("One Way",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "RobotoRegular",
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF495057))),
                          Text(
                            "Round Trip",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "RobotoRegular",
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF495057)),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
