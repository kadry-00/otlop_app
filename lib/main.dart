import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/screens/Cubit/cubit_basket/basket_cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_orders/orders_cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Brands_Cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Categoris_Cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_products/Products_Cubit.dart';
import 'package:otlop_1/screens/Cubit/cubit_profile/profile_cubit.dart';
import 'package:otlop_1/screens/auth/LoginScreesn.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const OtlopApp());
}

class OtlopApp extends StatelessWidget {
  const OtlopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsCubit>(
          create: (BuildContext context) => ProductsCubit(),
        ),
        BlocProvider<CategorisCubit>(
          create: (BuildContext context) => CategorisCubit(),
        ),
        BlocProvider<BrandsCubit>(
          create: (BuildContext context) => BrandsCubit(),
        ),
        BlocProvider<BasketCubit>(
          create: (BuildContext context) => BasketCubit(),
        ),
        BlocProvider<OrdersCubit>(
          create: (BuildContext context) => OrdersCubit(),
        ),
        BlocProvider<ProfileCubit>(
          create: (BuildContext context) => ProfileCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'otlop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(255, 92, 57, 1),
            primary: const Color.fromRGBO(255, 92, 57, 1),
          ),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: const CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: const ZoomPageTransitionsBuilder(),
              TargetPlatform.linux: const ZoomPageTransitionsBuilder(),
              TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        home: const clsLoginScreen(),
      ),
    );
  }
}
