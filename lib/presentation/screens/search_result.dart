import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_sphere/businessLogic/blocs/product_state.dart';
import 'package:style_sphere/businessLogic/cubits/product_cubit.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/data/repositories/product_repository.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/router.dart';

class ResultPage extends StatelessWidget {
  final UserData? user;
  final File? image;
  final bool search;
  final String? name;

  const ResultPage(
      {super.key, this.user, this.image, required this.search, this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar("Results", context, 20),
      body: BlocProvider<ProductCubit>(
        create: !search
            ? (context) => ProductCubit(repository: ProductRepository())
              ..getSimilarProducts(null, image, user!)
            : (context) => ProductCubit(repository: ProductRepository())
              ..getSearchProducts(name!),
        child: SafeArea(
          child: BlocListener<ProductCubit, ProductState>(
            listener: (context, productState1) async {
              // if (productState1 is ProductLoaded) {
              //   await context.read<ProductCubit>().getMultipleProducts(
              //         productState1.product.map((e) => e.productID!).toList(),
              //       );
              // }
            },
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, productState) {
                if (productState is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productState is ProductsLoaded) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          print(user!.businessID);
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.productsDetails,
                            arguments: {
                              "product": json.encode(
                                  productState.products['available']![index]),
                              "user": json.encode(user)
                            },
                          );
                          print(productState
                              .products['available']![index].businessID);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                        productState
                                                    .products['available']![
                                                        index]
                                                    .imageUrls![0]
                                                    .toString() ==
                                                "null"
                                            ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                                            : productState
                                                .products['available']![index]
                                                .imageUrls![0]
                                                .toString(),
                                      ),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: 200,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: buildCustomTextGabarito(
                                  text: productState
                                      .products['available']![index].name
                                      .toString(),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Flexible(
                                child: buildCustomTextGabarito(
                                  text: productState
                                      .products['available']![index].description
                                      .toString(),
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Expanded(
                                child: buildCustomTextGabarito(
                                  text: productState
                                      .products['available']![index].price
                                      .toString(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: productState.products['available']!.length,
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
