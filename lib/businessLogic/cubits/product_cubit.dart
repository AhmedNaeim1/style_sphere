import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_sphere/businessLogic/blocs/product_state.dart';
import 'package:style_sphere/data/models/products_data.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/data/repositories/product_repository.dart';
import 'package:style_sphere/presentation/functions/constant_functions.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({required ProductRepository repository})
      : super(ProductInitial());
  final ProductRepository _productRepository = ProductRepository();

  static ProductCubit get(context) => BlocProvider.of(context);

  void getProduct(String productId) async {
    try {
      emit(ProductLoading());
      final product = await _productRepository.getProduct(productId);
      emit(ProductLoaded([product]));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // void getAllProducts() async {
  //   try {
  //     emit(ProductLoading());
  //     final products = await _productRepository.getAllProducts();
  //     emit(ProductLoaded(products));
  //   } catch (e) {
  //     emit(ProductError(e.toString()));
  //   }
  // }

  void getProductsByCategory(String category) async {
    try {
      emit(ProductLoading());
      final products = await _productRepository.getProductsByCategory(category);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getProductsByBusiness(String businessId) async {
    try {
      emit(ProductLoading());
      final products =
          await _productRepository.getProductsByBusiness(businessId);
      emit(ProductsLoaded(products));
    } catch (e) {
      print("object");
      emit(ProductError(e.toString()));
    }
  }

  void addProduct(ProductModel product) async {
    try {
      emit(ProductLoading());
      final newProduct = await _productRepository.addProduct(product);
      emit(ProductLoaded([newProduct]));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void updateProduct(String productId, ProductModel product) async {
    try {
      emit(ProductLoading());
      final updatedProduct =
          await _productRepository.updateProduct(productId, product);
      emit(ProductLoaded([updatedProduct]));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void deleteProduct(String productId) async {
    try {
      emit(ProductLoading());
      await _productRepository.deleteProduct(productId);
      getAllProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getMultipleProducts(List<String> productIds) async {
    try {
      emit(ProductLoading());
      final products = await _productRepository.getMultipleProducts(productIds);

      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getSimilarProducts(
      String? name, File? image, UserData? user) async {
    try {
      emit(ProductLoading());
      var listOfProducts;
      if (name == null) {
        var textResponse = await uploadImageFile(
          image!,
          "${user!.userID}_${user.name} search",
        );
        listOfProducts =
            await _productRepository.getSimilarProducts(textResponse);
      } else {
        listOfProducts = await _productRepository.getSimilarProducts(name);
      }
      final products =
          await _productRepository.getMultipleProducts(listOfProducts);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getSearchProducts(String name) async {
    try {
      emit(ProductLoading());
      print("here");
      print(name);
      final listOfProducts = await _productRepository.getSearchProducts(name);
      final products =
          await _productRepository.getMultipleProducts(listOfProducts);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void getAllProducts() async {
    try {
      emit(ProductLoading());
      print("here");
      final products = await _productRepository.getAllProducts();
      print(products);
      emit(NewProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
//
// void getRecommendedProducts(UserData user) async {
//   try {
//     emit(ProductLoading());
//     print("hereeeeee");
//     final listOfProducts =
//         await _productRepository.getRecommendedProducts(user);
//     final products =
//         await _productRepository.getMultipleProducts(listOfProducts);
//     emit(RecommendedProductsLoaded(products));
//   } catch (e) {
//     emit(ProductError(e.toString()));
//   }
// }
}
