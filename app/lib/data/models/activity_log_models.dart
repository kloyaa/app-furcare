import 'package:equatable/equatable.dart';

class ActivityLog extends Equatable {
  final String? id;
  final String? user;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  const ActivityLog({
    this.id,
    this.user,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['_id'] as String?,
      user: json['user'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }

  ActivityLog copyWith({
    String? id,
    String? user,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      user: user ?? this.user,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  @override
  List<Object?> get props => [id, user, description, createdAt, updatedAt, v];
}
