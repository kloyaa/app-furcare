import 'package:equatable/equatable.dart';

class Branch extends Equatable {
  final String id;
  final String name;
  final String address;
  final String phone;
  final bool open;
  final int v;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.open,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      open: json['open'] as bool,
      v: json['__v'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'open': open,
      '__v': v,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    phone,
    open,
    v,
    createdAt,
    updatedAt,
  ];
}
