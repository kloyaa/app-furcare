import 'package:flutter/foundation.dart';
import 'package:furcare_app/core/enums/application.dart';
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

  String? _errorMessage;
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

  String? get error => _errorMessage;
  String? get errorCode => _errorCode;
  CustomerAppointments? get customerAppointments => _customerAppointments;
  ApplicationStatus get currentStatus => _currentStatus;

  // Main method to fetch customer appointments with status filter
  Future<void> getCustomerAppointments({ApplicationStatus? status}) async {
    _setFetchAppointmentsState(AppointmentState.loading);

    if (status != null) {
      _currentStatus = status;
    }

    final result = await _appointmentRepository.getCustomerAppointments(
      _currentStatus,
    );

    result.fold(
      (failure) {
        _setFetchAppointmentsState(AppointmentState.error);
        _errorMessage = failure.message;
        _errorCode = failure.code;
        print('Error fetching appointments: ${failure.message}');
      },
      (response) {
        _setFetchAppointmentsState(AppointmentState.fetched);
        _customerAppointments = response;
        _clearError();
      },
    );
  }

  // Change status and fetch appointments
  Future<void> changeAppointmentStatus(ApplicationStatus newStatus) async {
    _currentStatus = newStatus;
    _setChangeAppointmentStatus(AppointmentState.loading);

    final result = await _appointmentRepository.getCustomerAppointments(
      _currentStatus,
    );

    result.fold(
      (failure) {
        _setChangeAppointmentStatus(AppointmentState.error);
        _errorMessage = failure.message;
        _errorCode = failure.code;
        print('Error fetching appointments: ${failure.message}');
      },
      (response) {
        _setChangeAppointmentStatus(AppointmentState.fetched);
        _customerAppointments = response;
        _clearError();
      },
    );
  }

  // Refresh appointments with current status
  Future<void> refreshAppointments() async {
    _setRefetchAppointmentsState(AppointmentState.loading);

    final result = await _appointmentRepository.getCustomerAppointments(
      _currentStatus,
    );

    result.fold(
      (failure) {
        _setRefetchAppointmentsState(AppointmentState.error);
        _errorMessage = failure.message;
        _errorCode = failure.code;
        print('Error fetching appointments: ${failure.message}');
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
  void _setChangeAppointmentStatus(AppointmentState newState) {
    _isFetchingNewAppointments = newState;
    notifyListeners();
  }

  // Clear error
  void _clearError() {
    _errorMessage = null;
    _errorCode = null;
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
