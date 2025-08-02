import 'package:equatable/equatable.dart';

class RequestPet extends Equatable {
  final String name;
  final String specie;
  final String gender;

  const RequestPet({
    required this.name,
    required this.specie,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'specie': specie, 'gender': gender};
  }

  @override
  List<Object?> get props => [name, specie, gender];
}

class UpdatePet extends Equatable {
  final String id;
  final String name;
  final String specie;
  final String gender;

  const UpdatePet({
    required this.id,
    required this.name,
    required this.specie,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'specie': specie, 'gender': gender};
  }

  @override
  List<Object?> get props => [id, name, specie, gender];
}

class Pet extends Equatable {
  final String id;
  final String name;
  final String specie;
  final String gender;

  const Pet({
    required this.id,
    required this.name,
    required this.specie,
    required this.gender,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['_id'] as String,
      name: json['name'] as String,
      specie: json['specie'] as String,
      gender: json['gender'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'specie': specie, 'gender': gender};
  }

  @override
  List<Object?> get props => [id, name, specie, gender];
}
