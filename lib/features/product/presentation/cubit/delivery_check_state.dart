import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/delivery_availability.dart';

abstract class DeliveryCheckState extends Equatable {
  const DeliveryCheckState();

  @override
  List<Object?> get props => [];
}

/// Initial / idle state — no check performed yet
class DeliveryCheckInitial extends DeliveryCheckState {
  const DeliveryCheckInitial();
}

/// API call in progress
class DeliveryCheckLoading extends DeliveryCheckState {
  const DeliveryCheckLoading();
}

/// Delivery check succeeded
class DeliveryCheckLoaded extends DeliveryCheckState {
  final DeliveryAvailability result;

  const DeliveryCheckLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

/// Delivery check failed (network / server error, invalid pincode, etc.)
class DeliveryCheckError extends DeliveryCheckState {
  final String message;

  const DeliveryCheckError(this.message);

  @override
  List<Object?> get props => [message];
}
