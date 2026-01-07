import 'package:equatable/equatable.dart';

class GroomingAppointmentRes extends Equatable {
  final String user;
  final String pet;
  final String branch;
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
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final int remainingBalance;

  const GroomingAppointmentRes({
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
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.remainingBalance,
  });

  factory GroomingAppointmentRes.fromJson(Map<String, dynamic> json) {
    return GroomingAppointmentRes(
      user: json['user'] as String,
      pet: json['pet'] as String,
      branch: json['branch'] as String,
      totalPrice: json['totalPrice'] as int,
      status: json['status'] as String,
      scheduleCode: json['scheduleCode'] as String,
      groomingOptions: List<String>.from(json['groomingOptions'] ?? const []),
      groomingPreferences: List<String>.from(
        json['groomingPreferences'] ?? const [],
      ),
      hasAllergy: json['hasAllergy'] as bool,
      isOnMedication: json['isOnMedication'] as bool,
      hasAntiRabbiesVaccination: json['hasAntiRabbiesVaccination'] as bool,
      paidAmount: json['paidAmount'] as int,
      paymentStatus: json['paymentStatus'] as String,
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'] as int,
      remainingBalance: json['remainingBalance'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'pet': pet,
      'branch': branch,
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
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
      'remainingBalance': remainingBalance,
    };
  }

  @override
  List<Object?> get props => [
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
    id,
    createdAt,
    updatedAt,
    version,
    remainingBalance,
  ];
}
