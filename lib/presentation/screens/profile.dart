import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/blocs/business_state.dart';
import 'package:style_sphere/businessLogic/blocs/product_state.dart';
import 'package:style_sphere/businessLogic/blocs/user_state.dart';
import 'package:style_sphere/businessLogic/cubits/business_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/product_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/repositories/business_repository.dart';
import 'package:style_sphere/data/repositories/product_repository.dart';
import 'package:style_sphere/data/repositories/user_repository.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<userCubit>(
          create: (context) =>
              userCubit(repository: UserRepository())..getUserPreferencesData(),
        ),
        BlocProvider<BusinessCubit>(
          create: (context) => BusinessCubit(repository: BusinessRepository()),
        ),
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(repository: ProductRepository()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: greyBlueColor,
                size: 20.sp,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(AppRoutes.settings);
              },
            ),
          ],
          title: Text(
            "Profile",
            style: TextStyle(
              fontFamily: 'Gabarito',
              color: darkBlueColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocListener<userCubit, userStates>(
            listener: (context, state) async {
              if (state is GetUserDataSuccessState) {
                await context
                    .read<BusinessCubit>()
                    .fetchBusiness(state.user.userID.toString());
              }
            },
            child: BlocListener<BusinessCubit, BusinessState>(
              listener: (context, businessState) async {
                if (businessState is BusinessLoadedState) {
                  await context.read<ProductCubit>().getProductsByBusiness(
                      businessState.businesses[0].businessID.toString());
                }
              },
              child: BlocBuilder<userCubit, userStates>(
                builder: (context, state) {
                  return BlocBuilder<BusinessCubit, BusinessState>(
                    builder: (context, businessState) {
                      return BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, productState) {
                          if (state is GetUserDataLoadingState ||
                              businessState is BusinessLoadingState ||
                              productState is ProductLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is GetUserDataSuccessState &&
                              businessState is BusinessLoadedState &&
                              productState is ProductLoaded) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(children: [
                                        CircleAvatar(
                                          radius: 30.sp,
                                          backgroundColor: Colors.grey,
                                          child: CircleAvatar(
                                            radius: 30.sp,
                                            backgroundImage: NetworkImage(
                                              state.user.profilePictureUrl
                                                          .toString() ==
                                                      "null"
                                                  ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                                                  : state.user.profilePictureUrl
                                                      .toString(),
                                            ),
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
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
                                            productState
                                                .products["available"]!.length
                                                .toString(),
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
                                            state.user.followersCount
                                                        .toString() ==
                                                    "null"
                                                ? "0"
                                                : state.user.followersCount
                                                    .toString(),
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
                                            state.user.followingCount
                                                        .toString() ==
                                                    "null"
                                                ? "0"
                                                : state.user.followingCount
                                                    .toString(),
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
                                  buildSizedBox(2.h),
                                  buildCustomTextGabarito(
                                      text: state.user.name.toString().trim(),
                                      fontSize: 11),
                                  businessState.businesses.isEmpty
                                      ? Container()
                                      : buildCustomTextGabarito(
                                          text: businessState.businesses[0].bio
                                              .toString(),
                                          fontSize: 11),
                                  buildSizedBox(2.h),
                                  Expanded(
                                    child: DefaultTabController(
                                      length: 3,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 3.5.h,
                                            width: double.infinity,
                                            child: TabBar(
                                              unselectedLabelColor: grey20Color,
                                              labelColor: primaryColor,
                                              labelStyle: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: "RobotoRegular",
                                                fontWeight: FontWeight.w700,
                                              ),
                                              indicator: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                              ),
                                              indicatorWeight: 0,
                                              labelPadding: EdgeInsets.zero,
                                              tabs: [
                                                TabWidget(
                                                  text: "Selling",
                                                  isSelected: tabIndex == 0,
                                                ),
                                                TabWidget(
                                                  text: "Sold",
                                                  isSelected: tabIndex == 1,
                                                ),
                                                TabWidget(
                                                  text: "Saved",
                                                  isSelected: tabIndex == 2,
                                                ),
                                              ],
                                              onTap: (index) {
                                                setState(() {
                                                  tabIndex = index;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Expanded(
                                            child: TabBarView(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              children: [
                                                productState
                                                        .products["available"]!
                                                        .isEmpty
                                                    ? Column(
                                                        children: [
                                                          Text(
                                                            "You haven’t listed anything for sale yet",
                                                            style: TextStyle(
                                                              color:
                                                                  grey80Color,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          Text(
                                                            "You haven’t listed anything for sale yet",
                                                            style: TextStyle(
                                                              color:
                                                                  grey80Color,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : GridView.builder(
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount:
                                                              3, // Number of tiles per row
                                                        ),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child:
                                                                Image.network(
                                                              productState
                                                                          .products[
                                                                              "available"]![
                                                                              index]
                                                                          .imageUrls![
                                                                              0]
                                                                          .toString() ==
                                                                      "null"
                                                                  ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                                                                  : productState
                                                                      .products[
                                                                          "available"]![
                                                                          index]
                                                                      .imageUrls![
                                                                          0]
                                                                      .toString(),
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                            ),
                                                          );
                                                        },
                                                        itemCount: productState
                                                            .products[
                                                                "available"]!
                                                            .length,
                                                      ),
                                                productState
                                                        .products["soldOut"]!
                                                        .isEmpty
                                                    ? Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Items you have sold will appear here",
                                                          style: TextStyle(
                                                            color: grey80Color,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      )
                                                    : GridView.builder(
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount:
                                                              3, // Number of tiles per row
                                                        ),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Stack(
                                                              children: [
                                                                Center(
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            NetworkImage(
                                                                          productState.products["soldOut"]![index].imageUrls![0].toString() == "null"
                                                                              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                                                                              : productState.products["soldOut"]![index].imageUrls![0].toString(),
                                                                        ),
                                                                        fit: BoxFit
                                                                            .fitHeight,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5), // Adjust opacity as needed
                                                                  ),
                                                                ),
                                                                // "Sold" text
                                                                Center(
                                                                  child: Text(
                                                                    "Sold",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          whiteColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        itemCount: productState
                                                            .products[
                                                                "soldOut"]!
                                                            .length,
                                                      ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "Items you have saved will appear here",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
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
                            );
                          } else if (state is GetUserDataErrorState) {
                            return const Center(child: Text("Error"));
                          }
                          return const Center(child: Text("Error"));
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
