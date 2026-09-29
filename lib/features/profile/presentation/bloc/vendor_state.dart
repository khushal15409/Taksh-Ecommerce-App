import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/vendor_join_response.dart';

/// Base class for vendor states
abstract class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class VendorInitial extends VendorState {
  const VendorInitial();
}

/// Loading state
class VendorLoading extends VendorState {
  const VendorLoading();
}

/// Success state
class VendorJoinRequestSuccess extends VendorState {
  final VendorJoinResponse response;
  final String message;

  const VendorJoinRequestSuccess({
    required this.response,
    required this.message,
  });

  @override
  List<Object?> get props => [response, message];
}

/// Error state
class VendorError extends VendorState {
  final String message;

  const VendorError({required this.message});

  @override
  List<Object?> get props => [message];
}
