import 'package:equatable/equatable.dart';

/// Response entity for development request
class DevelopmentResponse extends Equatable {
  final int id;
  final String requestType;
  final String mobile;
  final String email;
  final String status;
  final String createdAt;

  const DevelopmentResponse({
    required this.id,
    required this.requestType,
    required this.mobile,
    required this.email,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, requestType, mobile, email, status, createdAt];
}
