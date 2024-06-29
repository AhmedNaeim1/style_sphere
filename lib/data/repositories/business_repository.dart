import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:style_sphere/data/models/business_data.dart';

class BusinessRepository {
  BusinessRepository();

  final String baseUrl = 'https://127.0.0.1:3020/business';

  Future<List<BusinessModel>> getAllBusinesses() async {
    final response = await http.get(Uri.parse('$baseUrl/allBusinesses'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((business) => BusinessModel.fromJson(business))
          .toList();
    } else {
      throw Exception('Failed to load businesses');
    }
  }

  Future<BusinessModel?> getBusiness(String id) async {
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final response = await httpClient
        .getUrl(Uri.parse('$baseUrl/$id'))
        .then((request) => request.close());

    if (response.statusCode == 200) {
      String responseBody = await utf8.decoder.bind(response).join();
      Map<String, dynamic> jsonMap = json.decode(responseBody);
      return BusinessModel.fromJson(jsonMap);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load business');
    }
  }

  Future<String> createBusiness(BusinessModel business) async {
    final response = await http.post(
      Uri.parse('$baseUrl/createBusiness'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(business.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Successfully created.';
    } else if (response.statusCode == 409) {
      return 'Business already exists.';
    } else {
      throw Exception('Failed to create business');
    }
  }

  Future<String> updateBusiness(String id, BusinessModel business) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateBusiness/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(business.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Successfully updated.';
    } else if (response.statusCode == 404) {
      return 'Business not found.';
    } else {
      throw Exception('Failed to update business');
    }
  }

  Future<String> deleteBusiness(String id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/deleteBusiness/$id'));
    if (response.statusCode == 200) {
      return 'Successfully deleted.';
    } else if (response.statusCode == 404) {
      return 'Business not found.';
    } else {
      throw Exception('Failed to delete business');
    }
  }
}
