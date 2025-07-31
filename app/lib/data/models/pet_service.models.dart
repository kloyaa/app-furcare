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

class GroomingSchedule extends Equatable {
  final String code;
  final String schedule;
  final int price;
  final bool available;

  const GroomingSchedule({
    required this.code,
    required this.schedule,
    required this.price,
    required this.available,
  });

  factory GroomingSchedule.fromJson(Map<String, dynamic> json) {
    return GroomingSchedule(
      code: json['code'] as String,
      schedule: json['schedule'] as String,
      price: json['price'] as int,
      available: json['available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'schedule': schedule,
      'price': price,
      'available': available,
    };
  }

  @override
  List<Object?> get props => [code, schedule, price, available];
}

class GroomingOptions extends Equatable {
  final String code;
  final String name;
  final int price;
  final bool available;

  const GroomingOptions({
    required this.code,
    required this.name,
    required this.price,
    required this.available,
  });

  factory GroomingOptions.fromJson(Map<String, dynamic> json) {
    return GroomingOptions(
      code: json['code'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      available: json['available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'price': price, 'available': available};
  }

  @override
  List<Object?> get props => [code, name, price, available];
}

class GroomingPreference extends Equatable {
  final String code;
  final String name;
  final int price;
  final bool available;

  const GroomingPreference({
    required this.code,
    required this.name,
    required this.price,
    required this.available,
  });

  factory GroomingPreference.fromJson(Map<String, dynamic> json) {
    return GroomingPreference(
      code: json['code'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      available: json['available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'price': price, 'available': available};
  }

  @override
  List<Object?> get props => [code, name, price, available];
}

class PetCage extends Equatable {
  final String id;
  final int price;
  final String size;
  final int occupant;
  final int max;

  const PetCage({
    required this.id,
    required this.price,
    required this.size,
    required this.occupant,
    required this.max,
  });

  factory PetCage.fromJson(Map<String, dynamic> json) {
    return PetCage(
      id: json['_id'] as String,
      price: json['price'] as int,
      size: json['size'] as String,
      occupant: json['occupant'] as int,
      max: json['max'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'size': size,
      'occupant': occupant,
      'max': max,
      '_id': id,
    };
  }

  @override
  List<Object?> get props => [price, size, occupant, max, id];
}
