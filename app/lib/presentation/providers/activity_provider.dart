import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/data/models/activity_log_models.dart';
import 'package:flutter_application_1/data/repositories/activity_repository.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityRepository _activityRepository;

  List<ActivityLog> _activities = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _errorCode;

  bool get isLoading => _isLoading;
  List<ActivityLog> get activities => _activities;
  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  ActivityProvider({required ActivityRepository activityRepository})
    : _activityRepository = activityRepository;

  Future<void> getActivities() async {
    _setLoading(true);
    final result = await _activityRepository.getActivities();

    result.fold(
      (failure) {
        _setLoading(false);
        _handleFailure(failure);
      },
      (activities) {
        _activities = activities;
        _setLoading(false);
        notifyListeners();
      },
    );
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _errorCode = failure.code;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      clearError();
    }
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();
  }
}
