import 'package:dio/dio.dart';
import 'package:otlop_1/api_remote/api_client.dart';
import 'package:otlop_1/api_remote/api_error_handler.dart';
import 'package:otlop_1/models/basket_model.dart';

class BasketRemoteApi {
  final Dio dio = ApiClient.dio;

  Future<CustomerBasketModel> getBasket() async {
    try {
      final response = await dio.get("/api/Basket");
      if (response.data is! Map<String, dynamic>) {
        return CustomerBasketModel(items: []);
      }
      return CustomerBasketModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      final bodyStatus = data is Map ? data['statusCode'] : null;
      final status = e.response?.statusCode;
      if (bodyStatus == 401 || status == 401) {
        throw ApiErrorHandler.handle(e);
      }
      // A new account has no basket yet, and the API answers with 500.
      if (status == 404 || status == 500) {
        return CustomerBasketModel(items: []);
      }
      throw ApiErrorHandler.handle(e);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<CustomerBasketModel> addToBasket({
    required int productId,
    required int quantity,
  }) async {
    try {
      final response = await dio.post(
        "/api/Basket",
        data: {
          "productId": productId,
          "quantity": quantity,
        },
      );
      return CustomerBasketModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> clearBasket() async {
    try {
      await dio.delete("/api/Basket");
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 404 || status == 500) return;
      throw ApiErrorHandler.handle(e);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}

// Backward compatibility alias
typedef clsBasketRemoteApi = BasketRemoteApi;
