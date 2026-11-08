import 'package:otlop_1/models/basket_model.dart';

abstract class BasketState {}

class BasketInitialState extends BasketState {}

class BasketLoadingState extends BasketState {}

class BasketSuccessState extends BasketState {
  final CustomerBasketModel basket;
  BasketSuccessState(this.basket);
}

class BasketFailureState extends BasketState {
  final String error;
  BasketFailureState(this.error);
}
