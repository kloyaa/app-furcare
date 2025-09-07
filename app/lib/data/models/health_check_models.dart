// File: lib/data/models/health_check_models.dart

import 'package:equatable/equatable.dart';

class HealthCheckResponse extends Equatable {
  final bool database;
  final bool isUnderMaintenance;

  const HealthCheckResponse({
    required this.database,
    required this.isUnderMaintenance,
  });

  factory HealthCheckResponse.fromJson(Map<String, dynamic> json) {
    return HealthCheckResponse(
      database: json['database'] ?? false,
      isUnderMaintenance: json['isUnderMaintenance'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'database': database, 'isUnderMaintenance': isUnderMaintenance};
  }

  bool get isHealthy => database && !isUnderMaintenance;

  @override
  List<Object?> get props => [database, isUnderMaintenance];
}
