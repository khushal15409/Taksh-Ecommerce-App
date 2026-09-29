import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';

/// Base class for all address events
abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all addresses
class LoadAddressesEvent extends AddressEvent {
  const LoadAddressesEvent();
}

/// Event to clear in-memory address state, typically on logout.
class ResetAddressesEvent extends AddressEvent {
  const ResetAddressesEvent();
}

/// Event to add a new address
class AddAddressEvent extends AddressEvent {
  final Address address;

  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

/// Event to update an existing address
class UpdateAddressEvent extends AddressEvent {
  final Address address;

  const UpdateAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

/// Event to delete an address
class DeleteAddressEvent extends AddressEvent {
  final String addressId;

  const DeleteAddressEvent(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

/// Event to set an address as default
class SetDefaultAddressEvent extends AddressEvent {
  final String addressId;

  const SetDefaultAddressEvent(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

/// Event to select an address for delivery (UI-only, not persisted)
class SelectAddressForDeliveryEvent extends AddressEvent {
  final Address address;

  const SelectAddressForDeliveryEvent(this.address);

  @override
  List<Object?> get props => [address];
}
