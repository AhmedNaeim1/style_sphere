import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:style_sphere/data/models/products_data.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/data/repositories/product_repository.dart';

// States
@immutable
abstract class RecommendedProductState {}

class RecommendedProductInitial extends RecommendedProductState {}

class RecommendedProductLoading extends RecommendedProductState {}

class RecommendedProductsLoaded extends RecommendedProductState {
  final Map<String, List<ProductModel>> recommendedProducts;

  RecommendedProductsLoaded(this.recommendedProducts);
}

class RecommendedProductError extends RecommendedProductState {
  final String message;

  RecommendedProductError(this.message);
}

// Cubit

class RecommendedProductCubit extends Cubit<RecommendedProductState> {
  RecommendedProductCubit({required ProductRepository repository})
      : super(RecommendedProductInitial());
  final ProductRepository _productRepository = ProductRepository();

  static RecommendedProductCubit get(context) => BlocProvider.of(context);

  void getRecommendedProducts(UserData user) async {
    try {
      emit(RecommendedProductLoading());
      final recommendedProducts =
          await _productRepository.getRecommendedProducts(user);
      final products =
          await _productRepository.getMultipleProducts(recommendedProducts);
      emit(RecommendedProductsLoaded(products));
    } catch (e) {
      emit(RecommendedProductError(e.toString()));
    }
  }
}
