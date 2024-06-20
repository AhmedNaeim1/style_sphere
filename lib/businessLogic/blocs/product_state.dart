import 'package:style_sphere/data/models/products_data.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class NewProductsLoaded extends ProductState {
  final List<ProductModel> newProducts;

  NewProductsLoaded(this.newProducts);
}

class ProductsLoaded extends ProductState {
  final Map<String, List<ProductModel>> products;

  ProductsLoaded(this.products);
}

class ProductLoaded extends ProductState {
  final List<ProductModel> product;

  ProductLoaded(this.product);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
