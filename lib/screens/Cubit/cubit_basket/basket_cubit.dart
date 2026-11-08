import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/api_remote/Basket_remote_api.dart';
import 'package:otlop_1/models/basket_model.dart';
import 'package:otlop_1/screens/Cubit/cubit_basket/basket_state.dart';

class BasketCubit extends Cubit<BasketState> {
  final BasketRemoteApi _basketApi = BasketRemoteApi();

  BasketCubit() : super(BasketInitialState());

  CustomerBasketModel? _lastBasket;
  CustomerBasketModel? get currentBasket => _lastBasket;

  Future<void> fetchBasket() async {
    emit(BasketLoadingState());
    try {
      final basket = await _basketApi.getBasket();
      _lastBasket = basket;
      emit(BasketSuccessState(basket));
    } catch (e) {
      emit(BasketFailureState(e.toString()));
    }
  }

  Future<void> addToBasket({required int productId, int quantity = 1}) async {
    try {
      _lastBasket ??= await _basketApi.getBasket();
      final current = _lastBasket!.items
          .where((item) => item.id == productId)
          .fold<int>(0, (sum, item) => sum + item.quantity);
      final nextQuantity = current + quantity;

      if (nextQuantity < 1) {
        final others =
            _lastBasket!.items.where((item) => item.id != productId).toList();
        if (others.isNotEmpty) {
          emit(BasketSuccessState(_lastBasket!));
          throw "This item stays at 1. The server can only clear the whole cart.";
        }
        await clearBasket();
        return;
      }

      emit(BasketLoadingState());
      // POST /api/Basket stores this quantity. It does not add to the old one.
      final basket = await _basketApi.addToBasket(
        productId: productId,
        quantity: nextQuantity,
      );
      _lastBasket = basket;
      emit(BasketSuccessState(basket));
    } catch (e) {
      if (_lastBasket != null) {
        emit(BasketSuccessState(_lastBasket!));
      } else {
        emit(BasketFailureState(e.toString()));
      }
      rethrow;
    }
  }

  Future<void> clearBasket() async {
    emit(BasketLoadingState());
    try {
      await _basketApi.clearBasket();
      _lastBasket = CustomerBasketModel(items: []);
      emit(BasketSuccessState(_lastBasket!));
    } catch (e) {
      emit(BasketFailureState(e.toString()));
    }
  }
}
