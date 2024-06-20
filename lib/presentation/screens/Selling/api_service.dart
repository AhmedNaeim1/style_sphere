import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080',
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<void> uploadProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _dio.post('/products', data: productData);
      print('Product uploaded: ${response.data}');
    } catch (e) {
      print('Error uploading product: $e');
    }
  }

  Future<void> uploadImages(List<String> imagePaths) async {
    try {
      List<MultipartFile> imageFiles = [];
      for (var path in imagePaths) {
        imageFiles.add(await MultipartFile.fromFile(path));
      }

      FormData formData = FormData.fromMap({
        'images': imageFiles,
      });

      final response = await _dio.post('/upload', data: formData);
      print('Images uploaded: ${response.data}');
    } catch (e) {
      print('Error uploading images: $e');
    }
  }
}
