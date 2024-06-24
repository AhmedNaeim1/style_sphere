import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/blocs/business_state.dart';
import 'package:style_sphere/businessLogic/blocs/product_state.dart';
import 'package:style_sphere/businessLogic/cubits/business_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/cart_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/product_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/products_data.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/data/repositories/business_repository.dart';
import 'package:style_sphere/data/repositories/product_repository.dart';
import 'package:style_sphere/presentation/constant_Widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/router.dart';

class ProductsDetails extends StatefulWidget {
  final ProductModel product;
  final UserData user;

  const ProductsDetails({super.key, required this.product, required this.user});

  @override
  State<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    final sizeList = ["S", "M", "L", "XL", "2XL"];

    return MultiBlocProvider(
      providers: [
        BlocProvider<BusinessCubit>(
          create: (context) => BusinessCubit(repository: BusinessRepository())
            ..fetchBusiness(widget.product.businessID.toString()),
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
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCustomTextGabarito(
                      text: "Price",
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    buildCustomTextGabarito(
                      text: widget.user.currencyPreference == "USD"
                          ? "\$${widget.product.price}"
                          : "${widget.product.price} LE",
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    await BlocProvider.of<CartCubit>(context).addProductToCart(
                      widget.user.userID.toString(),
                      widget.product.productID.toString(),
                      1,
                      DateTime.now().toString(),
                      widget.product.price!,
                    );
                    //go to carts page
                    Navigator.of(context).pushNamed(AppRoutes.cart,
                        arguments: json.encode(widget.user));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: buildCustomTextGabarito(
                    text: "Add to Cart",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  ? Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                      AppRoutes.virtualTryOn,
                                      arguments: {
                                        "productUrl":
                                            widget.product.imageUrls![0],
                                        "productID":
                                            widget.product.productID.toString(),
                                        "userId": widget.product.businessID,
                                        "description":
                                            widget.product.description,
                                      },
                                    )
                                  : null;
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    widget.product.category == "Topwear"
                                        ? WidgetStateProperty.all<Color>(
                                            primaryColor)
                                        : WidgetStateProperty.all<Color>(
                                            whiteColor),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: widget.product.category == "Topwear"
                                      ? whiteColor
                                      : grey50Color,
                                  size: 7.w,
                                ),
                                SizedBox(width: 2.w),
                                buildCustomTextGabarito(
                                  text: "Try Me!",
                                  fontSize: 12,
                                  color: widget.product.category == "Topwear"
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildCustomTextGabarito(
                                    text: widget.product.material.toString(),
                                    fontSize: 12,
                                    color: grey50Color),
                                buildCustomTextGabarito(
                                  text: widget.product.name.toString(),
                                  fontSize: 15,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                buildCustomTextGabarito(
                                  text: "Price",
                                  fontSize: 12,
                                  color: grey50Color,
                                ),
                                buildCustomTextGabarito(
                                  text: widget.user.currencyPreference == "USD"
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
                                  itemCount: widget.product.imageUrls!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        widget.product.imageUrls![index],
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
                                widget.product.category == "Bottomwear"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      scrollDirection: Axis.horizontal,
                                      itemCount: sizeList.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedSize = sizeList[index];
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      sizeList.length -
                                                  20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: selectedSize ==
                                                        sizeList[index]
                                                    ? primaryColor
                                                    : const Color(0xffF5F6FA),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: buildCustomTextGabarito(
                                                  text: sizeList[index],
                                                  fontSize: 14,
                                                  color: selectedSize ==
                                                          sizeList[index]
                                                      ? Colors.white
                                                      : blackColor,
                                                  align: TextAlign.center,
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
                          text: widget.product.description.toString(),
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
                              text: widget.product.condition.toString(),
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
                              text: widget.product.category.toString(),
                              fontSize: 11,
                              color: grey50Color,
                            ),
                          ],
                        ),
                        buildSizedBox(1.h),
                        BlocBuilder<BusinessCubit, BusinessState>(
                            builder: (context, businessState) {
                          if (businessState is BusinessLoadingState) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (businessState is BusinessLoadedState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                        businessState.businesses[0].businessUrl
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
                                          text: businessState.businesses[0].bio
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
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
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
                          } else if (productState is ProductsLoaded) {
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
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushNamed(
                                          AppRoutes.productsDetails,
                                          arguments: json.encode(productState
                                              .products['available']![index]),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        margin: const EdgeInsets.all(4.0),
                                        child: Image.network(
                                          productState
                                              .products["available"]![index]
                                              .imageUrls![0],
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: productState
                                              .products['available']?.length ==
                                          10
                                      ? 9
                                      : productState
                                          .products['available']?.length,
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
