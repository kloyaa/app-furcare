import 'package:dio/dio.dart';
import 'package:furcare_app/core/constants/api_constants.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/network/network_service.dart';
import 'package:furcare_app/data/datasources/remote/auth_header_provider.dart';
import 'package:furcare_app/data/models/default_models.dart';
import 'package:furcare_app/data/models/pet_models.dart';

abstract class PetRemoteDataSource {
  Future<List<Pet>> getPets();
  Future<Pet> createPet(RequestPet pet);
  Future<Pet> updatePet(UpdatePet pet);
  Future<DefaultResponse> deletePet(String id);
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final NetworkService _networkService;
  final AuthHeaderProvider _authHeaderProvider;

  PetRemoteDataSourceImpl({
    required NetworkService networkService,
    required AuthHeaderProvider authHeaderProvider,
  }) : _networkService = networkService,
       _authHeaderProvider = authHeaderProvider;

  @override
  Future<List<Pet>> getPets() async {
    try {
      final response = await _networkService.get(
        ApiConstants.pets,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => Pet.fromJson(item)).toList();
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching pets',
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

  @override
  Future<Pet> createPet(RequestPet pet) async {
    try {
      final response = await _networkService.post(
        data: pet.toJson(),
        ApiConstants.pets,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 201) {
        return Pet.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error creating pet',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'An error occurred during creating pet');
    }
  }

  @override
  Future<Pet> updatePet(UpdatePet pet) async {
    try {
      final response = await _networkService.put(
        data: pet.toJson(),
        '${ApiConstants.pets}/${pet.id}',
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return Pet.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error updating pet',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'An error occurred during updating pet');
    }
  }

  @override
  Future<DefaultResponse> deletePet(String id) async {
    try {
      final response = await _networkService.delete(
        '${ApiConstants.pets}/$id',
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return DefaultResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error deleting pet',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'An error occurred during deleting pet');
    }
  }
}
