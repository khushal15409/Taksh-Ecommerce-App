import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/delivery_boy_join_request.dart';

/// Base class for delivery boy events
abstract class DeliveryBoyEvent extends Equatable {
  const DeliveryBoyEvent();

  @override
  List<Object?> get props => [];
}

/// Event to submit delivery boy join request
class DeliveryBoyJoinRequestSubmitted extends DeliveryBoyEvent {
  final DeliveryBoyJoinRequest request;

  const DeliveryBoyJoinRequestSubmitted({required this.request});

  @override
  List<Object?> get props => [request];
}
