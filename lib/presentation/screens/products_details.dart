import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/blocs/business_state.dart';
import 'package:style_sphere/businessLogic/blocs/product_state.dart';
import 'package:style_sphere/businessLogic/blocs/user_state.dart';
import 'package:style_sphere/businessLogic/cubits/business_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/product_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/products_data.dart';
import 'package:style_sphere/data/repositories/business_repository.dart';
import 'package:style_sphere/data/repositories/product_repository.dart';
import 'package:style_sphere/data/repositories/user_repository.dart';
import 'package:style_sphere/presentation/constant_Widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/router.dart';

class ProductsDetails extends StatefulWidget {
  final ProductModel product;

  const ProductsDetails({super.key, required this.product});

  @override
  State<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  @override
  Widget build(BuildContext context) {
    bool selected = false;
    Color color = const Color(0xffF5F6FA);
    final sizeList = ["S", "M", "L", "XL", "2XL"];
    final cubit = BlocProvider.of<userCubit>(context);

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
            create: (context) => ProductCubit(repository: ProductRepository())
              ..getSimilarProducts(widget.product.imageUrls![0], null, null)),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: BlocListener<userCubit, userStates>(
              listener: (context, state) async {
                if (state is GetUserDataSuccessState) {
                  await context
                      .read<BusinessCubit>()
                      .fetchBusiness(widget.product.businessID.toString());
                  print(widget.product.businessID.toString());
                }
              },
              child: BlocBuilder<userCubit, userStates>(
                builder: (context, state) {
                  return BlocBuilder<BusinessCubit, BusinessState>(
                    builder: (context, businessState) {
                      if (state is GetUserDataLoadingState ||
                          businessState is BusinessLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetUserDataSuccessState &&
                          businessState is BusinessLoadedState) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        const Spacer(),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.favorite_border,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.share,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.share,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Image.network(
                                      widget.product.imageUrls![0],
                                      fit: BoxFit.fitHeight,
                                      height: 32.h,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: SizedBox(
                                      height: 5.h,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          widget.product.category == "Topwear"
                                              ? Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pushNamed(
                                                  AppRoutes.virtualTryOn,
                                                  arguments: {
                                                    "productUrl": widget
                                                        .product.imageUrls![0],
                                                    "productID": widget
                                                        .product.productID
                                                        .toString(),
                                                    "userId": widget
                                                        .product.businessID,
                                                    "description": widget
                                                        .product.description,
                                                  },
                                                )
                                              : null;
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                widget.product.category ==
                                                        "Topwear"
                                                    ? MaterialStateProperty.all<
                                                        Color>(primaryColor)
                                                    : MaterialStateProperty.all<
                                                        Color>(whiteColor),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.camera_alt_outlined,
                                              color: widget.product.category ==
                                                      "Topwear"
                                                  ? whiteColor
                                                  : grey50Color,
                                              size: 7.w,
                                            ),
                                            SizedBox(width: 2.w),
                                            buildCustomTextGabarito(
                                              text: "Try Me!",
                                              fontSize: 12,
                                              color: widget.product.category ==
                                                      "Topwear"
                                                  ? whiteColor
                                                  : grey50Color,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildCustomTextGabarito(
                                                text: widget.product.material
                                                    .toString(),
                                                fontSize: 12,
                                                color: grey50Color),
                                            buildCustomTextGabarito(
                                              text: widget.product.name
                                                  .toString(),
                                              fontSize: 15,
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            buildCustomTextGabarito(
                                              text: "Price",
                                              fontSize: 12,
                                              color: grey50Color,
                                            ),
                                            buildCustomTextGabarito(
                                              text: state.user
                                                          .currencyPreference ==
                                                      "USD"
                                                  ? "\$${widget.product.price}"
                                                  : "${widget.product.price} LE",
                                              fontSize: 15,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    buildSizedBox(1.h),
                                    widget.product.imageUrls!.length > 1
                                        ? SizedBox(
                                            height: 10.h,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: widget
                                                  .product.imageUrls!.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.network(
                                                    widget.product
                                                        .imageUrls![index],
                                                    fit: BoxFit.fitHeight,
                                                    height: 10.h,
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : const SizedBox(),
                                    buildSizedBox(1.h),
                                    widget.product.category == "Topwear" ||
                                            widget.product.category ==
                                                "Bottomwear"
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              buildCustomTextGabarito(
                                                text: "Size",
                                                fontSize: 12,
                                                color: blackColor,
                                              ),
                                              buildSizedBox(0.5.h),
                                              SizedBox(
                                                height: 6.h,
                                                width: double.infinity,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: sizeList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selected = !selected;
                                                          color = selected
                                                              ? primaryColor
                                                              : const Color(
                                                                  0xffF5F6FA);
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  sizeList
                                                                      .length -
                                                              20,
                                                          decoration:
                                                              BoxDecoration(
                                                            // border: Border.all(
                                                            //     color: grey50Color),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: color,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: widget
                                                                        .product
                                                                        .quantities![
                                                                            0]
                                                                        .split("[")[
                                                                            1]
                                                                        .split("]")[
                                                                            0]
                                                                        .split(
                                                                            ",")
                                                                        .length <=
                                                                    index
                                                                ? buildCustomTextGabarito(
                                                                    text: sizeList[
                                                                        index],
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        grey50Color,
                                                                    align: TextAlign
                                                                        .center,
                                                                  )
                                                                : widget.product
                                                                            .quantities![0]
                                                                            .split("[")[1]
                                                                            .split("]")[0]
                                                                            .split(",")[index] ==
                                                                        "0"
                                                                    ? buildCustomTextGabarito(
                                                                        text: sizeList[
                                                                            index],
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            grey50Color,
                                                                        align: TextAlign
                                                                            .center,
                                                                      )
                                                                    : buildCustomTextGabarito(
                                                                        text: sizeList[
                                                                            index],
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            blackColor,
                                                                        align: TextAlign
                                                                            .center,
                                                                      ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          )
                                        : const SizedBox(),
                                    buildSizedBox(0.5.h),
                                    buildCustomTextGabarito(
                                      text: "Description",
                                      fontSize: 12,
                                      color: blackColor,
                                    ),
                                    buildSizedBox(0.5.h),
                                    buildCustomTextGabarito(
                                      text:
                                          widget.product.description.toString(),
                                      fontSize: 11,
                                      color: grey50Color,
                                    ),
                                    buildSizedBox(1.h),
                                    Row(
                                      children: [
                                        buildCustomTextGabarito(
                                          text: "Condition: ",
                                          fontSize: 12,
                                          color: blackColor,
                                        ),
                                        buildCustomTextGabarito(
                                          text: widget.product.condition
                                              .toString(),
                                          fontSize: 11,
                                          color: grey50Color,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        buildCustomTextGabarito(
                                          text: "Category: ",
                                          fontSize: 12,
                                          color: blackColor,
                                        ),
                                        buildCustomTextGabarito(
                                          text: widget.product.category
                                              .toString(),
                                          fontSize: 11,
                                          color: grey50Color,
                                        ),
                                      ],
                                    ),
                                    buildSizedBox(1.h),
                                    buildCustomTextGabarito(
                                      text: "About the seller",
                                      fontSize: 12,
                                      color: blackColor,
                                    ),
                                    buildSizedBox(1.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            businessState
                                                .businesses[0].businessUrl
                                                .toString(),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildCustomTextGabarito(
                                              text: businessState
                                                  .businesses[0].businessName
                                                  .toString(),
                                              fontSize: 11,
                                              color: blackColor,
                                            ),
                                            buildCustomTextGabarito(
                                              text: businessState
                                                  .businesses[0].bio
                                                  .toString(),
                                              fontSize: 11,
                                              color: grey50Color,
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.chat_bubble))
                                      ],
                                    ),
                                    buildSizedBox(1.h),
                                    buildCustomTextGabarito(
                                      text: "You might also like",
                                      fontSize: 12,
                                      color: blackColor,
                                    ),
                                    buildSizedBox(1.h),
                                    BlocBuilder<ProductCubit, ProductState>(
                                        builder: (context, productState) {
                                      if (productState is ProductLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (productState
                                          is ProductsLoaded) {
                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: SizedBox(
                                            height: 30.h,
                                            child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pushNamed(
                                                      AppRoutes.productsDetails,
                                                      arguments: json.encode(
                                                          productState.products[
                                                                  'available']![
                                                              index]),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    margin:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Image.network(
                                                      productState
                                                          .products[
                                                              "available"]![
                                                              index]
                                                          .imageUrls![0],
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: productState
                                                          .products['available']
                                                          ?.length ==
                                                      10
                                                  ? 9
                                                  : productState
                                                      .products['available']
                                                      ?.length,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    }),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            buildCustomTextGabarito(
                                              text: "Price",
                                              fontSize: 8,
                                              color: grey50Color,
                                            ),
                                            buildCustomTextGabarito(
                                              text: state.user
                                                          .currencyPreference ==
                                                      "USD"
                                                  ? "\$${widget.product.price}"
                                                  : "${widget.product.price} LE",
                                              fontSize: 10,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Text("error loading data");
                      }
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
