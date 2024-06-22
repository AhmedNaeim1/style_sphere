import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/blocs/product_state.dart';
import 'package:style_sphere/businessLogic/cubits/product_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/reco_cubit.dart';
import 'package:style_sphere/data/models/products_data.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/data/repositories/product_repository.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/functions/constant_functions.dart';
import 'package:style_sphere/presentation/router.dart';

class MyHomePage extends StatefulWidget {
  final UserData? user;

  const MyHomePage({super.key, this.user});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(
          create: (context) =>
              ProductCubit(repository: ProductRepository())..getAllProducts(),
        ),
        BlocProvider<RecommendedProductCubit>(
          create: (context) => RecommendedProductCubit(
            repository: ProductRepository(),
          )..getRecommendedProducts(widget.user!),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      border: InputBorder.none,
                      hintText: "Search...",
                      suffixIcon: IconButton(
                        onPressed: () async {
                          String imagePath = await handleImage();
                          File image = File(imagePath);

                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(AppRoutes.searchResult, arguments: {
                            "user": json.encode(widget.user),
                            "image": image,
                            "search": false,
                          });
                        },
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: _isFocused ? Colors.black : Colors.grey,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: _isFocused ? Colors.black : Colors.grey,
                      ),
                    ),
                    onEditingComplete: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(AppRoutes.searchResult, arguments: {
                        "user": json.encode(widget.user),
                        "name": _controller.text,
                        "search": true,
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6FA),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    // Navigator.of(context).pushNamed(AppRoutes.filterProducts, arguments: widget.user);
                  },
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, productState) {
                    if (productState is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (productState is NewProductsLoaded) {
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildCustomTextGabarito(
                              text: "Newly Posted",
                              fontSize: 14,
                            ),
                            buildSizedBox(2.h),
                            Expanded(
                              child: _buildProductGrid(
                                  context, productState.newProducts),
                            ),
                            buildSizedBox(2.h),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                BlocBuilder<RecommendedProductCubit, RecommendedProductState>(
                  builder: (context, recommendedState) {
                    if (recommendedState is RecommendedProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (recommendedState is RecommendedProductsLoaded) {
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildCustomTextGabarito(
                              text: "Recommended",
                              fontSize: 14,
                            ),
                            buildSizedBox(2.h),
                            Expanded(
                              child: _buildProductGrid(
                                  context,
                                  recommendedState
                                      .recommendedProducts["available"]!),
                            ),
                          ],
                        ),
                      );
                    } else if (recommendedState is ProductError) {
                      return SizedBox();
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List<ProductModel> products) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.73,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.productsDetails,
              arguments: {
                "product": json.encode(products[index]),
                "user": json.encode(widget.user)
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(
                          products[index].imageUrls![0].toString() == "null"
                              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                              : products[index].imageUrls![0].toString(),
                        ),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    width: double.infinity,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 8),
                buildCustomTextGabarito(
                  text: products[index].name.toString(),
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                buildCustomTextGabarito(
                  text: products[index].description.toString(),
                  fontSize: 8,
                  fontWeight: FontWeight.normal,
                ),
                buildCustomTextGabarito(
                  text: products[index].price.toString(),
                  fontSize: 8,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
