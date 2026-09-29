import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/delivery_boy_join_response.dart';

/// Base class for delivery boy states
abstract class DeliveryBoyState extends Equatable {
  const DeliveryBoyState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DeliveryBoyInitial extends DeliveryBoyState {
  const DeliveryBoyInitial();
}

/// Loading state
class DeliveryBoyLoading extends DeliveryBoyState {
  const DeliveryBoyLoading();
}

/// Success state
class DeliveryBoyJoinRequestSuccess extends DeliveryBoyState {
  final DeliveryBoyJoinResponse response;
  final String message;

  const DeliveryBoyJoinRequestSuccess({
    required this.response,
    required this.message,
  });

  @override
  List<Object?> get props => [response, message];
}

/// Error state
class DeliveryBoyError extends DeliveryBoyState {
  final String message;

  const DeliveryBoyError({required this.message});

  @override
  List<Object?> get props => [message];
}
