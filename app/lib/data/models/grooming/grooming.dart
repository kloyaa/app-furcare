import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/branch_models.dart';
import 'package:furcare_app/data/models/pet_models.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';

class GroomingAppointment extends Equatable {
  final String id;
  final String user;
  final Pet pet;
  final Branch branch;
  final List<GroomingOptions> groomingOptions;
  final List<GroomingPreference> groomingPreferences;
  final bool hasAllergy;
  final bool isOnMedication;
  final bool hasAntiRabbiesVaccination;
  final int totalPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GroomingSchedule schedule;

  final int remainingBalance;
  final int paidAmount;
  final String paymentStatus;

  const GroomingAppointment({
    required this.id,
    required this.user,
    required this.pet,
    required this.branch,
    required this.groomingOptions,
    required this.groomingPreferences,
    required this.hasAllergy,
    required this.isOnMedication,
    required this.hasAntiRabbiesVaccination,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.schedule,

    required this.remainingBalance,
    required this.paidAmount,
    required this.paymentStatus,
  });

  factory GroomingAppointment.fromJson(Map<String, dynamic> json) {
    return GroomingAppointment(
      id: json['_id'],
      user: json['user'],
      pet: json['pet'] != null
          ? Pet.fromJson(json['pet'])
          : Pet(
              gender: 'Unknown',
              id: "",
              name: "Record not found",
              specie: "Unknown",
            ),
      branch: Branch.fromJson(json['branch']),
      groomingOptions: (json['groomingOptions'] as List)
          .map((e) => GroomingOptions.fromJson(e))
          .toList(),
      groomingPreferences: (json['groomingPreferences'] as List)
          .map((e) => GroomingPreference.fromJson(e))
          .toList(),
      hasAllergy: json['hasAllergy'],
      isOnMedication: json['isOnMedication'],
      hasAntiRabbiesVaccination: json['hasAntiRabbiesVaccination'],
      totalPrice: json['totalPrice'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      schedule: GroomingSchedule.fromJson(json['schedule']),

      remainingBalance: json['remainingBalance'] as int,
      paidAmount: json['paidAmount'] as int,
      paymentStatus: json['paymentStatus'] as String,
    );
  }

  @override
  List<Object?> get props => [
    id,
    user,
    pet,
    branch,
    groomingOptions,
    groomingPreferences,
    hasAllergy,
    isOnMedication,
    hasAntiRabbiesVaccination,
    totalPrice,
    status,
    createdAt,
    updatedAt,
    schedule,

    remainingBalance,
    paidAmount,
    paymentStatus,
  ];
}
