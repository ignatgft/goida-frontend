import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'endpoints.dart';

class ApiClient {
  late final Dio dio;
  String? _sessionToken;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        connectTimeout: const Duration(seconds: 10),
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint("--- API Request: ${options.method} ${options.uri} ---");
          debugPrint("baseUrl: ${Endpoints.baseUrl}");
          debugPrint("path: ${options.path}");
          debugPrint("Headers: ${options.headers}");
          debugPrint("Data: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint("--- API Response: ${response.statusCode} ---");
          debugPrint("Response Body: ${response.data}");
          return handler.next(response);
        },
        onError: (e, handler) {
          debugPrint("--- API Error: ${e.response?.statusCode} ${e.message} ---");
          debugPrint("Error Response Body: ${e.response?.data}");
          return handler.next(e);
        },
      ));
    }
  }

  String? get sessionToken => _sessionToken;

  void setSessionToken(String? token) {
    _sessionToken = token;
    if (token == null || token.isEmpty) {
      dio.options.headers.remove('Authorization');
    } else {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get(path, queryParameters: queryParameters);
  }
  
  Future<Response> post(
    String path,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(
    String path,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.delete(path, queryParameters: queryParameters);
  }
}
  