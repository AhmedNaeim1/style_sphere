import 'package:style_sphere/data/models/checkout/payment_data.dart';

abstract class PaymentState {}

class PaymentLoadingState extends PaymentState {}

class PaymentLoadedState extends PaymentState {
  final List<PaymentData> payments;

  PaymentLoadedState(this.payments);
}

class PaymentDeletedState extends PaymentState {}

class PaymentAddedState extends PaymentState {}

class PaymentUpdatedState extends PaymentState {}

class PaymentOperationSuccess extends PaymentState {}

class PaymentErrorState extends PaymentState {
  final String errorMessage;

  PaymentErrorState(this.errorMessage);
}
