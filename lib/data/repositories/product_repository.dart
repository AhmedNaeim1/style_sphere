import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:style_sphere/data/models/products_data.dart';
import 'package:style_sphere/data/models/user_data.dart';

class ProductRepository {
  ProductRepository();

  String baseUrl = 'http://127.0.0.1:3020';

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
      List<dynamic> productsDataList = jsonDecode(response.body);
      List<ProductModel> products = productsDataList
          .map((productsDataJson) => ProductModel.fromJson(productsDataJson))
          .toList();

      List<ProductModel> availableProducts = [];
      List<ProductModel> soldOutProducts = [];
      for (var product in products) {
        var list = product.quantities!.split("[")[1].split("]")[0].split(",");

        if (list.every((quantity) => quantity.trim() == "0")) {
          soldOutProducts.add(product);
        } else {
          availableProducts.add(product);
        }
      }
      return availableProducts;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, List<ProductModel>>> getProductsByCategory(
      String category) async {
    final uri = Uri.parse('$baseUrl/products/')
        .replace(queryParameters: {'category': category});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> productsDataList = jsonDecode(response.body);
      List<ProductModel> products = productsDataList
          .map((productsDataJson) => ProductModel.fromJson(productsDataJson))
          .toList();

      List<ProductModel> availableProducts = [];
      List<ProductModel> soldOutProducts = [];

      for (var product in products) {
        var list = product.quantities!.split("[")[1].split("]")[0].split(",");

        if (list.every((quantity) => quantity.trim() == "0")) {
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

  Future<Map<String, List<ProductModel>>> getProductsByBusiness(
      String businessId) async {
    final uri = Uri.parse('$baseUrl/products/business/$businessId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> productsDataList = jsonDecode(response.body);
      List<ProductModel> products = productsDataList
          .map((productsDataJson) => ProductModel.fromJson(productsDataJson))
          .toList();
      print(products);

      List<ProductModel> availableProducts = [];
      List<ProductModel> soldOutProducts = [];

      for (var product in products) {
        var list = product.quantities!.split("[")[1].split("]")[0].split(",");

        if (list.every((quantity) => quantity.trim() == "0")) {
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

  Future<Map<String, List<ProductModel>>> getMultipleProducts(
      List<String> productIds) async {
    final uri = Uri.parse('$baseUrl/products/list');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'productIDs': productIds}),
    );

    if (response.statusCode == 200) {
      List<dynamic> productsDataList = jsonDecode(response.body);
      List<ProductModel> products = productsDataList
          .map((productsDataJson) => ProductModel.fromJson(productsDataJson))
          .toList();

      List<ProductModel> availableProducts = [];
      List<ProductModel> soldOutProducts = [];

      for (var product in products) {
        if (product.quantities![0]
            .split("[")[1]
            .split("]")[0]
            .split(",")
            .every((quantity) => quantity.trim() == "0")) {
          soldOutProducts.add(product);
        } else {
          availableProducts.add(product);
        }
      }

      print(availableProducts);
      return {
        'available': availableProducts,
        'soldOut': soldOutProducts,
      };
    } else {
      throw Exception('Failed to load products by business');
    }
  }

  Future<List<String>> getSimilarProducts(String image) async {
    final uri =
        Uri.parse('https://search-by-imagee.loca.lt/find-similar-images');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'image_url': image}),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      List<dynamic> productsDataList = responseBody["similar_image_ids"];
      return productsDataList.map((product) => product.toString()).toList();
    } else {
      throw Exception('Failed to load similar products');
    }
  }

  // https://firebasestorage.googleapis.com/v0/b/stylesphere-graduation.appspot.com/o/Hoddie_hazem.jpg?alt=media&token=e32b1e66-ce6b-4495-8ecc-45f11fcc1a44
  Future<List<String>> getRecommendedProducts(UserData user) async {
    print("object");
    final uri = Uri.parse(
        'https://3b8d-35-245-160-41.ngrok-free.app/RecommenderSystemUsingOpenAI');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "materials": user.preferredMaterials,
        "seasons": user.preferredOccasions,
        "types": user.preferredStyles,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> productsDataList = jsonDecode(response.body);
      return productsDataList.map((product) => product.toString()).toList();
    } else {
      throw Exception('Failed to load products by business');
    }
  }

  Future<List<String>> getSearchProducts(String name) async {
    final uri = Uri.parse(
        'https://300e-35-197-121-37.ngrok-free.app/StyleSphereSearch');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"combined": name}),
    );
    print(response.body);
    print("response.body");
    if (response.statusCode == 200) {
      List<dynamic> productsDataList = jsonDecode(response.body);
      return productsDataList.map((product) => product.toString()).toList();
    } else {
      throw Exception('Failed to load products by business');
    }
  }
}
