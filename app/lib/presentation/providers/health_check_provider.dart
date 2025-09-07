import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/state.dart';
import 'package:furcare_app/data/models/health_check_models.dart';
import 'package:furcare_app/data/repositories/health_check_repository.dart';

class HealthCheckProvider with ChangeNotifier {
  final HealthCheckRepository _repository;

  HealthCheckProvider({required HealthCheckRepository repository})
    : _repository = repository;

  AdminState _state = AdminState.initial;
  HealthCheckResponse? _healthStatus;
  String? _errorMessage;
  String? _errorCode;

  // Getters
  AdminState get state => _state;
  bool get isLoading => _state == AdminState.loading;
  bool get hasError => _state == AdminState.error;
  bool get isSuccess => _state == AdminState.fetched;
  HealthCheckResponse? get healthStatus => _healthStatus;
  String? get errorMessage => _errorMessage;
  String? get errorCode => _errorCode;

  // Computed properties
  bool get isDatabaseConnected => _healthStatus?.database ?? false;
  bool get isUnderMaintenance => _healthStatus?.maintenance.value ?? false;
  String get maintenanceMessage => _healthStatus?.maintenance.message ?? '';
  bool get isSystemHealthy => _healthStatus?.isHealthy ?? false;

  Future<void> checkHealth() async {
    _setState(AdminState.loading);
    _clearError();

    final result = await _repository.getHealthStatus();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _errorCode = failure.code;
        _setState(AdminState.error);
      },
      (response) {
        _healthStatus = response;
        _setState(AdminState.fetched);
      },
    );
  }

  void reset() {
    _state = AdminState.initial;
    _healthStatus = null;
    _clearError();
    notifyListeners();
  }

  void _setState(AdminState newState) {
    _state = newState;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    _errorCode = null;
  }
}
