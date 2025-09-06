import 'package:flutter/foundation.dart';
import 'package:furcare_app/core/enums/application.dart';
import 'package:furcare_app/data/models/__staff/appointment_request.dart';
import 'package:furcare_app/data/models/__staff/appointments_model.dart';
import 'package:furcare_app/data/repositories/appointment_repository.dart';

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

class StaffAppointmentProvider with ChangeNotifier {
  final AppointmentRepository _appointmentRepository;

  StaffAppointmentProvider({
    required AppointmentRepository appointmentRepository,
  }) : _appointmentRepository = appointmentRepository;

  // States
  AppointmentState _fetchAppointmentsState = AppointmentState.initial;
  AppointmentState _isRefetching = AppointmentState.initial;
  AppointmentState _isFetchingNewAppointments = AppointmentState.initial;
  AppointmentState _isUpdatingAppointmentStatus = AppointmentState.initial;

  String? _errorMessage;
  String? _errorMessageUpdate;

  String? _errorCode;
  CustomerAppointments? _customerAppointments;
  ApplicationStatus _currentStatus = ApplicationStatus.pending;

  // Getters
  AppointmentState get fetchAppointmentsState => _fetchAppointmentsState;
  bool get isFetchingAppointments =>
      _fetchAppointmentsState == AppointmentState.loading;

  bool get isRefetching => _isRefetching == AppointmentState.loading;

  bool get isFetchingNewAppointments =>
      _isFetchingNewAppointments == AppointmentState.loading;

  bool get isUpdatingAppointmentStatus =>
      _isUpdatingAppointmentStatus == AppointmentState.loading;

  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  String? get errorMessageUpdate => _errorMessageUpdate;

  CustomerAppointments? get customerAppointments => _customerAppointments;
  ApplicationStatus get currentStatus => _currentStatus;

  // Main method to fetch customer appointments with status filter
  Future<void> getCustomerAppointments({ApplicationStatus? status}) async {
    _setFetchAppointmentsState(AppointmentState.loading);

    if (status != null) {
      _currentStatus = status;
    }

    final result = await _appointmentRepository.fetchNewAppointmentsByStatus(
      _currentStatus,
    );

    result.fold(
      (failure) {
        _setFetchAppointmentsState(AppointmentState.error);
        _errorMessage = failure.message;
        _errorCode = failure.code;
      },
      (response) {
        _setFetchAppointmentsState(AppointmentState.fetched);
        _customerAppointments = response;
        _clearError();
      },
    );
  }

  // Change status and fetch appointments
  Future<void> updateAppointmentStatus(
    AppointmentStatusUpdateRequest request,
  ) async {
    _setUpdateAppointmentStatus(AppointmentState.loading);
    final result = await _appointmentRepository.updateAppointmentStatus(
      request,
    );

    result.fold(
      (failure) {
        _setUpdateAppointmentStatus(AppointmentState.error);
        _errorMessageUpdate = failure.message;
        _errorCode = failure.code;
      },
      (response) {
        fetchNewAppointmentsByStatus(_currentStatus);
        _clearError();
        _setUpdateAppointmentStatus(AppointmentState.success);
      },
    );
  }

  Future<void> fetchNewAppointmentsByStatus(ApplicationStatus newStatus) async {
    _currentStatus = newStatus;
    _setFetchNewAppointmentsByStatus(AppointmentState.loading);

    final result = await _appointmentRepository.fetchNewAppointmentsByStatus(
      _currentStatus,
    );

    result.fold(
      (failure) {
        _setFetchNewAppointmentsByStatus(AppointmentState.error);
        _errorMessage = failure.message;
        _errorCode = failure.code;
      },
      (response) {
        _setFetchNewAppointmentsByStatus(AppointmentState.fetched);
        _customerAppointments = response;
        _clearError();
      },
    );
  }

  // Refresh appointments with current status
  Future<void> refreshAppointments() async {
    _setRefetchAppointmentsState(AppointmentState.loading);

    final result = await _appointmentRepository.fetchNewAppointmentsByStatus(
      _currentStatus,
    );

    result.fold(
      (failure) {
        _setRefetchAppointmentsState(AppointmentState.error);
        _errorMessage = failure.message;
        _errorCode = failure.code;
      },
      (response) {
        _setRefetchAppointmentsState(AppointmentState.fetched);
        _customerAppointments = response;
        _clearError();
      },
    );
  }

  // Set fetch state
  void _setFetchAppointmentsState(AppointmentState newState) {
    _fetchAppointmentsState = newState;
    notifyListeners();
  }

  // Set refetch state
  void _setRefetchAppointmentsState(AppointmentState newState) {
    _isRefetching = newState;
    notifyListeners();
  }

  // Set fetching new appointments state
  void _setFetchNewAppointmentsByStatus(AppointmentState newState) {
    _isFetchingNewAppointments = newState;
    notifyListeners();
  }

  // Set updating appointment status state
  void _setUpdateAppointmentStatus(AppointmentState newState) {
    _isUpdatingAppointmentStatus = newState;
    notifyListeners();
  }

  // Clear error
  void _clearError() {
    _errorMessageUpdate = null;
    _errorMessage = null;
    _errorCode = null;

    notifyListeners();
  }

  // Reset provider
  void reset() {
    _fetchAppointmentsState = AppointmentState.initial;
    _customerAppointments = null;
    _currentStatus = ApplicationStatus.pending;
    _clearError();
    notifyListeners();
  }
}
