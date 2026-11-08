import 'package:otlop_1/models/brand_model.dart';

abstract class BrandsState {}

class BrandsLoadingState extends BrandsState {}

class BrandsSuccessState extends BrandsState {
  final List<BrandModel> brands;
  BrandsSuccessState({required this.brands});
}

class BrandsFailureState extends BrandsState {
  final String erro;
  BrandsFailureState({required this.erro});
}
