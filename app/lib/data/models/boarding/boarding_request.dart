import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/boarding/boarding.dart';

class BoardingAppointmentRequest extends Equatable {
  final String pet;
  final String cage;
  final String branch;
  final BoardingSchedule schedule;
  final String instructions;
  final bool requestAntiRabiesVaccination;

  const BoardingAppointmentRequest({
    required this.pet,
    required this.cage,
    required this.branch,
    required this.schedule,
    required this.instructions,
    required this.requestAntiRabiesVaccination,
  });

  Map<String, dynamic> toJson() {
    return {
      'pet': pet,
      'cage': cage,
      'branch': branch,
      'schedule': schedule.toJson(),
      'instructions': instructions,
      'requestAntiRabiesVaccination': requestAntiRabiesVaccination,
    };
  }

  @override
  List<Object?> get props => [
    pet,
    cage,
    branch,
    schedule,
    instructions,
    requestAntiRabiesVaccination,
  ];
}

class AppointmentExtensionRequest {
  final String application;
  final int count;
  final String type; // Add this field

  AppointmentExtensionRequest({
    required this.application,
    required this.count,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {'application': application, 'count': count, 'type': type};
  }
}
