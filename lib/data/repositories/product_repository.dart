import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:style_sphere/data/models/products_data.dart';

class ProductRepository {
  ProductRepository();

  String baseUrl = 'http://127.0.0.1:3040';

  Future<ProductModel> getProduct(String productId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$productId'));
    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 201) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<ProductModel> updateProduct(
      String productId, ProductModel product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$productId'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/products/$productId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<ProductModel>.from(
          l.map((model) => ProductModel.fromJson(model)));
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response =
        await http.get(Uri.parse('$baseUrl/products?category=$category'));
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<ProductModel>.from(
          l.map((model) => ProductModel.fromJson(model)));
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  Future<Map<String, List<ProductModel>>> getProductsByBusiness(
      String businessId) async {
    final uri = Uri.parse('$baseUrl/products/')
        .replace(queryParameters: {'business': businessId});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> productsDataList = jsonDecode(response.body);
      List<ProductModel> products = productsDataList
          .map((productsDataJson) => ProductModel.fromJson(productsDataJson))
          .toList();

      List<ProductModel> availableProducts = [];
      List<ProductModel> soldOutProducts = [];

      for (var product in products) {
        if (product.quantities!
            .every((quantity) => quantity.trim() == "0,0,0")) {
          soldOutProducts.add(product);
        } else {
          availableProducts.add(product);
        }
      }

      return {
        'available': availableProducts,
        'soldOut': soldOutProducts,
      };
    } else {
      throw Exception('Failed to load products by business');
    }
  }
}
