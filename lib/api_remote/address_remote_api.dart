import 'package:dio/dio.dart';
import 'package:otlop_1/api_remote/api_client.dart';
import 'package:otlop_1/api_remote/api_error_handler.dart';
import 'package:otlop_1/models/address_model.dart';

class AddressRemoteApi {
  final Dio dio = ApiClient.dio;

  Future<AddressModel?> getAddress() async {
    try {
      final response = await dio.get("/api/Account/Address");
      if (response.data == null) return null;
      return AddressModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<AddressModel> updateAddress(AddressModel address) async {
    try {
      final response = await dio.put(
        "/api/Account/Address",
        data: address.toJson(),
      );
      return AddressModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
