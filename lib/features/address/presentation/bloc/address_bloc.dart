import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/add_address.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/delete_address.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/get_addresses.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/set_default_address.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/update_address.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_event.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_state.dart';

import '../../domain/entities/address.dart';

/// BLoC for managing address operations
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddresses _getAddresses;
  final AddAddress _addAddress;
  final UpdateAddress _updateAddress;
  final DeleteAddress _deleteAddress;
  final SetDefaultAddress _setDefaultAddress;

  AddressBloc({
    required GetAddresses getAddresses,
    required AddAddress addAddress,
    required UpdateAddress updateAddress,
    required DeleteAddress deleteAddress,
    required SetDefaultAddress setDefaultAddress,
  }) : _getAddresses = getAddresses,
       _addAddress = addAddress,
       _updateAddress = updateAddress,
       _deleteAddress = deleteAddress,
       _setDefaultAddress = setDefaultAddress,
       super(const AddressInitial()) {
    on<LoadAddressesEvent>(_onLoadAddresses);
     on<ResetAddressesEvent>(_onResetAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
    on<SelectAddressForDeliveryEvent>(_onSelectAddressForDelivery);
  }

  final _log = loggerWithContext({
    'feature': 'address',
    'layer': 'presentation',
    'class': 'AddressBloc',
  });

  /// Helper to extract current addresses and selected address from any state
  (List<Address>, Address?) _currentAddressesFromState() {
    final currentState = state;
    if (currentState is AddressesLoaded) {
      return (currentState.addresses, currentState.selectedAddress);
    } else if (currentState is AddressOperationSuccess) {
      return (currentState.addresses, currentState.selectedAddress);
    } else if (currentState is AddressOperationError) {
      return (currentState.addresses, currentState.selectedAddress);
    }
    return (<Address>[], null);
  }

  Address? _findDefaultAddress(List<Address> addresses) {
    for (final address in addresses) {
      if (address.isDefault) {
        return address;
      }
    }
    return null;
  }

  Address? _resolveSelectedAddress({
    required List<Address> addresses,
    Address? currentSelectedAddress,
  }) {
    if (addresses.isEmpty) {
      return null;
    }

    if (currentSelectedAddress != null) {
      for (final address in addresses) {
        if (address.id == currentSelectedAddress.id) {
          return address;
        }
      }
    }

    return _findDefaultAddress(addresses) ?? addresses.first;
  }

  void _onResetAddresses(
    ResetAddressesEvent event,
    Emitter<AddressState> emit,
  ) {
    _log.infoWithContext('Resetting address state', {'action': 'reset'});
    emit(const AddressInitial());
  }

  /// Handle load addresses event
  Future<void> _onLoadAddresses(
    LoadAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    final startTime = DateTime.now();
    final (_, currentSelectedAddress) = _currentAddressesFromState();
    _log.infoWithContext('Loading addresses', {'action': 'load_start'});

    emit(const AddressLoading());

    final result = await _getAddresses();

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to load addresses', {
          'error': failure.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        });
        emit(AddressError(failure.message));
      },
      (addresses) {
        _log.infoWithContext('Addresses loaded successfully', {
          'count': addresses.length,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        });
        emit(
          AddressesLoaded.fromList(
            addresses,
            selectedAddress: _resolveSelectedAddress(
              addresses: addresses,
              currentSelectedAddress: currentSelectedAddress,
            ),
          ),
        );
      },
    );
  }

  /// Handle add address event
  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    final startTime = DateTime.now();
    _log.infoWithContext('Adding new address', {'action': 'add_start'});

    // Get current addresses from state
    final (currentAddresses, currentSelectedAddress) =
        _currentAddressesFromState();

    emit(const AddressLoading());

    final result = await _addAddress(event.address);

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to add address', {
          'error': failure.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        });
        emit(AddressOperationError(
          message: failure.message,
          addresses: currentAddresses,
          selectedAddress: currentSelectedAddress,
        ));
      },
      (newAddress) {
        _log.infoWithContext('Address added successfully', {
          'address_id': newAddress.id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        });

        // Update local copy with new address
        final updatedAddresses = [...currentAddresses, newAddress];

        emit(
          AddressOperationSuccess(
            message: 'Address added successfully',
            addresses: updatedAddresses,
            selectedAddress: currentSelectedAddress,
          ),
        );
      },
    );
  }

  /// Handle update address event
  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    final startTime = DateTime.now();
    _log.infoWithContext('Updating address', {
      'action': 'update_start',
      'address_id': event.address.id,
    });

    // Get current addresses from state
    final (currentAddresses, currentSelectedAddress) =
        _currentAddressesFromState();

    emit(const AddressLoading());

    final result = await _updateAddress(event.address);

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to update address', {
          'error': failure.message,
          'address_id': event.address.id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        });
        emit(AddressOperationError(
          message: failure.message,
          addresses: currentAddresses,
          selectedAddress: currentSelectedAddress,
        ));
      },
      (updatedAddress) {
        _log.infoWithContext('Address updated successfully', {
          'address_id': updatedAddress.id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        });

        // Update local copy by replacing the updated address
        final updatedAddresses = currentAddresses.map((addr) {
          return addr.id == updatedAddress.id ? updatedAddress : addr;
        }).toList();

        // Update selectedAddress if it was the one updated
        final updatedSelectedAddress =
            currentSelectedAddress?.id == updatedAddress.id
            ? updatedAddress
            : currentSelectedAddress;

        emit(
          AddressOperationSuccess(
            message: 'Address updated successfully',
            addresses: updatedAddresses,
            selectedAddress: updatedSelectedAddress,
          ),
        );
      },
    );
  }

  /// Handle delete address event
  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    final startTime = DateTime.now();
    _log.infoWithContext('Deleting address', {
      'action': 'delete_start',
      'address_id': event.addressId,
    });

    // Get current addresses from state
    final (currentAddresses, currentSelectedAddress) =
        _currentAddressesFromState();

    emit(const AddressLoading());

    final result = await _deleteAddress(event.addressId);

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to delete address', {
          'error': failure.message,
          'address_id': event.addressId,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        });
        emit(AddressOperationError(
          message: failure.message,
          addresses: currentAddresses,
          selectedAddress: currentSelectedAddress,
        ));
      },
      (_) {
        _log.infoWithContext('Address deleted successfully', {
          'address_id': event.addressId,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        });

        // Update local copy by removing the deleted address
        final updatedAddresses = currentAddresses
            .where((addr) => addr.id != event.addressId)
            .toList();

        // Clear selectedAddress if it was deleted
        final updatedSelectedAddress =
            currentSelectedAddress?.id == event.addressId
            ? null
            : currentSelectedAddress;

        emit(
          AddressOperationSuccess(
            message: 'Address deleted successfully',
            addresses: updatedAddresses,
            selectedAddress: updatedSelectedAddress,
          ),
        );
      },
    );
  }

  /// Handle set default address event
  Future<void> _onSetDefaultAddress(
    SetDefaultAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    final startTime = DateTime.now();
    _log.infoWithContext('Setting default address', {
      'action': 'set_default_start',
      'address_id': event.addressId,
    });

    // Get current addresses from state
    final (currentAddresses, currentSelectedAddress) =
        _currentAddressesFromState();
  final previousDefaultAddress = _findDefaultAddress(currentAddresses);

    emit(const AddressLoading());

    final result = await _setDefaultAddress(event.addressId);

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to set default address', {
          'error': failure.message,
          'address_id': event.addressId,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        });
        emit(AddressOperationError(
          message: failure.message,
          addresses: currentAddresses,
          selectedAddress: currentSelectedAddress,
        ));
      },
      (defaultAddress) {
        _log.infoWithContext('Default address set successfully', {
          'address_id': defaultAddress.id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        });

        // Update local copy by setting the new default and unsetting others
        final updatedAddresses = currentAddresses.map((addr) {
          if (addr.id == event.addressId) {
            return defaultAddress;
          } else if (addr.isDefault) {
            // Unset previous default
            return addr.copyWith(isDefault: false);
          }
          return addr;
        }).toList();

        final shouldFollowDefault =
            currentSelectedAddress == null ||
            currentSelectedAddress.id == previousDefaultAddress?.id ||
            currentSelectedAddress.id == defaultAddress.id;

        final updatedSelectedAddress = shouldFollowDefault
            ? defaultAddress
            : _resolveSelectedAddress(
                addresses: updatedAddresses,
                currentSelectedAddress: currentSelectedAddress,
              );

        emit(
          AddressOperationSuccess(
            message: 'Default address updated',
            addresses: updatedAddresses,
            selectedAddress: updatedSelectedAddress,
          ),
        );
      },
    );
  }

  /// Handle select address for delivery event
  void _onSelectAddressForDelivery(
    SelectAddressForDeliveryEvent event,
    Emitter<AddressState> emit,
  ) {
    _log.infoWithContext('Address selected for delivery', {
      'address_id': event.address.id,
      'address_label': event.address.displayLabel,
    });

    final (currentAddresses, _) = _currentAddressesFromState();
    if (currentAddresses.isNotEmpty) {
      emit(
        AddressesLoaded.fromList(
          currentAddresses,
          selectedAddress: _resolveSelectedAddress(
            addresses: currentAddresses,
            currentSelectedAddress: event.address,
          ),
        ),
      );
    }
  }
}
