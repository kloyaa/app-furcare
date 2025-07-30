import 'package:equatable/equatable.dart';

class DefaultResponse extends Equatable {
  final String message;
  final String code;

  const DefaultResponse({required this.message, required this.code});

  factory DefaultResponse.fromJson(Map<String, dynamic> json) {
    return DefaultResponse(
      message: json['message'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'code': code};
  }

  @override
  List<Object?> get props => [message, code];
}
