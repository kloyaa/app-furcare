import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/data/models/appointment_models.dart';
import 'package:flutter_application_1/data/repositories/appointment_repository.dart';

enum AppointmentState {
  initial,
  loading,
  success,
  error,
  created,
  fetched,
  updated,
  deleted,
}

class AppointmentProvider with ChangeNotifier {
  final AppointmentRepository _appointmentRepository;

  AppointmentProvider({required AppointmentRepository appointmentRepository})
    : _appointmentRepository = appointmentRepository;

  AppointmentState _createApplicationState = AppointmentState.initial;

  String? _errorMessage;
  String? _errorCode;

  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  bool get isCreatingApplication =>
      _createApplicationState == AppointmentState.loading;

  Future<void> createGroomingAppointment(
    GroomingAppointmentRequest request,
  ) async {
    clearError();
    _setCreateGroomingAppointment(AppointmentState.loading);

    final result = await _appointmentRepository.createGroomingAppointment(
      request,
    );

    result.fold(
      (failure) {
        print('failure: $failure');
        _setCreateGroomingAppointment(AppointmentState.error);
        _handleFailure(failure);
      },
      (response) {
        print('response: $response');
        _setCreateGroomingAppointment(AppointmentState.created);
        // getPets();
      },
    );
  }

  void _setCreateGroomingAppointment(AppointmentState newState) {
    _createApplicationState = newState;
    notifyListeners();
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _errorCode = failure.code;
  }

  void clearError() {
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();
  }
}
