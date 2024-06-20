import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';

class ResultScreen extends StatefulWidget {
  final String imageUrl;

  const ResultScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Future<http.Response> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = fetchImage();
  }

  Future<http.Response> fetchImage() async {
    return http.get(Uri.parse(widget.imageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Item Tried On", context, 12.sp),
      body: FutureBuilder<http.Response>(
        future: _imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading image'),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
