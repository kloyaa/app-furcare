import 'package:flutter/material.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/models/client_models.dart';
import 'package:furcare_app/data/repositories/client_repository.dart';

class ClientProvider with ChangeNotifier {
  final ClientRepository _clientRepository;

  Client _client = Client(
    fullName: 'John Doe',
    contact: Contact(facebookDisplayName: '', phoneNumber: ''),
    address: '123 Main St',
    isActive: true,
    others: Others(lastLogin: '', lastChangePassword: ''),
    createdAt: '',
    updatedAt: '',
    v: 0,
    user: '',
  );

  bool _isLoading = false;
  String? _errorMessage;
  String? _errorCode;

  bool get isLoading => _isLoading;
  Client get client => _client;
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
        if (client != null) {
          _client = client;
        }
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
