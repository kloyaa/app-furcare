import 'package:flutter/material.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';
import 'package:furcare_app/data/repositories/pet_service_repository.dart';

enum PetServiceState { initial, loading, done, error }

class PetServiceProvider with ChangeNotifier {
  final PetServiceRepository _petServiceRepository;

  List<PetService> _petServices = [];
  List<PetCage> _petCages = [];
  List<GroomingOptions> _groomingOptions = [];
  List<GroomingSchedule> _groomingSchedules = [];
  List<GroomingPreference> _groomingPreferences = [];

  PetServiceState _state = PetServiceState.initial;
  PetServiceState _fetchGroomingOptionsState = PetServiceState.initial;
  PetServiceState _fetchGroomingPreferencesState = PetServiceState.initial;
  PetServiceState _fetchGroomingSchedulesState = PetServiceState.initial;
  PetServiceState _fetchPetCagesState = PetServiceState.initial;

  String? _errorMessage;
  String? _errorCode;

  List<PetService> get petServices => _petServices;

  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  bool get isInitial => _state == PetServiceState.initial;
  bool get isSuccess => _state == PetServiceState.done;
  bool get isFetching => _state == PetServiceState.loading;
  bool get isError => _state == PetServiceState.error;

  bool get isFetchingGroomingOptions =>
      _fetchGroomingOptionsState == PetServiceState.loading;
  bool get isFetchingGroomingPreferences =>
      _fetchGroomingPreferencesState == PetServiceState.loading;
  bool get isFetchingGroomingSchedules =>
      _fetchGroomingSchedulesState == PetServiceState.loading;
  bool get isFetchingPetCages => _fetchPetCagesState == PetServiceState.loading;

  List<GroomingOptions> get groomingOptions => _groomingOptions;
  List<GroomingSchedule> get groomingSchedules => _groomingSchedules;
  List<GroomingPreference> get groomingPreferences => _groomingPreferences;
  List<PetCage> get petCages => _petCages;

  PetServiceProvider({required PetServiceRepository petServiceRepository})
    : _petServiceRepository = petServiceRepository;

  Future<void> getPetServices() async {
    _setFetchingState(PetServiceState.loading);
    final result = await _petServiceRepository.getPetServices();

    result.fold(
      (failure) {
        _setFetchingState(PetServiceState.error);
        _handleFailure(failure);
      },
      (services) {
        _petServices = services;
        _setFetchingState(PetServiceState.done);
        notifyListeners();
      },
    );
  }

  Future<void> getGroomingSchedules() async {
    _setGetGroomingSchedulesState(PetServiceState.loading);
    final result = await _petServiceRepository.getGroomingSchedules();

    result.fold(
      (failure) {
        _setGetGroomingSchedulesState(PetServiceState.error);
        _handleFailure(failure);
      },
      (response) {
        _setGetGroomingSchedulesState(PetServiceState.done);
        _groomingSchedules = response;
        notifyListeners();
      },
    );
  }

  Future<void> getGroomingOptions() async {
    _setGetGroomingOptionsState(PetServiceState.loading);
    final result = await _petServiceRepository.getGroomingOptions();

    result.fold(
      (failure) {
        _setGetGroomingOptionsState(PetServiceState.error);
        _handleFailure(failure);
      },
      (response) {
        _groomingOptions = response;
        _setGetGroomingOptionsState(PetServiceState.done);
        notifyListeners();
      },
    );
  }

  Future<void> getGroomingPreferences() async {
    _setGetGroomingPreferencesState(PetServiceState.loading);
    final result = await _petServiceRepository.getGroomingPreferences();

    result.fold(
      (failure) {
        _setGetGroomingPreferencesState(PetServiceState.error);
        _handleFailure(failure);
      },
      (response) {
        _groomingPreferences = response;
        _setGetGroomingPreferencesState(PetServiceState.done);
        notifyListeners();
      },
    );
  }

  Future<void> getPetCages() async {
    _setFetchingPetCagesState(PetServiceState.loading);
    final result = await _petServiceRepository.getPetCages();

    result.fold(
      (failure) {
        _setFetchingPetCagesState(PetServiceState.error);
        _handleFailure(failure);
      },
      (cages) {
        _petCages = cages;
        _setFetchingPetCagesState(PetServiceState.done);
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

  void _setFetchingState(PetServiceState state) {
    _state = state;
    notifyListeners();
  }

  void _setFetchingPetCagesState(PetServiceState state) {
    _fetchPetCagesState = state;
    notifyListeners();
  }

  void _setGetGroomingSchedulesState(PetServiceState state) {
    _fetchGroomingSchedulesState = state;
    notifyListeners();
  }

  void _setGetGroomingPreferencesState(PetServiceState state) {
    _fetchGroomingPreferencesState = state;
    notifyListeners();
  }

  void _setGetGroomingOptionsState(PetServiceState state) {
    _fetchGroomingOptionsState = state;
    notifyListeners();
  }
}
