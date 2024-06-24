import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/blocs/cart_state.dart';
import 'package:style_sphere/businessLogic/blocs/product_state.dart';
import 'package:style_sphere/businessLogic/cubits/cart_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/product_cubit.dart';
import 'package:style_sphere/data/models/checkout/payment_data.dart';
import 'package:style_sphere/data/models/products_data.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/data/repositories/cart_repository.dart';
import 'package:style_sphere/presentation/router.dart';

class CartPage extends StatefulWidget {
  final UserData user;

  const CartPage({super.key, required this.user});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String> addresses = [
    "43, Electronics City Phase 1, Electronic City",
    "47, Electronics City Phase 1, Electronic City",
  ];

  List<PaymentData> savedCards = [];

  String? selectedAddress;
  String? selectedPaymentMethod;
  String? selectedCardNumber;
  String? selectedPaymentMethodId;
  String? selectedAddressId;

  double get deliveryCharge => 10.0;

  void updateAddresses(List<String> newAddresses, String? newSelectedAddress) {
    setState(() {
      addresses = newAddresses;
      selectedAddress = newSelectedAddress;
    });
  }

  void updatePaymentMethod(String? method, String? cardNumber) {
    setState(() {
      selectedPaymentMethod = method;
      selectedCardNumber = cardNumber;
    });
  }

  void updateSavedCards(List<PaymentData> newSavedCards) {
    setState(() {
      savedCards = newSavedCards;
    });
  }

