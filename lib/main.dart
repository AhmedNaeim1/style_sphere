import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/business_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/cart_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/checkout_cubits/payment_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/checkout_cubits/shipment_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/product_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/data/repositories/business_repository.dart';
import 'package:style_sphere/data/repositories/cart_repository.dart';
import 'package:style_sphere/data/repositories/checkout_repository/payment_repository.dart';
import 'package:style_sphere/data/repositories/checkout_repository/shipment_repository.dart';
import 'package:style_sphere/data/repositories/product_repository.dart';
import 'package:style_sphere/data/repositories/user_repository.dart';
import 'package:style_sphere/presentation/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => userCubit(repository: UserRepository()),
            ),
            BlocProvider(
              create: (context) =>
                  PaymentCubit(repository: PaymentRepository()),
            ),
            BlocProvider(
              create: (context) =>
                  ShippingCubit(repository: ShippingRepository()),
            ),
            BlocProvider(
              create: (context) =>
                  BusinessCubit(repository: BusinessRepository()),
            ),
            BlocProvider(
              create: (context) =>
                  ProductCubit(repository: ProductRepository()),
            ),
            BlocProvider(
              create: (context) => CartCubit(repository: CartRepository()),
            ),
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
              initialRoute: AppRoutes.splashScreen),
        );
      },
    );
  }
}
