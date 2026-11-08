import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timeout. Please check your internet connection.";
        case DioExceptionType.sendTimeout:
          return "Send timeout in connection with server.";
        case DioExceptionType.receiveTimeout:
          return "Receive timeout in connection with server.";
        case DioExceptionType.badCertificate:
          return "Bad SSL certificate detected.";
        case DioExceptionType.badResponse:
          return _handleResponseError(error.response);
        case DioExceptionType.cancel:
          return "Request to server was cancelled.";
        case DioExceptionType.connectionError:
          return "No internet connection or server is unreachable.";
        case DioExceptionType.unknown:
        default:
          return error.message ?? "Unexpected network error occurred. Please try again.";
      }
    }
    return error.toString();
  }

  static String _handleResponseError(Response? response) {
    if (response == null) return "Unknown server response error.";
    final statusCode = response.statusCode;
    final data = response.data;

    if (data is Map) {
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        return errors.map((e) => e.toString()).join("\n");
      }
      if (errors is Map && errors.isNotEmpty) {
        final errorMessages = errors.values.expand((element) {
          if (element is List) return element.map((e) => e.toString());
          return [element.toString()];
        }).toList();
        if (errorMessages.isNotEmpty) return errorMessages.join("\n");
      }
      if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
        return data['message'].toString();
      }
    }

    switch (statusCode) {
      case 400:
        return "Bad request. Please verify your inputs.";
      case 401:
        return "Unauthorized. Please log in again.";
      case 403:
        return "Forbidden access.";
      case 404:
        return "Requested resource not found.";
      case 500:
        return "Internal server error. Please try again later.";
      case 503:
        return "Service temporarily unavailable.";
      default:
        return "Server error ($statusCode). Please try again.";
    }
  }
}
