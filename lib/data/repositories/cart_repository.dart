import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:style_sphere/data/models/cart_data.dart';

class CartRepository {
  CartRepository();

  String baseUrl = 'http://127.0.0.1:3020';

  Future<Map<String, List<dynamic>>> getAllCartItems(String userID) async {
    final response = await http.get(Uri.parse('$baseUrl/cart/$userID'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> cartItemsData = json.decode(response.body);
      List<dynamic> productIDs = cartItemsData['productIDs'];
      List<dynamic> quantities = cartItemsData['quantities'];
      return {
        'productIDs': productIDs,
        'quantities': quantities,
      };
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  Future<CartModel> addProductToCart(String userID, String productID,
      int quantity, String addedDate, double price) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(CartModel(
        userID: userID,
        productID: productID,
        quantity: quantity,
        addedDate: addedDate,
        price: price,
      ).toJson()),
    );

    if (response.statusCode == 201) {
      return CartModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add product to cart');
    }
  }

  Future<CartModel> updateCartItemQuantity(
      String userID, String productID, int quantity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(CartModel(
        userID: userID,
        productID: productID,
        quantity: quantity,
      ).toJson()),
    );

    if (response.statusCode == 200) {
      return CartModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update cart item quantity');
    }
  }

  Future<void> removeProductFromCart(String userID, String productID) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/$userID/$productID'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove product from cart');
    }
  }
}
