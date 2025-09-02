import 'package:flutter/foundation.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/models/boarding/boarding.dart';
import 'package:furcare_app/data/models/boarding/boarding_request.dart';
import 'package:furcare_app/data/models/grooming/grooming.dart';
import 'package:furcare_app/data/models/grooming/grooming_request.dart';
import 'package:furcare_app/data/models/home_service/home_service.dart';
import 'package:furcare_app/data/models/home_service/home_service_request.dart';
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

class AppointmentProvider with ChangeNotifier {
  final AppointmentRepository _appointmentRepository;

  AppointmentProvider({required AppointmentRepository appointmentRepository})
    : _appointmentRepository = appointmentRepository;

  AppointmentState _createApplicationState = AppointmentState.initial;
  AppointmentState _isFetchingApplicationState = AppointmentState.initial;

  List<GroomingAppointment> _groomingAppointments = [];
  List<BoardingAppointment> _boardingAppointments = [];
  List<HomeServiceAppointment> _homeServiceAppointments = [];

  String? _errorMessage;
  String? _errorCode;

  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  bool get isCreatingApplication =>
      _createApplicationState == AppointmentState.loading;

  bool get isFetchingAppointments =>
      _isFetchingApplicationState == AppointmentState.loading;

  List<GroomingAppointment> get groomingAppointments => _groomingAppointments;
  List<BoardingAppointment> get boardingAppointments => _boardingAppointments;
  List<HomeServiceAppointment> get homeServiceAppointments =>
      _homeServiceAppointments;

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
        _setCreateGroomingAppointment(AppointmentState.error);
        _handleFailure(failure);
      },
      (response) {
        _setCreateGroomingAppointment(AppointmentState.created);
      },
    );
  }

  Future<void> createBoardingAppointment(
    BoardingAppointmentRequest request,
  ) async {
    clearError();
    _setCreateBoardingAppointment(AppointmentState.loading);

    final result = await _appointmentRepository.createBoardingAppointment(
      request,
    );

    result.fold(
      (failure) {
        _setCreateBoardingAppointment(AppointmentState.error);
        _handleFailure(failure);
      },
      (response) {
        _setCreateBoardingAppointment(AppointmentState.created);
      },
    );
  }

  Future<void> createHomeServiceAppointment(
    HomeServiceAppointmentRequest request,
  ) async {
    clearError();

    final result = await _appointmentRepository.createHomeServiceAppointment(
      request,
    );
    result.fold(
      (failure) {
        _setCreateHomeServiceAppointment(AppointmentState.error);
        _handleFailure(failure);
      },
      (response) {
        _setCreateHomeServiceAppointment(AppointmentState.created);
      },
    );
  }

  Future<void> createBoardingAppointmentExtension(
    AppointmentExtensionRequest request,
  ) async {
    clearError();

    final result = await _appointmentRepository
        .createBoardingAppointmentExtension(request);

    result.fold(
      (failure) {
        _handleFailure(failure);
      },
      (response) {
        getBoardingAppointments();
      },
    );
  }

  Future<void> getGroomingAppointments() async {
    _setGettGroomingAppointments(AppointmentState.loading);

    final result = await _appointmentRepository.getGroomingAppointments();
    result.fold(
      (failure) {
        clearError();
        _setGettGroomingAppointments(AppointmentState.error);
        _handleFailure(failure);
      },
      (response) {
        _groomingAppointments = response;
        _setGettGroomingAppointments(AppointmentState.fetched);
      },
    );
  }

  Future<void> getBoardingAppointments() async {
    _setGetBoardingAppointments(AppointmentState.loading);

    final result = await _appointmentRepository.getBoardingAppointments();
    result.fold(
      (failure) {
        clearError();
        _setGetBoardingAppointments(AppointmentState.error);
        _handleFailure(failure);
      },
      (response) {
        _boardingAppointments = response;
        _setGetBoardingAppointments(AppointmentState.fetched);
      },
    );
  }

  Future<void> getHomeServiceAppointments() async {
    _setGetHomeServiceAppointments(AppointmentState.loading);

    final result = await _appointmentRepository.getHomeServiceAppointments();
    result.fold(
      (failure) {
        clearError();
        _setGetHomeServiceAppointments(AppointmentState.error);
        _handleFailure(failure);
      },
      (response) {
        _homeServiceAppointments = response;
        _setGetHomeServiceAppointments(AppointmentState.fetched);
      },
    );
  }

  void _setCreateGroomingAppointment(AppointmentState newState) {
    _createApplicationState = newState;
    notifyListeners();
  }

  void _setCreateBoardingAppointment(AppointmentState newState) {
    _createApplicationState = newState;
    notifyListeners();
  }

  void _setCreateHomeServiceAppointment(AppointmentState newState) {
    _createApplicationState = newState;
    notifyListeners();
  }

  void _setGettGroomingAppointments(AppointmentState newState) {
    _isFetchingApplicationState = newState;
    notifyListeners();
  }

  void _setGetHomeServiceAppointments(AppointmentState newState) {
    _isFetchingApplicationState = newState;
    notifyListeners();
  }

  void _setGetBoardingAppointments(AppointmentState newState) {
    _isFetchingApplicationState = newState;
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
