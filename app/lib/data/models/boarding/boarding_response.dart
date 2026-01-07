import 'package:equatable/equatable.dart';

class BoardingAppointmentRes extends Equatable {
  final String user;
  final String pet;
  final String branch;
  final int totalPrice;
  final String status;
  final String cage;
  final Schedule schedule;
  final String instructions;
  final bool requestAntiRabiesVaccination;
  final int paidAmount;
  final String paymentStatus;
  final String id;
  final List<dynamic> extensions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final int extensionDays;
  final int extensionPrice;
  final int remainingBalance;

  const BoardingAppointmentRes({
    required this.user,
    required this.pet,
    required this.branch,
    required this.totalPrice,
    required this.status,
    required this.cage,
    required this.schedule,
    required this.instructions,
    required this.requestAntiRabiesVaccination,
    required this.paidAmount,
    required this.paymentStatus,
    required this.id,
    required this.extensions,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.extensionDays,
    required this.extensionPrice,
    required this.remainingBalance,
  });

  factory BoardingAppointmentRes.fromJson(Map<String, dynamic> json) {
    return BoardingAppointmentRes(
      user: json['user'] as String,
      pet: json['pet'] as String,
      branch: json['branch'] as String,
      totalPrice: json['totalPrice'] as int,
      status: json['status'] as String,
      cage: json['cage'] as String,
      schedule: Schedule.fromJson(json['schedule']),
      instructions: json['instructions'] as String,
      requestAntiRabiesVaccination:
          json['requestAntiRabiesVaccination'] as bool,
      paidAmount: json['paidAmount'] as int,
      paymentStatus: json['paymentStatus'] as String,
      id: json['id'] as String,
      extensions: List<dynamic>.from(json['extensions'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'] as int,
      extensionDays: json['extensionDays'] as int,
      extensionPrice: json['extensionPrice'] as int,
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
      'cage': cage,
      'schedule': schedule.toJson(),
      'instructions': instructions,
      'requestAntiRabiesVaccination': requestAntiRabiesVaccination,
      'paidAmount': paidAmount,
      'paymentStatus': paymentStatus,
      'id': id,
      'extensions': extensions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
      'extensionDays': extensionDays,
      'extensionPrice': extensionPrice,
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
    cage,
    schedule,
    instructions,
    requestAntiRabiesVaccination,
    paidAmount,
    paymentStatus,
    id,
    extensions,
    createdAt,
    updatedAt,
    version,
    extensionDays,
    extensionPrice,
    remainingBalance,
  ];
}

class Schedule extends Equatable {
  final DateTime date;
  final String time;
  final int days;

  const Schedule({required this.date, required this.time, required this.days});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      date: DateTime.parse(json['date']),
      time: json['time'] as String,
      days: json['days'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date.toIso8601String(), 'time': time, 'days': days};
  }

  @override
  List<Object?> get props => [date, time, days];
}
