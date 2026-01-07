import 'package:equatable/equatable.dart';

class HomeServiceAppointmentRes extends Equatable {
  final String user;
  final String pet;
  final String branch;
  final int totalPrice;
  final String status;
  final HomeServiceSchedule schedule;
  final int paidAmount;
  final String paymentStatus;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final int remainingBalance;

  const HomeServiceAppointmentRes({
    required this.user,
    required this.pet,
    required this.branch,
    required this.totalPrice,
    required this.status,
    required this.schedule,
    required this.paidAmount,
    required this.paymentStatus,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.remainingBalance,
  });

  factory HomeServiceAppointmentRes.fromJson(Map<String, dynamic> json) {
    return HomeServiceAppointmentRes(
      user: json['user'] as String,
      pet: json['pet'] as String,
      branch: json['branch'] as String,
      totalPrice: json['totalPrice'] as int,
      status: json['status'] as String,
      schedule: HomeServiceSchedule.fromJson(json['schedule']),
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
      'schedule': schedule.toJson(),
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
    schedule,
    paidAmount,
    paymentStatus,
    id,
    createdAt,
    updatedAt,
    version,
    remainingBalance,
  ];
}

class HomeServiceSchedule extends Equatable {
  final DateTime date;
  final String time;

  const HomeServiceSchedule({required this.date, required this.time});

  factory HomeServiceSchedule.fromJson(Map<String, dynamic> json) {
    return HomeServiceSchedule(
      date: DateTime.parse(json['date']),
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date.toIso8601String(), 'time': time};
  }

  @override
  List<Object?> get props => [date, time];
}
