import 'package:equatable/equatable.dart';

class AdminUser extends Equatable {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String address;
  final AdminContact contact;
  final List<String> roles;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  const AdminUser({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.address,
    required this.contact,
    required this.roles,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    final contactData = json['contact'];

    return AdminUser(
      id: json['_id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      contact: contactData is Map<String, dynamic>
          ? AdminContact.fromJson(contactData)
          : AdminContact(
              phoneNumber: 'N/A',
              facebookDisplayName: "N/A",
            ), // fallback if "N/A" or invalid
      roles:
          (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'address': address,
      'contact': contact.toJson(),
      'roles': roles,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  AdminUser copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? address,
    AdminContact? contact,
    List<String>? roles,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
  }) {
    return AdminUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    fullName,
    address,
    contact,
    roles,
    isActive,
    createdAt,
    updatedAt,
  ];
}

class AdminContact extends Equatable {
  final String? facebookDisplayName;
  final String phoneNumber;

  const AdminContact({this.facebookDisplayName, required this.phoneNumber});

  factory AdminContact.fromJson(Map<String, dynamic> json) {
    return AdminContact(
      facebookDisplayName: json['facebookDisplayName'] as String?,
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );
  }

  /// Fallback for cases where `contact` is "N/A" or invalid
  factory AdminContact.empty() {
    return const AdminContact(facebookDisplayName: null, phoneNumber: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'facebookDisplayName': facebookDisplayName,
      'phoneNumber': phoneNumber,
    };
  }

  AdminContact copyWith({String? facebookDisplayName, String? phoneNumber}) {
    return AdminContact(
      facebookDisplayName: facebookDisplayName ?? this.facebookDisplayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [facebookDisplayName, phoneNumber];
}
