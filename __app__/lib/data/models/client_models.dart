import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String? present;
  final String? permanent;

  const Address({this.present, this.permanent});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      present: json['present'] as String?,
      permanent: json['permanent'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'present': present, 'permanent': permanent};
  }

  Address copyWith({String? present, String? permanent}) {
    return Address(
      present: present ?? this.present,
      permanent: permanent ?? this.permanent,
    );
  }

  @override
  List<Object?> get props => [present, permanent];
}

class Contact extends Equatable {
  final String? email;
  final String? number;

  const Contact({this.email, this.number});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      email: json['email'] as String?,
      number: json['number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'number': number};
  }

  Contact copyWith({String? email, String? number}) {
    return Contact(email: email ?? this.email, number: number ?? this.number);
  }

  @override
  List<Object?> get props => [email, number];
}

class Others extends Equatable {
  final String? lastLogin;
  final String? lastChangePassword;

  const Others({this.lastLogin, this.lastChangePassword});

  factory Others.fromJson(Map<String, dynamic> json) {
    return Others(
      lastLogin: json['lastLogin'] as String?,
      lastChangePassword: json['lastChangePassword'] as String?,
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
  final String? id;
  final String? user;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? birthdate;
  final String? gender;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final int? version;
  final Address? address;
  final Contact? contact;
  final Others? others;

  const Client({
    this.id,
    this.user,
    this.firstName,
    this.lastName,
    this.middleName,
    this.birthdate,
    this.gender,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.address,
    this.contact,
    this.others,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['_id'] as String?,
      user: json['user'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      middleName: json['middleName'] as String?,
      birthdate: json['birthdate'] as String?,
      gender: json['gender'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      version: json['__v'] as int?,
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      contact: json['contact'] != null
          ? Contact.fromJson(json['contact'] as Map<String, dynamic>)
          : null,
      others: json['others'] != null
          ? Others.fromJson(json['others'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'birthdate': birthdate,
      'gender': gender,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
      'address': address?.toJson(),
      'contact': contact?.toJson(),
      'others': others?.toJson(),
    };
  }

  Client copyWith({
    String? id,
    String? user,
    String? firstName,
    String? lastName,
    String? middleName,
    String? birthdate,
    String? gender,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    int? version,
    Address? address,
    Contact? contact,
    Others? others,
  }) {
    return Client(
      id: id ?? this.id,
      user: user ?? this.user,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      others: others ?? this.others,
    );
  }

  @override
  List<Object?> get props => [
    id,
    user,
    firstName,
    lastName,
    middleName,
    birthdate,
    gender,
    isActive,
    createdAt,
    updatedAt,
    version,
    address,
    contact,
    others,
  ];
}
