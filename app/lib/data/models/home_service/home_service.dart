import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/branch_models.dart';
import 'package:furcare_app/data/models/pet_models.dart';

class HomeServiceAppointment extends Equatable {
  final String id;
  final String user;
  final Pet pet;
  final Branch branch;
  final int totalPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final HomeServiceSchedule schedule;

  final int remainingBalance;
  final int paidAmount;
  final String paymentStatus;

  const HomeServiceAppointment({
    required this.id,
    required this.user,
    required this.pet,
    required this.branch,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.schedule,

    required this.remainingBalance,
    required this.paidAmount,
    required this.paymentStatus,
  });

  factory HomeServiceAppointment.fromJson(Map<String, dynamic> json) {
    return HomeServiceAppointment(
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
      totalPrice: json['totalPrice'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      schedule: HomeServiceSchedule.fromJson(json['schedule']),

      remainingBalance: json['remainingBalance'] as int,
      paidAmount: json['paidAmount'] as int,
      paymentStatus: json['paymentStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'pet': pet.toJson(),
      'branch': branch.toJson(),
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'schedule': schedule.toJson(),

      'remainingBalance': remainingBalance,
      'paidAmount': paidAmount,
      'paymentStatus': paymentStatus,
    };
  }

  HomeServiceAppointment copyWith({
    String? id,
    String? user,
    Pet? pet,
    Branch? branch,
    int? totalPrice,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    HomeServiceSchedule? schedule,
  }) {
    return HomeServiceAppointment(
      id: id ?? this.id,
      user: user ?? this.user,
      pet: pet ?? this.pet,
      branch: branch ?? this.branch,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      schedule: schedule ?? this.schedule,

      remainingBalance: remainingBalance,
      paidAmount: paidAmount,
      paymentStatus: paymentStatus,
    );
  }

  @override
  List<Object?> get props => [
    id,
    user,
    pet,
    branch,
    totalPrice,
    status,
    createdAt,
    updatedAt,
    schedule,
  ];
}

class HomeServiceSchedule extends Equatable {
  final String date;
  final String time;

  const HomeServiceSchedule({required this.date, required this.time});

  factory HomeServiceSchedule.fromJson(Map<String, dynamic> json) {
    return HomeServiceSchedule(
      date: json['date'] as String,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'time': time};
  }

  HomeServiceSchedule copyWith({String? date, String? time}) {
    return HomeServiceSchedule(
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }

  @override
  List<Object?> get props => [date, time];
}
