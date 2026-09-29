import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/vendor_join_request.dart';

/// Base class for vendor events
abstract class VendorEvent extends Equatable {
  const VendorEvent();

  @override
  List<Object?> get props => [];
}

/// Event to submit vendor join request
class VendorJoinRequestSubmitted extends VendorEvent {
  final VendorJoinRequest request;

  const VendorJoinRequestSubmitted({required this.request});

  @override
  List<Object?> get props => [request];
}
