import 'package:equatable/equatable.dart';

class MaintenanceInfo extends Equatable {
  final bool value;
  final String message;

  const MaintenanceInfo({required this.value, required this.message});

  factory MaintenanceInfo.fromJson(Map<String, dynamic> json) {
    return MaintenanceInfo(
      value: json['value'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'message': message};
  }

  @override
  List<Object?> get props => [value, message];
}

class HealthCheckResponse extends Equatable {
  final bool database;
  final MaintenanceInfo maintenance;

  const HealthCheckResponse({
    required this.database,
    required this.maintenance,
  });

  factory HealthCheckResponse.fromJson(Map<String, dynamic> json) {
    return HealthCheckResponse(
      database: json['database'] ?? false,
      maintenance: json['maintenance'] != null
          ? MaintenanceInfo.fromJson(json['maintenance'])
          : const MaintenanceInfo(value: false, message: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {'database': database, 'maintenance': maintenance.toJson()};
  }

  bool get isHealthy => database && !maintenance.value;

  @override
  List<Object?> get props => [database, maintenance];
}
