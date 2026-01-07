import 'package:equatable/equatable.dart';

class RequestPet extends Equatable {
  final String name;
  final String specie;
  final String gender;
  final String size;

  const RequestPet({
    required this.name,
    required this.specie,
    required this.gender,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'specie': specie, 'gender': gender, 'size': size};
  }

  @override
  List<Object?> get props => [name, specie, gender, size];
}

class UpdatePet extends Equatable {
  final String id;
  final String name;
  final String specie;
  final String gender;
  final String size;

  const UpdatePet({
    required this.id,
    required this.name,
    required this.specie,
    required this.gender,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'specie': specie, 'gender': gender, 'size': size};
  }

  @override
  List<Object?> get props => [id, name, specie, gender, size];
}

class Pet extends Equatable {
  final String id;
  final String name;
  final String specie;
  final String gender;
  final String size;

  const Pet({
    required this.id,
    required this.name,
    required this.specie,
    required this.gender,
    required this.size,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['_id'] as String,
      name: json['name'] as String,
      specie: json['specie'] as String,
      gender: json['gender'] as String,
      size: json['size'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'specie': specie,
      'gender': gender,
      'size': size,
    };
  }

  @override
  List<Object?> get props => [id, name, specie, gender, size];
}
