import 'package:otlop_1/models/product_model.dart';

abstract class ProductsState {}

class ProductsLoadingState extends ProductsState {}

class ProductsSuccessState extends ProductsState {
  final List<ProductModel> products;
  final int totalCount;
  final String? activeSearch;
  final int? activeBrandId;
  final int? activeCategoryId;

  ProductsSuccessState({
    required this.products,
    this.totalCount = 0,
    this.activeSearch,
    this.activeBrandId,
    this.activeCategoryId,
  });
}

class ProductsFailureState extends ProductsState {
  final String erro;
  ProductsFailureState({required this.erro});
}
