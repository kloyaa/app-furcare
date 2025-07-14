import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/data/models/client_models.dart';
import 'package:flutter_application_1/data/repositories/client_repository.dart';

class ClientProvider with ChangeNotifier {
  final ClientRepository _clientRepository;

  Client? _client;
  bool _isLoading = false;
  String? _errorMessage;
  String? _errorCode;

  bool get isLoading => _isLoading;
  Client? get client => _client;
  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  ClientProvider({required ClientRepository clientRepository})
    : _clientRepository = clientRepository;

  Future<void> getProfile() async {
    _setLoading(true);
    final result = await _clientRepository.getProfile();

    result.fold(
      (failure) {
        _setLoading(false);
        _handleFailure(failure);
      },
      (client) {
        _client = client;
        _setLoading(false);
        notifyListeners();
      },
    );
  }

  Future<void> createProfile(ClientRequest request) async {
    _setLoading(true);
    final result = await _clientRepository.createProfile(request);

    result.fold(
      (failure) {
        _setLoading(false);
        _handleFailure(failure);
      },
      (client) {
        _setLoading(false);
        notifyListeners();
      },
    );
  }

  Future<void> updateProfile(ClientRequest request) async {
    _setLoading(true);
    final result = await _clientRepository.updateProfile(request);

    result.fold(
      (failure) {
        _setLoading(false);
        _handleFailure(failure);
      },
      (client) {
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
