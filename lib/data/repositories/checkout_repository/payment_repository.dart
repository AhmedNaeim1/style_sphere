import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:style_sphere/data/models/checkout/payment_data.dart';

class PaymentRepository {
  PaymentRepository();

  Future<List<PaymentData>> getAllPayments() async {
    try {
      final response =
          await http.get(Uri.parse('http://your-api-url/payments'));
      if (response.statusCode == 200) {
        Iterable list = jsonDecode(response.body);
        List<PaymentData> payments =
            list.map((model) => PaymentData.fromJson(model)).toList();
        return payments;
      } else {
        throw Exception('Failed to fetch payments');
      }
    } catch (e) {
      throw Exception('Failed to fetch payments: $e');
    }
  }

  Future<bool> deletePayment(int paymentMethodID, String userID) async {
    try {
      final response = await http.delete(
          Uri.parse('http://127.0.0.1:8080/payments/$paymentMethodID/$userID'));
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete payment');
      }
    } catch (e) {
      throw Exception('Failed to delete payment: $e');
    }
  }

  Future<bool> addPayment(PaymentData payment) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8080/payments/add-payment'),
        body: jsonEncode(payment.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print(response.body);
        return true;
      } else {
        throw Exception('Failed to add payment');
      }
    } catch (e) {
      throw Exception('Failed to add payment: $e');
    }
  }

  Future<PaymentData> getPayment(int paymentMethodID, int userID) async {
    try {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:8080/payments/get-payment/$paymentMethodID/$userID'));
      if (response.statusCode == 200) {
        return PaymentData.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch payment');
      }
    } catch (e) {
      throw Exception('Failed to fetch payment: $e');
    }
  }

  Future<bool> updatePayment(
      int paymentMethodID, int userID, PaymentData payment) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://127.0.0.1:8080/payments/update-payment/$paymentMethodID/$userID'),
        body: jsonEncode(payment.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update payment');
      }
    } catch (e) {
      throw Exception('Failed to update payment: $e');
    }
  }

  Future<List<PaymentData>> getUserPayments(String userID) async {
    try {
      final response = await http.get(
          Uri.parse('http://127.0.0.1:8080/payments/get-user-payment/$userID'));
      if (response.statusCode == 200) {
        List<dynamic> paymentDataList = jsonDecode(response.body);

        List<PaymentData> payments = paymentDataList
            .map((paymentDataJson) => PaymentData.fromJson(paymentDataJson))
            .toList();
        return payments;
      } else {
        throw Exception('Failed to fetch user payments');
      }
    } catch (e) {
      throw Exception('Failed to fetch user payments: $e');
    }
  }
}
