import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_event.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_state.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/address_search_bar.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/location_action_box.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/address_selection_card.dart';

/// Bottom sheet for selecting delivery address
class AddressSelectionBottomSheet extends StatefulWidget {
  const AddressSelectionBottomSheet({super.key});

  @override
  State<AddressSelectionBottomSheet> createState() =>
      _AddressSelectionBottomSheetState();
}

class _AddressSelectionBottomSheetState
    extends State<AddressSelectionBottomSheet> {
  String _searchQuery = '';
  List<Address> _filteredAddresses = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Select delivery location',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AddressSearchBar(
                  onSearchChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              ),

              // Location action box
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: LocationActionBox(),
              ),

              // Saved addresses section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      'Your saved addresses',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),

              // Address list
              Expanded(
                child: BlocConsumer<AddressBloc, AddressState>(
                  listener: (context, state) {
                    if (state is AddressOperationSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                      // Close bottom sheet after successful selection
                      Navigator.of(context).pop();
                    }
                  },
                  buildWhen: (previous, current) {
                    // Don't rebuild when AddressOperationSuccess is emitted
                    // as we're closing the bottom sheet anyway
                    return current is! AddressOperationSuccess;
                  },
                  builder: (context, state) {
                    if (state is AddressLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is AddressError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load addresses',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is AddressesLoaded || state is AddressOperationSuccess) {
                      // Get addresses from the appropriate state
                      final addresses = state is AddressesLoaded
                          ? state.addresses
                          : (state as AddressOperationSuccess).addresses;

                      // Filter addresses based on search query
                      _filteredAddresses = _filterAddresses(
                        addresses,
                        _searchQuery,
                      );

                      if (_filteredAddresses.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _searchQuery.isEmpty
                                    ? Icons.location_off_outlined
                                    : Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'No addresses saved'
                                    : 'No addresses found',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'Add your first address to get started'
                                    : 'Try a different search term',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: _filteredAddresses.length,
                        itemBuilder: (context, index) {
                          final address = _filteredAddresses[index];
                          return AddressSelectionCard(
                            address: address,
                            isSelected: address.isDefault,
                            onTap: () {
                              context.read<AddressBloc>().add(
                                    SetDefaultAddressEvent(address.id),
                                  );
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Address> _filterAddresses(List<Address> addresses, String query) {
    if (query.isEmpty) return addresses;

    final lowerQuery = query.toLowerCase();
    return addresses.where((address) {
      final label = address.customLabel?.toLowerCase() ?? '';
      final type = address.type.displayName.toLowerCase();
      final addressLine1 = address.addressLine1.toLowerCase();
      final addressLine2 = address.addressLine2?.toLowerCase() ?? '';
      final landmark = address.landmark?.toLowerCase() ?? '';
      final city = address.location.city?.toLowerCase() ?? '';
      final state = address.location.state?.toLowerCase() ?? '';

      return label.contains(lowerQuery) ||
          type.contains(lowerQuery) ||
          addressLine1.contains(lowerQuery) ||
          addressLine2.contains(lowerQuery) ||
          landmark.contains(lowerQuery) ||
          city.contains(lowerQuery) ||
          state.contains(lowerQuery);
    }).toList();
  }
}
