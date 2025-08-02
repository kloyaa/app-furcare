import 'package:dio/dio.dart';
import 'package:furcare_app/core/constants/api_constants.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/network/network_service.dart';
import 'package:furcare_app/data/datasources/remote/auth_header_provider.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';

abstract class PetServiceRemoteDataSource {
  Future<List<PetService>> getPetServices();
  Future<List<GroomingSchedule>> getGroomingSchedules();
  Future<List<GroomingOptions>> getGroomingOptions();
  Future<List<GroomingPreference>> getGroomingPreferences();
  Future<List<PetCage>> getPetCages();
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

  @override
  Future<List<GroomingSchedule>> getGroomingSchedules() async {
    try {
      final response = await _networkService.get(
        "${ApiConstants.petServices}/grooming-schedules",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => GroomingSchedule.fromJson(item)).toList();
      } else {
        throw ServerException(
          message:
              response.data?['message'] ?? 'Error fetching grooming schedules',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching grooming schedules',
      );
    }
  }

  @override
  Future<List<GroomingOptions>> getGroomingOptions() async {
    try {
      final response = await _networkService.get(
        "${ApiConstants.petServices}/grooming-options",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => GroomingOptions.fromJson(item)).toList();
      } else {
        throw ServerException(
          message:
              response.data?['message'] ?? 'Error fetching grooming options',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching grooming options',
      );
    }
  }

  @override
  Future<List<GroomingPreference>> getGroomingPreferences() async {
    try {
      final response = await _networkService.get(
        "${ApiConstants.petServices}/grooming-preferences",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => GroomingPreference.fromJson(item)).toList();
      } else {
        throw ServerException(
          message:
              response.data?['message'] ??
              'Error fetching grooming preferences',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching grooming preferences',
      );
    }
  }

  @override
  Future<List<PetCage>> getPetCages() async {
    try {
      final response = await _networkService.get(
        "${ApiConstants.petServices}/cages",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => PetCage.fromJson(item)).toList();
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching pet cages',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching pet cages',
      );
    }
  }
}
