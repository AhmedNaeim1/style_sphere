import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/checkout_cubits/payment_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/checkout_cubits/shipment_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/data/repositories/checkout_repository/payment_repository.dart';
import 'package:style_sphere/data/repositories/checkout_repository/shipment_repository.dart';
import 'package:style_sphere/data/repositories/user_repository.dart';
import 'package:style_sphere/presentation/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => userCubit(repository: UserRepository())),
            BlocProvider(
                create: (context) =>
                    PaymentCubit(repository: PaymentRepository())),
            BlocProvider(
                create: (context) =>
                    ShippingCubit(repository: ShippingRepository())),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
            ),
            routes: AppRoutes.define(),
            onGenerateRoute: AppRoutes.generateRoute,
            initialRoute: AppRoutes.navbar,
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Home Page',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
