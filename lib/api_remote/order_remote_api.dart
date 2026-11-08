import 'package:dio/dio.dart';
import 'package:otlop_1/api_remote/api_client.dart';
import 'package:otlop_1/api_remote/api_error_handler.dart';
import 'package:otlop_1/models/address_model.dart';
import 'package:otlop_1/models/order_model.dart';

class OrderRemoteApi {
  final Dio dio = ApiClient.dio;

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await dio.get("/api/Orders");
      final list = (response.data as List)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<OrderModel> getOrderById(int orderId) async {
    try {
      final response = await dio.get("/api/Orders/$orderId");
      return OrderModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<List<DeliveryMethodModel>> getDeliveryMethods() async {
    try {
      final response = await dio.get("/api/Orders/DeliverMethods");
      final list = (response.data as List)
          .map((e) => DeliveryMethodModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<OrderModel> createOrder({
    required int deliveryMethodId,
    required AddressModel shippingAddress,
  }) async {
    try {
      final response = await dio.post(
        "/api/Orders",
        data: {
          "deliverMethodID": deliveryMethodId,
          "shippingAddress": shippingAddress.toJson(),
        },
      );
      return OrderModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
