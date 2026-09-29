import 'package:equatable/equatable.dart';

/// Fulfillment center entity
class FulfillmentCenter extends Equatable {
  final int id;
  final String name;

  const FulfillmentCenter({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  /// Create a copy with updated fields
  FulfillmentCenter copyWith({
    int? id,
    String? name,
  }) {
    return FulfillmentCenter(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
