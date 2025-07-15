import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_application_1/core/errors/exceptions.dart';
import 'package:flutter_application_1/core/network/network_service.dart';
import 'package:flutter_application_1/data/datasources/remote/auth_header_provider.dart';
import 'package:flutter_application_1/data/models/pet_service.models.dart';

abstract class PetServiceRemoteDataSource {
  Future<List<PetService>> getPetServices();
}

class PetServiceRemoteDataSourceImpl implements PetServiceRemoteDataSource {
  final NetworkService _networkService;
  final AuthHeaderProvider _authHeaderProvider;

  PetServiceRemoteDataSourceImpl({
    required NetworkService networkService,
    required AuthHeaderProvider authHeaderProvider,
  }) : _networkService = networkService,
       _authHeaderProvider = authHeaderProvider;

  @override
  Future<List<PetService>> getPetServices() async {
    try {
      final response = await _networkService.get(
        ApiConstants.petServices,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => PetService.fromJson(item)).toList();
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching pet services',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching pet services',
      );
    }
  }
}
