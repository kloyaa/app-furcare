// File: lib/data/datasources/remote/health_check_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:furcare_app/core/constants/api_constants.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/network/network_service.dart';
import 'package:furcare_app/data/models/health_check_models.dart';

abstract class HealthCheckRemoteDataSource {
  Future<HealthCheckResponse> getHealthStatus();
}

class HealthCheckRemoteDataSourceImpl implements HealthCheckRemoteDataSource {
  final NetworkService _networkService;

  HealthCheckRemoteDataSourceImpl({required NetworkService networkService})
    : _networkService = networkService;

  @override
  Future<HealthCheckResponse> getHealthStatus() async {
    try {
      final response = await _networkService.get(
        ApiConstants.host,
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      if (response.statusCode == 200) {
        return HealthCheckResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Health check failed',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'An error occurred during health check');
    }
  }
}
