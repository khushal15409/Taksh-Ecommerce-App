import 'package:equatable/equatable.dart';

/// Response entity for callback request
class CallbackResponse extends Equatable {
  final int id;
  final String name;
  final String mobile;
  final String status;
  final String createdAt;

  const CallbackResponse({
    required this.id,
    required this.name,
    required this.mobile,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, mobile, status, createdAt];
}
