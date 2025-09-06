import 'package:flutter/material.dart';

abstract class BaseAdminProvider with ChangeNotifier {
  String? _errorMessage;
  String? _errorCode;

  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  void handleError(String message, String? code) {
    _errorMessage = message;
    _errorCode = code;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();
  }
}
