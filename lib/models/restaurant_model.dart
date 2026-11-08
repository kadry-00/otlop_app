import 'package:otlop_1/models/brand_model.dart';

class RestaurantModel {
  final int id;
  final String name;
  final String? logoUrl;
  final String? coverUrl;
  final double rating;
  final int ratingCount;
  final String deliveryTime;
  final double deliveryFee;
  final String categoryTag;
  final bool isFeatured;

  RestaurantModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.coverUrl,
    this.rating = 4.8,
    this.ratingCount = 120,
    this.deliveryTime = "25 - 35 mins",
    this.deliveryFee = 15.0,
    this.categoryTag = "Fast Food & Drinks",
    this.isFeatured = true,
  });

  factory RestaurantModel.fromBrand(BrandModel brand) {
    // Generate attractive defaults for restaurants based on brands
    return RestaurantModel(
      id: brand.id,
      name: brand.name,
      rating: 4.7 + ((brand.id % 4) * 0.1),
      ratingCount: 150 + (brand.id * 35),
      deliveryTime: "${20 + (brand.id % 3) * 5} - ${35 + (brand.id % 3) * 5} mins",
      deliveryFee: (15 + (brand.id % 3) * 5).toDouble(),
      categoryTag: _getCategoryForBrand(brand.name),
    );
  }

  static String _getCategoryForBrand(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('starbucks') || lower.contains('coffee') || lower.contains('costa')) {
      return "Coffee & Beverages";
    }
    if (lower.contains('cinnabon') || lower.contains('donut') || lower.contains('bakery')) {
      return "Desserts & Bakery";
    }
    if (lower.contains('burger') || lower.contains('mcdonald')) {
      return "Burgers & Sandwiches";
    }
    if (lower.contains('pizza')) {
      return "Pizza & Italian";
    }
    return "Food & Dining";
  }
}
