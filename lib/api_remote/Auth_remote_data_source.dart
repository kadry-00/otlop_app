import 'package:dio/dio.dart';
import 'package:otlop_1/api_remote/api_client.dart';
import 'package:otlop_1/api_remote/api_error_handler.dart';
import 'package:otlop_1/models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio = ApiClient.dio;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        "/api/Account/Login",
        data: {
          "email": email.trim(),
          "password": password,
        },
      );

      final user = UserModel.fromJson(response.data as Map<String, dynamic>);
      AuthSession.token = user.token;
      AuthSession.displayName = user.displayName;
      AuthSession.email = user.email;
      return user;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        "/api/Account/Register",
        data: {
          "displayName": name.trim(),
          "email": email.trim(),
          "password": password,
          "phoneNumber": phone.trim(),
        },
      );

      final user = UserModel.fromJson(response.data as Map<String, dynamic>);
      AuthSession.token = user.token;
      AuthSession.displayName = user.displayName;
      AuthSession.email = user.email;
      return user;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get("/api/Account");
      final user = UserModel.fromJson(response.data as Map<String, dynamic>);
      AuthSession.displayName = user.displayName;
      AuthSession.email = user.email;
      return user;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
