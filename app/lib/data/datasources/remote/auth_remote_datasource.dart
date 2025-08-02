import 'package:dio/dio.dart';
import 'package:furcare_app/core/constants/api_constants.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/network/network_service.dart';
import 'package:furcare_app/data/datasources/remote/auth_header_provider.dart';
import 'package:furcare_app/data/models/auth_models.dart';
import 'package:furcare_app/data/models/default_models.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<DefaultResponse> changePassword(ChangePasswordRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkService _networkService;
  final AuthHeaderProvider _authHeaderProvider;

  AuthRemoteDataSourceImpl({
    required NetworkService networkService,
    required AuthHeaderProvider authHeaderProvider,
  }) : _networkService = networkService,
       _authHeaderProvider = authHeaderProvider;

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _networkService.post(
        ApiConstants.login,
        data: request.toJson(),
        options: Options(headers: ApiConstants.defaultHeaders),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Login failed',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'An error occurred during login');
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _networkService.post(
        ApiConstants.register,
        data: request.toJson(),
        options: Options(headers: ApiConstants.registerHeaders),
      );

      if (response.statusCode == 201) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Registration failed',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'An error occurred during registration');
    }
  }

  @override
  Future<DefaultResponse> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await _networkService.post(
        ApiConstants.changePassword,
        data: request.toJson(),
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return DefaultResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Change password failed',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during change password',
      );
    }
  }
}
