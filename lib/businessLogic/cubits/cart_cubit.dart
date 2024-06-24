import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_sphere/businessLogic/blocs/cart_state.dart';
import 'package:style_sphere/data/repositories/cart_repository.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required CartRepository repository}) : super(CartInitial());
  final CartRepository cartRepository = CartRepository();

  static CartCubit get(context) => BlocProvider.of(context);

  void getAllCartItems(String userID) async {
    try {
      emit(CartLoading());
      final cartItems = await cartRepository.getAllCartItems(userID);
      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> addProductToCart(String userID, String productID, int quantity,
      String addedDate, double price) async {
    try {
      emit(CartLoading());
      final result = await cartRepository.addProductToCart(
          userID, productID, quantity, addedDate, price);
      emit(CartItemAdded(result));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void updateCartItemQuantity(
      String userID, String productID, int quantity) async {
    try {
      emit(CartLoading());
      final result = await cartRepository.updateCartItemQuantity(
          userID, productID, quantity);
      emit(CartItemUpdated(result));
      getAllCartItems(userID);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void removeProductFromCart(String userID, String productID) async {
    try {
      emit(CartLoading());
      await cartRepository.removeProductFromCart(userID, productID);
      emit(CartItemRemoved());
      getAllCartItems(userID);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
