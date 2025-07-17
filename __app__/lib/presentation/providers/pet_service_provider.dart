import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/data/models/pet_service.models.dart';
import 'package:flutter_application_1/data/repositories/pet_service_repository.dart';

enum FetchingState { initial, loading, done, error }

class PetServiceProvider with ChangeNotifier {
  final PetServiceRepository _petServiceRepository;

  List<PetService> _petServices = [];
  FetchingState _state = FetchingState.initial;

  bool _isLoading = true;
  String? _errorMessage;
  String? _errorCode;

  List<PetService> get petServices => _petServices;
  bool get isLoading => _isLoading;

  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  bool get isInitial => _state == FetchingState.initial;
  bool get isSuccess => _state == FetchingState.done;
  bool get isFetching => _state == FetchingState.loading;
  bool get isError => _state == FetchingState.error;

  PetServiceProvider({required PetServiceRepository petServiceRepository})
    : _petServiceRepository = petServiceRepository;

  Future<void> getPetServices() async {
    _setFetchingState(FetchingState.loading);
    final result = await _petServiceRepository.getPetServices();

    result.fold(
      (failure) {
        _setFetchingState(FetchingState.error);
        _handleFailure(failure);
      },
      (services) {
        _petServices = services;
        _setFetchingState(FetchingState.done);
        notifyListeners();
      },
    );
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _errorCode = failure.code;
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();
  }

  void _setFetchingState(FetchingState state) {
    _state = state;
    notifyListeners();
  }
}
