import 'package:equatable/equatable.dart';

class AppointmentStatusUpdateRequest extends Equatable {
  final String application;
  final String applicationType;
  final String status;

  const AppointmentStatusUpdateRequest({
    required this.application,
    required this.applicationType,
    required this.status,
  });

  factory AppointmentStatusUpdateRequest.fromJson(Map<String, dynamic> json) {
    return AppointmentStatusUpdateRequest(
      application: json['application'] as String? ?? '',
      applicationType: json['applicationType'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application': application,
      'applicationType': applicationType,
      'status': status,
    };
  }

  AppointmentStatusUpdateRequest copyWith({
    String? application,
    String? applicationType,
    String? status,
  }) {
    return AppointmentStatusUpdateRequest(
      application: application ?? this.application,
      applicationType: applicationType ?? this.applicationType,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [application, applicationType, status];
}
