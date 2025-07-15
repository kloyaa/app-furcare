import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/data/models/pet_service.models.dart';
import 'package:flutter_application_1/data/repositories/pet_service_repository.dart';

class PetServiceProvider with ChangeNotifier {
  final PetServiceRepository _petServiceRepository;

  List<PetService> _petServices = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _errorCode;

  List<PetService> get petServices => _petServices;
  bool get isLoading => _isLoading;

  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  PetServiceProvider({required PetServiceRepository petServiceRepository})
    : _petServiceRepository = petServiceRepository;

  Future<void> getPetServices() async {
    _setLoading(true);
    final result = await _petServiceRepository.getPetServices();

    result.fold(
      (failure) {
        _setLoading(false);
        _handleFailure(failure);
      },
      (services) {
        _petServices = services;
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
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();
  }
}
