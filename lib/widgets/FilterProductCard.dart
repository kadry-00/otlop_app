import 'package:flutter/material.dart';
import 'package:otlop_1/models/product_model.dart';
import 'package:otlop_1/widgets/ProductContainer.dart';

class clsFilterProductCard extends StatelessWidget {
  final ProductModel product;

  const clsFilterProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return clsProductCard(product: product);
  }
}
