import 'package:flutter/material.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/models/pet_models.dart';
import 'package:furcare_app/data/repositories/pet_repository.dart';

enum PetState {
  initial,
  loading,
  success,
  error,
  created,
  fetched,
  updated,
  deleted,
}

class PetProvider with ChangeNotifier {
  final PetRepository _petRepository;

  PetState _createPetState = PetState.initial;
  PetState _fetchPetsState = PetState.initial;
  PetState _updatePetState = PetState.initial;

  List<Pet> _pets = [];
  String? _errorMessage;
  String? _errorCode;

  List<Pet> get pets => _pets;
  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  bool get isCreatingPet => _createPetState == PetState.loading;
  bool get isFetchingPets => _fetchPetsState == PetState.loading;
  bool get isUpdatingPet => _updatePetState == PetState.loading;

  PetProvider({required PetRepository petRepository})
    : _petRepository = petRepository;

  Future<void> getPets() async {
    clearError();
    _setFetchingState(PetState.loading);
    final result = await _petRepository.getPets();

    result.fold(
      (failure) {
        _setFetchingState(PetState.error);
        _handleFailure(failure);
      },
      (pets) {
        _pets = pets;
        _setFetchingState(PetState.fetched);
      },
    );
  }

  Future<void> createPet(RequestPet request) async {
    clearError();

    _setCreatePetState(PetState.loading);
    final result = await _petRepository.createPet(request);

    result.fold(
      (failure) {
        _setCreatePetState(PetState.error);
        _handleFailure(failure);
      },
      (pet) {
        _setCreatePetState(PetState.created);
        getPets();
      },
    );
  }

  Future<void> updatePet(UpdatePet request) async {
    clearError();

    _setUpdatePetState(PetState.loading);
    final result = await _petRepository.updatePet(request);
    result.fold(
      (failure) {
        _setUpdatePetState(PetState.error);
        _handleFailure(failure);
      },
      (pet) {
        _setUpdatePetState(PetState.created);
        getPets();
      },
    );
  }

  Future<void> deletePet(String id) async {
    final result = await _petRepository.deletePet(id);
    result.fold(
      (failure) {
        _handleFailure(failure);
      },
      (pet) {
        getPets();
      },
    );
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

  void _setCreatePetState(PetState newState) {
    _createPetState = newState;
    notifyListeners();
  }

  void _setUpdatePetState(PetState newState) {
    _updatePetState = newState;
    notifyListeners();
  }

  void _setFetchingState(PetState newState) {
    _fetchPetsState = newState;
    notifyListeners();
  }
}
