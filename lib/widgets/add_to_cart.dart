import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/screens/Cubit/cubit_basket/basket_cubit.dart';

Future<void> addToCart(
  BuildContext context,
  int productId, {
  int quantity = 1,
}) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  try {
    await context.read<BasketCubit>().addToBasket(
          productId: productId,
          quantity: quantity,
        );
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text("Added to basket successfully!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text("Error adding to cart: $e"),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