  double calculateSubtotal(List<ProductModel> products, List<int> quantities) {
    double subtotal = 0.0;
    for (int i = 0; i < products.length; i++) {
      subtotal += products[i].price! * quantities[i];
    }
    return subtotal;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
      create: (context) => CartCubit(repository: CartRepository())
        ..getAllCartItems(widget.user.userID.toString()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const CustomBackButton(),
          title: const Text('Cart', style: TextStyle(color: Colors.black)),
        ),
        body: BlocListener<CartCubit, CartState>(
          listener: (context, cartState) async {
            if (cartState is CartLoaded) {
              List<dynamic>? productIDs = cartState.cartItems["productIDs"];
              if (productIDs != null) {
                await context
                    .read<ProductCubit>()
                    .getMultipleProducts(productIDs.cast<String>());
              }
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        BlocBuilder<CartCubit, CartState>(
                          builder: (context, cartState) {
                            if (cartState is CartLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (cartState is CartLoaded) {
                              return BlocBuilder<ProductCubit, ProductState>(
                                builder: (context, productState) {
                                  if (productState is ProductLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (productState is ProductsLoaded) {
                                    double subtotal = calculateSubtotal(
                                      productState.products["available"]!,
                                      cartState.cartItems["quantities"]!
                                          .cast<int>(),
                                    );

                                    return Column(
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: productState
                                              .products["available"]!.length,
                                          itemBuilder: (context, index) {
                                            final item = productState
                                                .products["available"]![index];
                                            return Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10.4, 10, 10.4, 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 110,
                                                    width: 110,
                                                    margin: const EdgeInsets
                                                        .fromLTRB(
                                                        0, 0, 15.6, 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: NetworkImage(
                                                          item.imageUrls![0],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 0, 0, 10),
                                                          child: Text(
                                                            '${item.name}\n${item.category}',
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Gabarito',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 15,
                                                              height: 1.4,
                                                              color: Color(
                                                                  0xFF1D1E20),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 0, 0, 15),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              '\$${item.price.toString()}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Gabarito',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15,
                                                                height: 1.1,
                                                                color: Color(
                                                                    0xFF8F959E),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              IconButton(
                                                                icon: SvgPicture
                                                                    .asset(
                                                                        'assets/icons/arrow_down.svg',
                                                                        width:
                                                                            26.04,
                                                                        height:
                                                                            25),
                                                                onPressed: () {
                                                                  if (cartState.cartItems[
                                                                              "quantities"]![
                                                                          index] >
                                                                      1) {
                                                                    context.read<CartCubit>().updateCartItemQuantity(
                                                                        widget
                                                                            .user
                                                                            .userID
                                                                            .toString(),
                                                                        item.productID
                                                                            .toString(),
                                                                        cartState.cartItems["quantities"]![index] -
                                                                            1);
                                                                  }
                                                                },
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8),
                                                                child: Text(
                                                                  '${cartState.cartItems["quantities"]![index]}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'Gabarito',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        13,
                                                                    height: 1.1,
                                                                    color: Color(
                                                                        0xFF1D1E20),
                                                                  ),
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon: SvgPicture
                                                                    .asset(
                                                                        'assets/icons/arrow_up.svg',
                                                                        width:
                                                                            26.04,
                                                                        height:
                                                                            25),
                                                                onPressed: () {
                                                                  if (cartState.cartItems[
                                                                              "quantities"]![
                                                                          index] <
                                                                      99) {
                                                                    context.read<CartCubit>().updateCartItemQuantity(
                                                                        widget
                                                                            .user
                                                                            .userID
                                                                            .toString(),
                                                                        item.productID
                                                                            .toString(),
                                                                        cartState.cartItems["quantities"]![index] +
                                                                            1);
                                                                  }
                                                                },
                                                              ),
                                                              const Spacer(),
                                                              IconButton(
                                                                icon: SvgPicture
                                                                    .asset(
                                                                  'assets/icons/delete.svg',
                                                                  width: 26.04,
                                                                  height: 25,
                                                                ),
                                                                onPressed: () {
                                                                  context.read<CartCubit>().removeProductFromCart(
                                                                      widget
                                                                          .user
                                                                          .userID
                                                                          .toString(),
                                                                      item.productID
                                                                          .toString());
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        const Divider(thickness: 1),
                                        ListTile(
                                          leading: selectedAddress != null
                                              ? Image.asset('assets/map.png',
                                                  width: 52, height: 50)
                                              : null,
                                          title: const Text(
                                            'Delivery Address',
                                            style: TextStyle(
                                              fontFamily: 'Gabarito',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400,
                                              height: 1.1,
                                              color: Color(0xFF1D1E20),
                                            ),
                                          ),
                                          subtitle: selectedAddress != null
                                              ? Text(selectedAddress!,
                                                  style: const TextStyle(
                                                      fontFamily: 'Gabarito'))
                                              : null,
                                          trailing: const Icon(
                                              Icons.arrow_forward_ios),
                                          onTap: () async {
                                            final result =
                                                await Navigator.pushNamed(
                                                    context,
                                                    AppRoutes.savedAddress,
                                                    arguments: {
                                                  "user":
                                                      json.encode(widget.user),
                                                  "page": "home"
                                                });

                                            if (result != null &&
                                                result
                                                    is Map<String, dynamic>) {
                                              setState(() {
                                                selectedAddressId =
                                                    result['selectedAddress']
                                                        ?.shippingAddressID
                                                        .toString();
                                                selectedAddress =
                                                    result['selectedAddress']
                                                        ?.shippingAddress
                                                        .toString();
                                              });
                                            }
                                          },
                                        ),
                                        ListTile(
                                          leading: selectedPaymentMethod != null
                                              ? Image.asset('assets/pay.png',
                                                  width: 52, height: 50)
                                              : null,
                                          title: const Text(
                                            'Payment Method',
                                            style: TextStyle(
                                              fontFamily: 'Gabarito',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400,
                                              height: 1.1,
                                              color: Color(0xFF1D1E20),
                                            ),
                                          ),
                                          subtitle: selectedPaymentMethod !=
                                                  null
                                              ? Text(
                                                  '$selectedPaymentMethod ending in ${selectedCardNumber!.substring(selectedCardNumber!.length - 4)}',
                                                  style: const TextStyle(
                                                      fontFamily: 'Gabarito'),
                                                )
                                              : null,
                                          trailing: const Icon(
                                              Icons.arrow_forward_ios),
                                          onTap: () async {
                                            final result =
                                                await Navigator.pushNamed(
                                                    context,
                                                    AppRoutes.savedCards,
                                                    arguments: {
                                                  "user":
                                                      json.encode(widget.user),
                                                  "page": "home"
                                                });
                                            if (result != null &&
                                                result
                                                    is Map<String, dynamic>) {
                                              setState(() {
                                                selectedPaymentMethodId = result[
                                                        'selectedPaymentMethod']
                                                    ?.paymentMethodID
                                                    .toString();
                                                selectedPaymentMethod = "visa";
                                                selectedCardNumber = result[
                                                        'selectedPaymentMethod']
                                                    ?.cardNumber
                                                    .toString();
                                              });
                                            }
                                          },
                                        ),
                                        const Divider(thickness: 1),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Order Info',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Inter',
                                                  height: 1.1,
                                                  color: Color(0xFF1D1E20),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Column(
                                                children: [
                                                  OrderInfoRow(
                                                    label: 'Subtotal',
                                                    value:
                                                        '\$${subtotal.toStringAsFixed(2)}',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xFF8F959E),
                                                  ),
                                                  OrderInfoRow(
                                                    label: 'Delivery Charge',
                                                    value:
                                                        '\$${deliveryCharge.toStringAsFixed(2)}',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xFF8F959E),
                                                  ),
                                                  const Divider(thickness: 1),
                                                  OrderInfoRow(
                                                    label: 'Total',
                                                    value:
                                                        '\$${(subtotal + deliveryCharge).toStringAsFixed(2)}',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xFF1D1E20),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                width: double.infinity,
                                                height: 7.h,
                                                margin:
                                                    const EdgeInsets.all(16.0),
                                                child: ElevatedButton(
                                                  onPressed: selectedAddress !=
                                                              null &&
                                                          selectedPaymentMethod !=
                                                              null
                                                      ? () async {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              );
                                                            },
                                                          );

                                                          final productIDs =
                                                              cartState
                                                                      .cartItems[
                                                                  "productIDs"];
                                                          final quantities =
                                                              cartState
                                                                      .cartItems[
                                                                  "quantities"];
                                                          final total =
                                                              subtotal +
                                                                  deliveryCharge;

                                                          final orderData = {
                                                            "userID": widget
                                                                .user.userID
                                                                .toString(),
                                                            "productIds":
                                                                productIDs,
                                                            "quantities":
                                                                quantities,
                                                            "total": total,
                                                            "shippingAddressId":
                                                                selectedAddressId,
                                                            "paymentMethodId":
                                                                selectedPaymentMethodId
                                                          };

                                                          print(orderData);
                                                          try {
                                                            final response =
                                                                await http.post(
                                                              Uri.parse(
                                                                  'http://127.0.0.1:5001/create-order'),
                                                              headers: {
                                                                "Content-Type":
                                                                    "application/json"
                                                              },
                                                              body: json.encode(
                                                                  orderData),
                                                            );

                                                            // Close loading indicator
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            if (response
                                                                    .statusCode ==
                                                                201) {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  AppRoutes
                                                                      .addProductSuccess,
                                                                  arguments: {
                                                                    "user": json
                                                                        .encode(
                                                                            widget.user),
                                                                    "page": true
                                                                  });
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                    content: Text(
                                                                        'Failed to place order: ${response.body}')),
                                                              );
                                                            }
                                                          } catch (e) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      'Failed to place order: $e')),
                                                            );
                                                          }
                                                        }
                                                      : null,
                                                  child: const Text(
                                                    'Checkout',
                                                    style: TextStyle(
                                                      fontFamily: 'Gabarito',
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.1,
                                                      color: Color(0xFFFEFEFE),
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF0FAABC),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                        child: Text('No items in cart'));
                                  }
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text('No items in cart'));
                            }
                          },
                        ),
                      ],
                    ),
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

class OrderInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  OrderInfoRow({
    required this.label,
    required this.value,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: color,
              fontFamily: 'Inter',
              height: 1.1,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: color,
              fontFamily: 'Inter',
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }
}
