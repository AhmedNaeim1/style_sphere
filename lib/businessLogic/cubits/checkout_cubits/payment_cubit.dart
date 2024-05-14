import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_sphere/businessLogic/blocs/checkout_blocs/payment_state.dart';
import 'package:style_sphere/data/models/checkout/payment_data.dart';
import 'package:style_sphere/data/repositories/checkout_repository/payment_repository.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit({required PaymentRepository repository})
      : super(PaymentLoadingState());
  final PaymentRepository _paymentRepository = PaymentRepository();

  static PaymentCubit get(context) => BlocProvider.of(context);

  void getAllPayments() async {
    try {
      List<PaymentData> payments = await _paymentRepository.getAllPayments();
      emit(PaymentLoadedState(payments));
    } catch (e) {
      emit(PaymentErrorState('Failed to fetch payments: $e'));
    }
  }

  void deletePayment(int paymentMethodID, String userID) async {
    try {
      bool deleted =
          await _paymentRepository.deletePayment(paymentMethodID, userID);
      if (deleted) {
        emit(PaymentDeletedState());
        getUserPayments(userID);
      } else {
        emit(PaymentErrorState('Failed to delete payment'));
      }
    } catch (e) {
      emit(PaymentErrorState('Failed to delete payment: $e'));
    }
  }

  void addPayment(PaymentData payment) async {
    try {
      String userID = payment.userID!;
      bool added = await _paymentRepository.addPayment(payment);
      if (added) {
        getUserPayments(userID);
        emit(PaymentAddedState());
      } else {
        emit(PaymentErrorState('Failed to add payment'));
      }
    } catch (e) {
      emit(PaymentErrorState('Failed to add payment: $e'));
    }
  }

  void getPayment(int paymentMethodID, int userID) async {
    try {
      PaymentData payment =
          await _paymentRepository.getPayment(paymentMethodID, userID);
      emit(PaymentLoadedState([payment]));
    } catch (e) {
      emit(PaymentErrorState('Failed to fetch payment: $e'));
    }
  }

  void updatePayment(
      int paymentMethodID, int userID, PaymentData payment) async {
    try {
      bool updated = await _paymentRepository.updatePayment(
          paymentMethodID, userID, payment);
      if (updated) {
        emit(PaymentUpdatedState());
      } else {
        emit(PaymentErrorState('Failed to update payment'));
      }
    } catch (e) {
      emit(PaymentErrorState('Failed to update payment: $e'));
    }
  }

  void getUserPayments(String userID) async {
    emit(PaymentLoadingState());
    try {
      print("object");
      print(userID);
      dynamic payments = await _paymentRepository.getUserPayments(userID);
      emit(PaymentLoadedState(payments));
    } catch (e) {
      emit(PaymentErrorState('Failed to fetch user payments: $e'));
    }
  }
}
