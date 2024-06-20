import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  final Stream<double> progressStream;

  const LoadingScreen({Key? key, required this.progressStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Doing The Magic For You....',
              style: TextStyle(
                fontFamily: "Gabarito",
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            StreamBuilder<double>(
              stream: progressStream,
              builder: (context, snapshot) {
                double progress = snapshot.data ?? 0.0;
                return const SpinKitCubeGrid(
                  color: Color(0xff0FAABC), // Change color as needed
                  size: 80.0,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
