import 'package:equatable/equatable.dart';

class PetService extends Equatable {
  final String code;
  final String name;
  final String description;
  final bool available;

  const PetService({
    required this.code,
    required this.name,
    required this.description,
    required this.available,
  });

  factory PetService.fromJson(Map<String, dynamic> json) {
    return PetService(
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      available: json['available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'available': available,
    };
  }

  @override
  List<Object?> get props => [code, name, description, available];
}
