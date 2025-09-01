import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/branch_models.dart';
import 'package:furcare_app/data/models/pet_models.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';

class HomeServiceAppointmentRequest extends Equatable {
  final String pet;
  final String branch;
  final HomeServiceSchedule schedule;

  const HomeServiceAppointmentRequest({
    required this.pet,
    required this.branch,
    required this.schedule,
  });

  Map<String, dynamic> toJson() {
    return {'pet': pet, 'branch': branch, 'schedule': schedule.toJson()};
  }

  @override
  List<Object?> get props => [pet, branch, schedule];
}

class GroomingAppointmentRequest extends Equatable {
  final String pet;
  final String branch;
  final String scheduleCode;
  final List<String> groomingOptions;
  final List<String> groomingPreferences;
  final bool hasAllergy;
  final bool isOnMedication;
  final bool hasAntiRabbiesVaccination;

  const GroomingAppointmentRequest({
    required this.pet,
    required this.branch,
    required this.scheduleCode,
    required this.groomingOptions,
    required this.groomingPreferences,
    required this.hasAllergy,
    required this.isOnMedication,
    required this.hasAntiRabbiesVaccination,
  });

  Map<String, dynamic> toJson() {
    return {
      'pet': pet,
      'branch': branch,
      'scheduleCode': scheduleCode,
      'groomingOptions': groomingOptions,
      'groomingPreferences': groomingPreferences,
      'hasAllergy': hasAllergy,
      'isOnMedication': isOnMedication,
      'hasAntiRabbiesVaccination': hasAntiRabbiesVaccination,
    };
  }

  @override
  List<Object?> get props => [
    pet,
    branch,
    scheduleCode,
    groomingOptions,
    groomingPreferences,
    hasAllergy,
    isOnMedication,
    hasAntiRabbiesVaccination,
  ];
}

class BoardingAppointmentRequest extends Equatable {
  final String pet;
  final String cage;
  final String branch;
  final BoardingSchedule schedule;
  final String instructions;
  final bool requestAntiRabiesVaccination;

  const BoardingAppointmentRequest({
    required this.pet,
    required this.cage,
    required this.branch,
    required this.schedule,
    required this.instructions,
    required this.requestAntiRabiesVaccination,
  });

  Map<String, dynamic> toJson() {
    return {
      'pet': pet,
      'cage': cage,
      'branch': branch,
      'schedule': schedule.toJson(),
      'instructions': instructions,
      'requestAntiRabiesVaccination': requestAntiRabiesVaccination,
    };
  }

  @override
  List<Object?> get props => [
    pet,
    cage,
    branch,
    schedule,
    instructions,
    requestAntiRabiesVaccination,
  ];
}

class AppointmentExtensionRequest {
  final String application;
  final int count;
  final String type; // Add this field

  AppointmentExtensionRequest({
    required this.application,
    required this.count,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {'application': application, 'count': count, 'type': type};
  }
}

class BoardingSchedule extends Equatable {
  final String date;
  final String time;
  final int days;
  final int? originalDays;

  const BoardingSchedule({
    required this.date,
    required this.time,
    required this.days,
    this.originalDays,
  });

  factory BoardingSchedule.fromJson(Map<String, dynamic> json) {
    return BoardingSchedule(
      date: json['date'] as String,
      time: json['time'] as String,
      days: json['days'] as int,
      originalDays: json['originalDays'] as int?, // This is correct
    );
  }
  Map<String, dynamic> toJson() {
    final map = {'date': date, 'time': time, 'days': days};

    if (originalDays != null) {
      map['originalDays'] = originalDays!;
    }

    return map;
  }

  Map<String, dynamic> toHomeServiceJson() {
    final map = {'date': date, 'time': time};
    return map;
  }

  @override
  List<Object?> get props => [date, time, days, originalDays];
}

class GroomingAppointment extends Equatable {
  final String id;
  final String user;
  final Pet pet;
  final Branch branch;
  final List<GroomingOptions> groomingOptions;
  final List<GroomingPreference> groomingPreferences;
  final bool hasAllergy;
  final bool isOnMedication;
  final bool hasAntiRabbiesVaccination;
  final int totalPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GroomingSchedule schedule;

  const GroomingAppointment({
    required this.id,
    required this.user,
    required this.pet,
    required this.branch,
    required this.groomingOptions,
    required this.groomingPreferences,
    required this.hasAllergy,
    required this.isOnMedication,
    required this.hasAntiRabbiesVaccination,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.schedule,
  });

