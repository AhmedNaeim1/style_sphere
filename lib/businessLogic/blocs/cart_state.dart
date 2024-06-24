import 'package:style_sphere/data/models/cart_data.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Map<String, List<dynamic>> cartItems;

  CartLoaded(this.cartItems);
}

class CartItemAdded extends CartState {
  final CartModel addedItem;

  CartItemAdded(this.addedItem);
}

class CartItemUpdated extends CartState {
  final CartModel updatedItem;

  CartItemUpdated(this.updatedItem);
}

class CartItemRemoved extends CartState {}

class CartError extends CartState {
  final String error;

  CartError(this.error);
}
