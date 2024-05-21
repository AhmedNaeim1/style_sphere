import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_sphere/businessLogic/blocs/product_state.dart';
import 'package:style_sphere/data/models/products_data.dart';
import 'package:style_sphere/data/repositories/product_repository.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({required ProductRepository repository})
      : super(ProductInitial());
  final ProductRepository _productRepository = ProductRepository();

  static ProductCubit get(context) => BlocProvider.of(context);

  void getProduct(String productId) async {
    try {
      emit(ProductLoading());
      final product = await _productRepository.getProduct(productId);
      // emit(ProductLoaded([product]));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void getAllProducts() async {
    try {
      emit(ProductLoading());
      final products = await _productRepository.getAllProducts();
      // emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void getProductsByCategory(String category) async {
    try {
      emit(ProductLoading());
      final products = await _productRepository.getProductsByCategory(category);
      // emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getProductsByBusiness(String businessId) async {
    try {
      emit(ProductLoading());
      final products =
          await _productRepository.getProductsByBusiness(businessId);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void addProduct(ProductModel product) async {
    try {
      emit(ProductLoading());
      final newProduct = await _productRepository.addProduct(product);
      // emit(ProductLoaded([newProduct]));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void updateProduct(String productId, ProductModel product) async {
    try {
      emit(ProductLoading());
      final updatedProduct =
          await _productRepository.updateProduct(productId, product);
      // emit(ProductLoaded([updatedProduct]));
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
}
