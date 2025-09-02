import 'package:equatable/equatable.dart';

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
