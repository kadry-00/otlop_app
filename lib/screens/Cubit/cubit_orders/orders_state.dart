import 'package:otlop_1/models/order_model.dart';

abstract class OrdersState {}

class OrdersInitialState extends OrdersState {}

class OrdersLoadingState extends OrdersState {}

class OrdersSuccessState extends OrdersState {
  final List<OrderModel> orders;
  final List<DeliveryMethodModel> deliveryMethods;

  OrdersSuccessState({
    required this.orders,
    this.deliveryMethods = const [],
  });
}

class OrderCreatedSuccessState extends OrdersState {
  final OrderModel order;
  OrderCreatedSuccessState(this.order);
}

class OrdersFailureState extends OrdersState {
  final String error;
  OrdersFailureState(this.error);
}
