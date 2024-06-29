import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:style_sphere/data/models/checkout/shipment_data.dart';

class ShippingRepository {
  Future<List<ShipmentModel>> getAllShipments() async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1:3020/shipping/get-shipments'));
      if (response.statusCode == 200) {
        Iterable list = jsonDecode(response.body);
        List<ShipmentModel> shipments =
            list.map((model) => ShipmentModel.fromJson(model)).toList();
        return shipments;
      } else {
        throw Exception('Failed to fetch shipments');
      }
    } catch (e) {
      throw Exception('Failed to fetch shipments: $e');
    }
  }

  Future<bool> deleteShipment(int shippingAddressID, String userID) async {
    try {
      final response = await http.delete(Uri.parse(
          'http://127.0.0.1:3020/shipping/$shippingAddressID/$userID'));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete shipment');
      }
    } catch (e) {
      throw Exception('Failed to delete shipment: $e');
    }
  }

  Future<bool> addShipment(ShipmentModel shipment) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:3020/shipping/add-shipment'),
        body: jsonEncode(shipment.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add shipment');
      }
    } catch (e) {
      throw Exception('Failed to add shipment: $e');
    }
  }

  Future<ShipmentModel> getShipment(
      int shippingAddressID, String userID) async {
    try {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:3020/shipping/get-shipment/$shippingAddressID/$userID'));
      if (response.statusCode == 200) {
        return ShipmentModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch shipment');
      }
    } catch (e) {
      throw Exception('Failed to fetch shipment: $e');
    }
  }

  Future<bool> updateShipment(
      int shippingAddressID, String userID, ShipmentModel shipment) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://127.0.0.1:3020/shipping/update-shipment/$shippingAddressID/$userID'),
        body: jsonEncode(shipment.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update shipment');
      }
    } catch (e) {
      throw Exception('Failed to update shipment: $e');
    }
  }

  Future<List<ShipmentModel>> getUserShipments(String userID) async {
    try {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:3020/shipping/get-user-shipments/$userID'));
      if (response.statusCode == 200) {
        List<dynamic> shipmentDataList = jsonDecode(response.body);

        List<ShipmentModel> shipments = shipmentDataList
            .map((shipmentDataJson) => ShipmentModel.fromJson(shipmentDataJson))
            .toList();
        return shipments;
      } else {
        throw Exception('Failed to fetch user shipments');
      }
    } catch (e) {
      throw Exception('Failed to fetch user shipments: $e');
    }
  }
}
