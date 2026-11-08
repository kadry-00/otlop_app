import 'package:dio/dio.dart';

class AuthSession {
  static String? token;
  static String? displayName;
  static String? email;

  static bool get isLoggedIn => token != null && token!.isNotEmpty;

  static void clear() {
    token = null;
    displayName = null;
    email = null;
  }
}

class ApiClient {
  static const String baseUrl = "https://talabat639.runasp.net";

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static Dio get dio {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (AuthSession.token != null && AuthSession.token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${AuthSession.token}';
          }
          return handler.next(options);
        },
      ),
    );
    return _dio;
  }
}
