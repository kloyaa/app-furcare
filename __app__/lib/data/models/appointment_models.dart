import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/data/models/branch_models.dart';
import 'package:flutter_application_1/data/models/pet_models.dart';
import 'package:flutter_application_1/data/models/pet_service.models.dart';

class GroomingAppointmentRequest extends Equatable {
  final String pet;
  final String branch;
  final String scheduleCode;
  final List<String> groomingOptions;
  final List<String> groomingPreferences;
  final bool hasAllergy;
  final bool isOnMedication;
  final bool hasAntiRabbiesVaccination;

  const GroomingAppointmentRequest({
    required this.pet,
    required this.branch,
    required this.scheduleCode,
    required this.groomingOptions,
    required this.groomingPreferences,
    required this.hasAllergy,
    required this.isOnMedication,
    required this.hasAntiRabbiesVaccination,
  });

  Map<String, dynamic> toJson() {
    return {
      'pet': pet,
      'branch': branch,
      'scheduleCode': scheduleCode,
      'groomingOptions': groomingOptions,
      'groomingPreferences': groomingPreferences,
      'hasAllergy': hasAllergy,
      'isOnMedication': isOnMedication,
      'hasAntiRabbiesVaccination': hasAntiRabbiesVaccination,
    };
  }

  @override
  List<Object?> get props => [
    pet,
    branch,
    scheduleCode,
    groomingOptions,
    groomingPreferences,
    hasAllergy,
    isOnMedication,
    hasAntiRabbiesVaccination,
  ];
}

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
  });

  factory GroomingAppointment.fromJson(Map<String, dynamic> json) {
    return GroomingAppointment(
      id: json['_id'],
      user: json['user'],
      pet: Pet.fromJson(json['pet']),
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
  ];
}
