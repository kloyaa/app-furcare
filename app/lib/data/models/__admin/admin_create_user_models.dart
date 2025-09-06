import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/__admin/admin_user_models.dart';

class CreateUserRequest extends Equatable {
  final String username;
  final String email;
  final String password;
  final String fullName;
  final String address;
  final CreateUserContact contact;

  const CreateUserRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    required this.address,
    required this.contact,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'fullName': fullName,
      'address': address,
      'contact': contact.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    username,
    email,
    password,
    fullName,
    address,
    contact,
  ];
}

class UpdateUserInfoRequest extends Equatable {
  final String user;
  final String email;
  final String password;
  final String fullName;
  final String address;
  final CreateUserContact contact;

  const UpdateUserInfoRequest({
    required this.user,
    required this.email,
    required this.password,
    required this.fullName,
    required this.address,
    required this.contact,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'email': email,
      'password': password,
      'fullName': fullName,
      'address': address,
      'contact': contact.toJson(),
    };
  }

  @override
  List<Object?> get props => [email, password, fullName, address, contact];
}

class CreateUserContact extends Equatable {
  final String? facebookDisplayName;
  final String phoneNumber;

  const CreateUserContact({
    this.facebookDisplayName,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {'phoneNumber': phoneNumber};
    if (facebookDisplayName != null && facebookDisplayName!.isNotEmpty) {
      json['facebookDisplayName'] = facebookDisplayName;
    }
    return json;
  }

  @override
  List<Object?> get props => [facebookDisplayName, phoneNumber];
}

class CreateUserResponse extends Equatable {
  final bool success;
  final String? message;
  final AdminUser? user;

  const CreateUserResponse({required this.success, this.message, this.user});

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) {
    return CreateUserResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      user: json['user'] != null
          ? AdminUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [success, message, user];
}

class DeactivateUserRequest extends Equatable {
  final String user;

  const DeactivateUserRequest({required this.user});

  Map<String, dynamic> toJson() {
    return {'user': user};
  }

  @override
  List<Object?> get props => [user];
}

class ActivateUserRequest extends Equatable {
  final String user;

  const ActivateUserRequest({required this.user});

  Map<String, dynamic> toJson() {
    return {'user': user};
  }

  @override
  List<Object?> get props => [user];
}

class UpdateUserStatusResponse extends Equatable {
  final String username;
  final String email;
  final String updatedAt;
  final bool isActive;

  const UpdateUserStatusResponse({
    required this.username,
    required this.email,
    required this.updatedAt,
    required this.isActive,
  });

  factory UpdateUserStatusResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserStatusResponse(
      username: json['username'] as String,
      email: json['email'] as String,
      updatedAt: json['updatedAt'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  @override
  List<Object?> get props => [username, email, updatedAt, isActive];
}
