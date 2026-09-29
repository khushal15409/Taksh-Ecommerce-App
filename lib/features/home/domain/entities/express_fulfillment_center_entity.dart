import 'package:equatable/equatable.dart';

/// Fulfillment center entity for express dashboard
class ExpressFulfillmentCenterEntity extends Equatable {
  final int id;
  final String name;

  const ExpressFulfillmentCenterEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
