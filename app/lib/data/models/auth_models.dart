import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  final String username;
  final String password;

  const LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }

  @override
  List<Object?> get props => [username, password];
}

class RegisterRequest extends Equatable {
  final String email;
  final String username;
  final String password;

  const RegisterRequest({
    required this.email,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'username': username, 'password': password};
  }

  @override
  List<Object?> get props => [email, username, password];
}

class ChangePasswordRequest extends Equatable {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {'currentPassword': currentPassword, 'newPassword': newPassword};
  }

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class AuthResponse extends Equatable {
  final String message;
  final String code;
  final String accessToken;

  const AuthResponse({
    required this.message,
    required this.code,
    required this.accessToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] as String,
      code: json['code'] as String,
      accessToken: json['accessToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'code': code, 'accessToken': accessToken};
  }

  @override
  List<Object?> get props => [message, code, accessToken];
}

class User extends Equatable {
  final String? id;
  final String? email;
  final String? username;
  final String? accessToken;

  const User({this.id, this.email, this.username, this.accessToken});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      accessToken: json['accessToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'accessToken': accessToken,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? accessToken,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  @override
  List<Object?> get props => [id, email, username, accessToken];
}
