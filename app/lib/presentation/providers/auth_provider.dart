import 'package:flutter/foundation.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/models/auth_models.dart';
import 'package:furcare_app/data/repositories/auth_repository.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthState _state = AuthState.initial;
  User? _user;
  String? _accessToken;
  String? _errorMessage;
  String? _errorCode;

  AuthProvider({required AuthRepository authRepository})
    : _authRepository = authRepository;

  // Getters
  AuthState get state => _state;
  User? get user => _user;
  String? get accessToken => _accessToken;
  String? get errorMessage => _errorMessage;
  String? get errorCode => _errorCode;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isUnauthenticated => _state == AuthState.unauthenticated;
  bool get isLoading => _state == AuthState.loading;

  // Login
  Future<void> login({
    required String username,
    required String password,
  }) async {
    clearError(); // Clear previous error
    _setState(AuthState.loading);

    final request = LoginRequest(username: username, password: password);
    final result = await _authRepository.login(request);

    result.fold(
      (failure) => _handleFailure(failure),
      (response) => _handleLoginSuccess(response, username),
    );
  }

  // Register
  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    _setState(AuthState.loading);

    final request = RegisterRequest(
      email: email,
      username: username,
      password: password,
    );
    final result = await _authRepository.register(request);

    result.fold(
      (failure) => _handleFailure(failure),
      (response) => _handleRegisterSuccess(response, email, username),
    );
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    clearError(); // Clear previous error
    _setState(AuthState.loading);

    final request = ChangePasswordRequest(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    final result = await _authRepository.changePassword(request);

    result.fold(
      (failure) => _handleFailure(failure),
      (response) async => await _handleChangePasswordSuccess(),
    );
  }

  // Check if user is already logged in
  Future<void> checkAuthStatus() async {
    _setState(AuthState.loading);

    final sessionResult = await _authRepository.hasValidSession();

    await sessionResult.fold((failure) async => _handleFailure(failure), (
      hasSession,
    ) async {
      if (hasSession) {
        await _loadUserData();
      } else {
        _setState(AuthState.unauthenticated);
      }
    });
  }

  // Load user data from local storage
  Future<void> _loadUserData() async {
    final userResult = await _authRepository.getCurrentUser();
    final tokenResult = await _authRepository.getAccessToken();

    userResult.fold((failure) => _handleFailure(failure), (user) {
      tokenResult.fold((failure) => _handleFailure(failure), (token) {
        _user = user;
        _accessToken = token;
        _setState(AuthState.authenticated);
      });
    });
  }

  // Logout
  Future<void> logout() async {
    clearError(); // Clear previous error
    _setState(AuthState.loading);

    final result = await _authRepository.logout();

    result.fold((failure) => _handleFailure(failure), (_) {
      _user = null;
      _accessToken = null;
      _errorMessage = null;
      _setState(AuthState.unauthenticated);
    });
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();
  }

  // Handle login success
  void _handleLoginSuccess(AuthResponse response, String username) {
    _user = User(username: username, accessToken: response.accessToken);
    _accessToken = response.accessToken;

    clearError(); // Clear previous error
    _setState(AuthState.authenticated);
  }

  // Handle register success
  void _handleRegisterSuccess(
    AuthResponse response,
    String email,
    String username,
  ) {
    clearError(); // Clear previous error

    _user = User(
      email: email,
      username: username,
      accessToken: response.accessToken,
    );
    _accessToken = response.accessToken;
    _setState(AuthState.authenticated);
  }

  Future<void> _handleChangePasswordSuccess() async {
    await logout();
    _setState(AuthState.unauthenticated);
  }

  // Handle failure
  void _handleFailure(Failure failure) {
    _setState(AuthState.error);
    _errorMessage = failure.message;
    _errorCode = failure.code;
  }

  // Set state and notify listeners
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }
}
