import 'package:otlop_1/models/category_model.dart';

abstract class CategorisState {}

class CategorisLoadingState extends CategorisState {}

class CategorisSuccessState extends CategorisState {
  final List<CategoryModel> categoris;
  CategorisSuccessState({required this.categoris});
}

class CategrisFailureState extends CategorisState {
  final String erro;
  CategrisFailureState({required this.erro});
}
