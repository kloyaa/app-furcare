import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/pet_models.dart';

class AppointmentStatusUpdateResponse extends Equatable {
  final ApplicationDetails application;
  final String message;

  const AppointmentStatusUpdateResponse({
    required this.application,
    required this.message,
  });

  factory AppointmentStatusUpdateResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentStatusUpdateResponse(
      application: ApplicationDetails.fromJson(
        json['application'] as Map<String, dynamic>,
      ),
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'application': application.toJson(), 'message': message};
  }

  AppointmentStatusUpdateResponse copyWith({
    ApplicationDetails? application,
    String? message,
  }) {
    return AppointmentStatusUpdateResponse(
      application: application ?? this.application,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [application, message];
}

class ApplicationDetails extends Equatable {
  final String id;
  final ApplicationUser user;
  final ApplicationPet pet;
  final ApplicationBranch branch;
  final int totalPrice;
  final String status;
  final String scheduleCode;
  final List<String> groomingOptions;
  final List<String> groomingPreferences;
  final bool hasAllergy;
  final bool isOnMedication;
  final bool hasAntiRabbiesVaccination;
  final int paidAmount;
  final String paymentStatus;
  final String createdAt;
  final String updatedAt;
  final int? v;
  final int remainingBalance;

  const ApplicationDetails({
    required this.id,
    required this.user,
    required this.pet,
    required this.branch,
    required this.totalPrice,
    required this.status,
    required this.scheduleCode,
    required this.groomingOptions,
    required this.groomingPreferences,
    required this.hasAllergy,
    required this.isOnMedication,
    required this.hasAntiRabbiesVaccination,
    required this.paidAmount,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.v,
    required this.remainingBalance,
  });

  factory ApplicationDetails.fromJson(Map<String, dynamic> json) {
    return ApplicationDetails(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      user: ApplicationUser.fromJson(json['user'] as Map<String, dynamic>),
      pet: ApplicationPet.fromJson(json['pet'] as Map<String, dynamic>),
      branch: ApplicationBranch.fromJson(
        json['branch'] as Map<String, dynamic>,
      ),
      totalPrice: json['totalPrice'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      scheduleCode: json['scheduleCode'] as String? ?? '',
      groomingOptions:
          (json['groomingOptions'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      groomingPreferences:
          (json['groomingPreferences'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      hasAllergy: json['hasAllergy'] as bool? ?? false,
      isOnMedication: json['isOnMedication'] as bool? ?? false,
      hasAntiRabbiesVaccination:
          json['hasAntiRabbiesVaccination'] as bool? ?? false,
      paidAmount: json['paidAmount'] as int? ?? 0,
      paymentStatus: json['paymentStatus'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      v: json['__v'] as int?,
      remainingBalance: json['remainingBalance'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toJson(),
      'pet': pet.toJson(),
      'branch': branch.toJson(),
      'totalPrice': totalPrice,
      'status': status,
      'scheduleCode': scheduleCode,
      'groomingOptions': groomingOptions,
      'groomingPreferences': groomingPreferences,
      'hasAllergy': hasAllergy,
      'isOnMedication': isOnMedication,
      'hasAntiRabbiesVaccination': hasAntiRabbiesVaccination,
      'paidAmount': paidAmount,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'remainingBalance': remainingBalance,
      'id': id,
    };
  }

  ApplicationDetails copyWith({
    String? id,
    ApplicationUser? user,
    ApplicationPet? pet,
    ApplicationBranch? branch,
    int? totalPrice,
    String? status,
    String? scheduleCode,
    List<String>? groomingOptions,
    List<String>? groomingPreferences,
    bool? hasAllergy,
    bool? isOnMedication,
    bool? hasAntiRabbiesVaccination,
    int? paidAmount,
    String? paymentStatus,
    String? createdAt,
    String? updatedAt,
    int? v,
    int? remainingBalance,
  }) {
    return ApplicationDetails(
      id: id ?? this.id,
      user: user ?? this.user,
      pet: pet ?? this.pet,
      branch: branch ?? this.branch,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      scheduleCode: scheduleCode ?? this.scheduleCode,
      groomingOptions: groomingOptions ?? this.groomingOptions,
      groomingPreferences: groomingPreferences ?? this.groomingPreferences,
      hasAllergy: hasAllergy ?? this.hasAllergy,
      isOnMedication: isOnMedication ?? this.isOnMedication,
      hasAntiRabbiesVaccination:
          hasAntiRabbiesVaccination ?? this.hasAntiRabbiesVaccination,
      paidAmount: paidAmount ?? this.paidAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      remainingBalance: remainingBalance ?? this.remainingBalance,
    );
  }

  @override
  List<Object?> get props => [
    id,
    user,
    pet,
    branch,
    totalPrice,
    status,
    scheduleCode,
    groomingOptions,
    groomingPreferences,
    hasAllergy,
    isOnMedication,
    hasAntiRabbiesVaccination,
    paidAmount,
    paymentStatus,
    createdAt,
    updatedAt,
    v,
    remainingBalance,
  ];
}

class ApplicationUser extends Equatable {
  final String id;
  final String username;
  final String email;

  const ApplicationUser({
    required this.id,
    required this.username,
    required this.email,
  });

  factory ApplicationUser.fromJson(Map<String, dynamic> json) {
    return ApplicationUser(
      id: json['_id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'username': username, 'email': email};
  }

  ApplicationUser copyWith({String? id, String? username, String? email}) {
    return ApplicationUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [id, username, email];
}

class ApplicationPet extends Pet {
  const ApplicationPet({
    required super.id,
    required super.name,
    required super.specie,
    required super.gender,
  });

  factory ApplicationPet.fromJson(Map<String, dynamic> json) {
    return ApplicationPet(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      specie: json['specie'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
    );
  }
}

class ApplicationBranch extends Equatable {
  final String id;
  final String name;

  const ApplicationBranch({required this.id, required this.name});

  factory ApplicationBranch.fromJson(Map<String, dynamic> json) {
    return ApplicationBranch(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }

  ApplicationBranch copyWith({String? id, String? name}) {
    return ApplicationBranch(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [id, name];
}
