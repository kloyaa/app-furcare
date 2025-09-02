import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/home_service/home_service.dart';

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
