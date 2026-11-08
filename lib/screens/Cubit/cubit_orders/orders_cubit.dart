import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_1/api_remote/order_remote_api.dart';
import 'package:otlop_1/models/address_model.dart';
import 'package:otlop_1/models/order_model.dart';
import 'package:otlop_1/screens/Cubit/cubit_orders/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRemoteApi _orderApi = OrderRemoteApi();

  OrdersCubit() : super(OrdersInitialState());

  List<OrderModel> _cachedOrders = [];
  List<DeliveryMethodModel> _deliveryMethods = [];

  List<OrderModel> get cachedOrders => _cachedOrders;
  List<DeliveryMethodModel> get deliveryMethods => _deliveryMethods;

  Future<void> fetchOrders() async {
    emit(OrdersLoadingState());
    try {
      final orders = await _orderApi.getOrders();
      _cachedOrders = orders;
      if (_deliveryMethods.isEmpty) {
        _deliveryMethods = await _orderApi.getDeliveryMethods();
      }
      emit(OrdersSuccessState(
        orders: _cachedOrders,
        deliveryMethods: _deliveryMethods,
      ));
    } catch (e) {
      emit(OrdersFailureState(e.toString()));
    }
  }

  Future<void> fetchDeliveryMethods() async {
    try {
      _deliveryMethods = await _orderApi.getDeliveryMethods();
      if (state is OrdersSuccessState) {
        emit(OrdersSuccessState(
          orders: _cachedOrders,
          deliveryMethods: _deliveryMethods,
        ));
      }
    } catch (_) {}
  }

  Future<void> createOrder({
    required int deliveryMethodId,
    required AddressModel shippingAddress,
  }) async {
    emit(OrdersLoadingState());
    try {
      final order = await _orderApi.createOrder(
        deliveryMethodId: deliveryMethodId,
        shippingAddress: shippingAddress,
      );
      _cachedOrders.insert(0, order);
      emit(OrderCreatedSuccessState(order));
      emit(OrdersSuccessState(
        orders: _cachedOrders,
        deliveryMethods: _deliveryMethods,
      ));
    } catch (e) {
      emit(OrdersFailureState(e.toString()));
      rethrow;
    }
  }
}
