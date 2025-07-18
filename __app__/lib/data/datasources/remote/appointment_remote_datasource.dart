import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_application_1/core/errors/exceptions.dart';
import 'package:flutter_application_1/core/network/network_service.dart';
import 'package:flutter_application_1/data/datasources/remote/auth_header_provider.dart';
import 'package:flutter_application_1/data/models/appointment_models.dart';
import 'package:flutter_application_1/data/models/default_models.dart';

abstract class AppointmentRemoteDatasource {
  Future<DefaultResponse> createGroomingAppointment(
    GroomingAppointmentRequest request,
  );
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
}
