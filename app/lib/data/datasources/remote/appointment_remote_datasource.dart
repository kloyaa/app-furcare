import 'package:dio/dio.dart';
import 'package:furcare_app/core/constants/api_constants.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/network/network_service.dart';
import 'package:furcare_app/data/datasources/remote/auth_header_provider.dart';
import 'package:furcare_app/data/models/appointment_models.dart';
import 'package:furcare_app/data/models/default_models.dart';

abstract class AppointmentRemoteDatasource {
  Future<DefaultResponse> createGroomingAppointment(
    GroomingAppointmentRequest request,
  );

  Future<DefaultResponse> createBoardingAppointment(
    BoardingAppointmentRequest request,
  );

  Future<DefaultResponse> createBoardingAppointmentExtension(
    AppointmentExtensionRequest request,
  );

  Future<List<GroomingAppointment>> getGroomingAppointments();
  Future<List<BoardingAppointment>> getBoardingAppointments();
}

class AppointmentRemoteDatasourceImpl implements AppointmentRemoteDatasource {
  final NetworkService _networkService;
  final AuthHeaderProvider _authHeaderProvider;

  AppointmentRemoteDatasourceImpl({
    required NetworkService networkService,
    required AuthHeaderProvider authHeaderProvider,
  }) : _networkService = networkService,
       _authHeaderProvider = authHeaderProvider;

  @override
  Future<DefaultResponse> createGroomingAppointment(
    GroomingAppointmentRequest request,
  ) async {
    try {
      final response = await _networkService.post(
        data: request.toJson(),
        "${ApiConstants.appointment}/grooming",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 201) {
        return DefaultResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error creating appointment',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during creating appointment',
      );
    }
  }

  @override
  Future<List<GroomingAppointment>> getGroomingAppointments() async {
    try {
      final response = await _networkService.get(
        "${ApiConstants.appointment}/grooming",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => GroomingAppointment.fromJson(item)).toList();
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching appointments',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching appointments',
      );
    }
  }

  @override
  Future<List<BoardingAppointment>> getBoardingAppointments() async {
    try {
      final response = await _networkService.get(
        "${ApiConstants.appointment}/boarding",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => BoardingAppointment.fromJson(item)).toList();
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching appointments',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching appointments',
      );
    }
  }

  @override
  Future<DefaultResponse> createBoardingAppointment(
    BoardingAppointmentRequest request,
  ) async {
    try {
      final response = await _networkService.post(
        data: request.toJson(),
        "${ApiConstants.appointment}/boarding",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );
      if (response.statusCode == 201) {
        return DefaultResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error creating appointment',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during creating appointment',
      );
    }
  }

  @override
  Future<DefaultResponse> createBoardingAppointmentExtension(
    AppointmentExtensionRequest request,
  ) async {
    try {
      final response = await _networkService.post(
        data: request.toJson(),
        "${ApiConstants.appointment}/boarding/extension",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );
      if (response.statusCode == 200) {
        return DefaultResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message:
              response.data?['message'] ??
              'Error creating appointment extension',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during creating appointment extension',
      );
    }
  }
}
