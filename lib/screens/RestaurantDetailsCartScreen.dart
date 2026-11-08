import 'package:flutter/material.dart';
import 'package:otlop_1/models/brand_model.dart';
import 'package:otlop_1/models/restaurant_model.dart';
import 'package:otlop_1/screens/RestaurantDetailsScreen.dart';

class clsRestaurantDetailsCartScreen extends StatelessWidget {
  final BrandModel brand;
  final RestaurantModel? restaurant;

  const clsRestaurantDetailsCartScreen({
    super.key,
    required this.brand,
    this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return clsRestaurantDetailsScreen(
      brand: brand,
      restaurant: restaurant,
      showCartBar: true,
    );
  }
}
