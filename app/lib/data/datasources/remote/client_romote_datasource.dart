import 'package:dio/dio.dart';
import 'package:furcare_app/core/constants/api_constants.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/network/network_service.dart';
import 'package:furcare_app/data/datasources/remote/auth_header_provider.dart';
import 'package:furcare_app/data/models/client_models.dart';

abstract class ClientRemoteDataSource {
  Future<Client> getProfile();
  Future<Client> createProfile(ClientRequest request);
  Future<Client> updateProfile(ClientRequest request);
}

class ClientRemoteDataSourceImpl implements ClientRemoteDataSource {
  final NetworkService _networkService;
  final AuthHeaderProvider _authHeaderProvider;

  ClientRemoteDataSourceImpl({
    required NetworkService networkService,
    required AuthHeaderProvider authHeaderProvider,
  }) : _networkService = networkService,
       _authHeaderProvider = authHeaderProvider;

  @override
  Future<Client> getProfile() async {
    try {
      final response = await _networkService.get(
        ApiConstants.clientProfile,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return Client.fromJson(response.data);
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
  Future<Client> createProfile(ClientRequest request) async {
    try {
      final response = await _networkService.post(
        ApiConstants.clientProfile,
        data: request,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 201) {
        return Client.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Profile creation failed',
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
  Future<Client> updateProfile(ClientRequest request) async {
    try {
      final response = await _networkService.put(
        ApiConstants.clientProfile,
        data: request,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return Client.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Profile creation failed',
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
}
