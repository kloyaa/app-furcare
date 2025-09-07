import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:furcare_app/core/constants/api_constants.dart';
import 'package:furcare_app/core/errors/exceptions.dart';

class NetworkService {
  late final Dio _dio;
  static NetworkService? _instance;

  NetworkService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    _setupInterceptors();
  }

  factory NetworkService() {
    _instance ??= NetworkService._internal();
    return _instance!;
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add default headers if not already present
          options.headers.addAll(ApiConstants.defaultHeaders);

          // Log request
          if (kDebugMode) {
            // print('REQUEST[${options.method}] => PATH: ${options.path}');
            // print('Headers: ${options.headers}');
          }
          if (options.data != null) {
            // print('Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response
          // print(
          //   'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          // );
          // print('Data: ${response.data}');

          return handler.next(response);
        },
        onError: (error, handler) {
          // Log error
          // print(
          //   'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          // );
          // print('Message: ${error.message}');

          return handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) {},
      ),
    );
  }

  // Add custom headers for specific requests
  void addHeaders(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  // Remove specific headers
  void removeHeaders(List<String> keys) {
    for (String key in keys) {
      _dio.options.headers.remove(key);
    }
  }

  // Clear all headers
  void clearHeaders() {
    _dio.options.headers.clear();
  }

  // Update authorization header
  void updateAuthToken(String token) {
    _dio.options.headers[ApiConstants.authorization] = 'Bearer $token';
  }

  // Remove authorization header
  void removeAuthToken() {
    _dio.options.headers.remove(ApiConstants.authorization);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Server error occurred';
        final code = e.response?.data?['code'];

        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return ServerException(message: message, code: code);
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(message: message);
        }

        return ServerException(message: message, code: code);

      case DioExceptionType.cancel:
        return NetworkException(message: 'Request was cancelled');

      case DioExceptionType.unknown:
        if (e.error.toString().contains('SocketException')) {
          return NetworkException(message: 'No internet connection');
        }
        return NetworkException(message: 'An unexpected error occurred');

      default:
        return NetworkException(message: 'An unexpected error occurred');
    }
  }
}
