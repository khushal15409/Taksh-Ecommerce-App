import 'package:equatable/equatable.dart';

/// Response entity for delivery boy join request
class DeliveryBoyJoinResponse extends Equatable {
  final int id;
  final String status;
  final String createdAt;

  const DeliveryBoyJoinResponse({
    required this.id,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, status, createdAt];
}
