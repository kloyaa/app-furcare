import 'package:equatable/equatable.dart';

class ClientRequest extends Equatable {
  final String fullName;
  final String address;
  final Contact contact;

  const ClientRequest({
    required this.fullName,
    required this.address,
    required this.contact,
  });

  Map<String, dynamic> toJson() {
    return {'fullName': fullName, 'address': address, 'contact': contact};
  }

  @override
  List<Object?> get props => [fullName, address, contact];
}

class Contact extends Equatable {
  final String? facebookUrl;
  final String? messengerUrl;
  final String phoneNumber;

  const Contact({
    this.facebookUrl,
    this.messengerUrl,
    required this.phoneNumber,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      facebookUrl: json['facebookUrl'] as String?,
      messengerUrl: json['messengerUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facebookUrl': facebookUrl,
      'messengerUrl': messengerUrl,
      'phoneNumber': phoneNumber,
    };
  }

  Contact copyWith({
    String? facebookUrl,
    String? messengerUrl,
    String? phoneNumber,
  }) {
    return Contact(
      facebookUrl: facebookUrl ?? this.facebookUrl,
      messengerUrl: messengerUrl ?? this.messengerUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [facebookUrl, messengerUrl, phoneNumber];
}

class Others extends Equatable {
  final String lastLogin;
  final String lastChangePassword;

  const Others({required this.lastLogin, required this.lastChangePassword});

  factory Others.fromJson(Map<String, dynamic> json) {
    return Others(
      lastLogin: json['lastLogin'] as String? ?? '',
      lastChangePassword: json['lastChangePassword'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'lastLogin': lastLogin, 'lastChangePassword': lastChangePassword};
  }

  Others copyWith({String? lastLogin, String? lastChangePassword}) {
    return Others(
      lastLogin: lastLogin ?? this.lastLogin,
      lastChangePassword: lastChangePassword ?? this.lastChangePassword,
    );
  }

  @override
  List<Object?> get props => [lastLogin, lastChangePassword];
}

class Client extends Equatable {
  final Contact contact;
  final String? id;
  final String user;
  final String fullName;
  final String address;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final Others others;

  const Client({
    required this.contact,
    this.id,
    required this.user,
    required this.fullName,
    required this.address,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
    required this.others,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      contact: Contact.fromJson(json['contact'] as Map<String, dynamic>),
      id: json['_id'] as String?,
      user: json['user'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      others: Others.fromJson(json['others'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact': contact.toJson(),
      '_id': id,
      'user': user,
      'fullName': fullName,
      'address': address,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'others': others.toJson(),
    };
  }

  Client copyWith({
    Contact? contact,
    String? id,
    String? user,
    String? fullName,
    String? address,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    int? v,
    Others? others,
  }) {
    return Client(
      contact: contact ?? this.contact,
      id: id ?? this.id,
      user: user ?? this.user,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      others: others ?? this.others,
    );
  }

  @override
  List<Object?> get props => [
    contact,
    id,
    user,
    fullName,
    address,
    isActive,
    createdAt,
    updatedAt,
    v,
    others,
  ];
}