  factory GroomingAppointment.fromJson(Map<String, dynamic> json) {
    return GroomingAppointment(
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
      groomingOptions: (json['groomingOptions'] as List)
          .map((e) => GroomingOptions.fromJson(e))
          .toList(),
      groomingPreferences: (json['groomingPreferences'] as List)
          .map((e) => GroomingPreference.fromJson(e))
          .toList(),
      hasAllergy: json['hasAllergy'],
      isOnMedication: json['isOnMedication'],
      hasAntiRabbiesVaccination: json['hasAntiRabbiesVaccination'],
      totalPrice: json['totalPrice'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      schedule: GroomingSchedule.fromJson(json['schedule']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    user,
    pet,
    branch,
    groomingOptions,
    groomingPreferences,
    hasAllergy,
    isOnMedication,
    hasAntiRabbiesVaccination,
    totalPrice,
    status,
    createdAt,
    updatedAt,
    schedule,
  ];
}

class BoardingAppointment extends Equatable {
  final String id;
  final String user;
  final Pet pet;
  final Branch branch;
  final PetCage cage;
  final String instructions;
  final int totalPrice;
  final int originalPrice;
  final int extensionDays;
  final int extensionPrice;
  final bool requestAntiRabiesVaccination;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final BoardingSchedule schedule;
  final List<BoardingExtension> extensions;

  const BoardingAppointment({
    required this.id,
    required this.user,
    required this.pet,
    required this.branch,
    required this.cage,
    required this.instructions,
    required this.totalPrice,
    required this.originalPrice,
    required this.extensionDays,
    required this.extensionPrice,
    required this.requestAntiRabiesVaccination,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.schedule,
    required this.extensions,
  });

  factory BoardingAppointment.fromJson(Map<String, dynamic> json) {
    return BoardingAppointment(
      id: json['_id'] as String? ?? json['id'] as String,
      user: json['user'] as String,
      pet: json['pet'] != null
          ? Pet.fromJson(json['pet'] as Map<String, dynamic>)
          : const Pet(
              id: "",
              name: "Record not found",
              specie: "Unknown",
              gender: "Unknown",
            ),
      branch: Branch.fromJson(json['branch'] as Map<String, dynamic>),
      cage: PetCage.fromJson(json['cage'] as Map<String, dynamic>),
      instructions: json['instructions'] as String? ?? '',
      totalPrice: json['totalPrice'] as int,
      originalPrice:
          json['originalPrice'] as int? ??
          json['totalPrice'] as int, // Fix here
      extensionDays: json['extensionDays'] as int? ?? 0,
      extensionPrice: json['extensionPrice'] as int? ?? 0,
      requestAntiRabiesVaccination:
          json['requestAntiRabiesVaccination'] as bool? ?? false,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      schedule: BoardingSchedule.fromJson(
        json['schedule'] as Map<String, dynamic>,
      ),
      extensions:
          (json['extensions'] as List<dynamic>?)
              ?.map(
                (e) => BoardingExtension.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'pet': pet.toJson(),
      'branch': branch.toJson(),
      'cage': cage.toJson(),
      'instructions': instructions,
      'totalPrice': totalPrice,
      'originalPrice': originalPrice,
      'extensionDays': extensionDays,
      'extensionPrice': extensionPrice,
      'requestAntiRabiesVaccination': requestAntiRabiesVaccination,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'schedule': schedule.toJson(),
      'extensions': extensions.map((e) => e.toJson()).toList(),
    };
  }

  // Helper methods
  int get currentExtensionDays => extensionDays;

  bool get hasExtensions => extensions.isNotEmpty;

  BoardingExtension? get lastExtension =>
      extensions.isNotEmpty ? extensions.last : null;

  BoardingAppointment copyWith({
    String? id,
    String? user,
    Pet? pet,
    Branch? branch,
    PetCage? cage,
    String? instructions,
    int? totalPrice,
    int? originalPrice,
    int? extensionDays,
    int? extensionPrice,
    bool? requestAntiRabiesVaccination,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    BoardingSchedule? schedule,
    List<BoardingExtension>? extensions,
  }) {
    return BoardingAppointment(
      id: id ?? this.id,
      user: user ?? this.user,
      pet: pet ?? this.pet,
      branch: branch ?? this.branch,
      cage: cage ?? this.cage,
      instructions: instructions ?? this.instructions,
      totalPrice: totalPrice ?? this.totalPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      extensionDays: extensionDays ?? this.extensionDays,
      extensionPrice: extensionPrice ?? this.extensionPrice,
      requestAntiRabiesVaccination:
          requestAntiRabiesVaccination ?? this.requestAntiRabiesVaccination,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      schedule: schedule ?? this.schedule,
      extensions: extensions ?? this.extensions,
    );
  }

  @override
  List<Object?> get props => [
    id,
    user,
    pet,
    branch,
    cage,
    instructions,
    totalPrice,
    originalPrice,
    extensionDays,
    extensionPrice,
    requestAntiRabiesVaccination,
    status,
    createdAt,
    updatedAt,
    schedule,
    extensions,
  ];
}

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

class BoardingExtension extends Equatable {
  final String id;
  final String type; // 'add' or 'minus'
  final int days;
  final int priceChange;
  final DateTime timestamp;
  final String user;

  const BoardingExtension({
    required this.id,
    required this.type,
    required this.days,
    required this.priceChange,
    required this.timestamp,
    required this.user,
  });

  factory BoardingExtension.fromJson(Map<String, dynamic> json) {
    return BoardingExtension(
      id: json['_id'] as String,
      type: json['type'] as String,
      days: json['days'] as int,
      priceChange: json['priceChange'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      user: json['user'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'days': days,
      'priceChange': priceChange,
      'timestamp': timestamp.toIso8601String(),
      'user': user,
    };
  }

  @override
  List<Object?> get props => [id, type, days, priceChange, timestamp, user];
}
