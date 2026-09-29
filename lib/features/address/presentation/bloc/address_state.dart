import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';

/// Base class for all address states
abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AddressInitial extends AddressState {
  const AddressInitial();
}

/// Loading state
class AddressLoading extends AddressState {
  const AddressLoading();
}

/// State when addresses are successfully loaded
class AddressesLoaded extends AddressState {
  final List<Address> addresses;
  final Address? defaultAddress;
  final Address? selectedAddress; // Currently selected for delivery

  const AddressesLoaded({
    required this.addresses,
    this.defaultAddress,
    this.selectedAddress,
  });

  @override
  List<Object?> get props => [addresses, defaultAddress, selectedAddress];

  /// Create with auto-detected default
  factory AddressesLoaded.fromList(
    List<Address> addresses, {
    Address? selectedAddress,
  }) {
    final defaultAddr = addresses.cast<Address?>().firstWhere(
          (address) => address?.isDefault ?? false,
          orElse: () => null,
        );
    return AddressesLoaded(
      addresses: addresses,
      defaultAddress: defaultAddr,
      selectedAddress: selectedAddress ?? defaultAddr,
    );
  }

  /// Create a copy with updated fields
  AddressesLoaded copyWith({
    List<Address>? addresses,
    Address? defaultAddress,
    Address? selectedAddress,
  }) {
    return AddressesLoaded(
      addresses: addresses ?? this.addresses,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }
}

/// State when an operation is successful
class AddressOperationSuccess extends AddressState {
  final String message;
  final List<Address> addresses;
  final Address? selectedAddress;

  const AddressOperationSuccess({
    required this.message,
    required this.addresses,
    this.selectedAddress,
  });

  @override
  List<Object?> get props => [message, addresses, selectedAddress];
}

/// Error state when loading addresses fails (no data to show)
class AddressError extends AddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Error state for failed operations (add/update/delete/setDefault)
/// Preserves the current address list so the UI keeps showing addresses
class AddressOperationError extends AddressState {
  final String message;
  final List<Address> addresses;
  final Address? selectedAddress;

  const AddressOperationError({
    required this.message,
    required this.addresses,
    this.selectedAddress,
  });

  @override
  List<Object?> get props => [message, addresses, selectedAddress];
}
