import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_event.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_state.dart';
import 'package:taksh_e_commerce/features/address/presentation/pages/address_list_page.dart';

import '../../domain/entities/address_type.dart';

/// A widget to display and select delivery address on home page
///
/// Usage:
/// ```dart
/// DeliveryAddressSelector(
///   onAddressSelected: (address) {
///     print('Selected: ${address.fullAddress}');
///   },
/// )
/// ```
class DeliveryAddressSelector extends StatelessWidget {
  final ValueChanged<Address>? onAddressSelected;
  final bool showFullAddress;

  const DeliveryAddressSelector({
    super.key,
    this.onAddressSelected,
    this.showFullAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    final addressState = context.read<AddressBloc>().state;
    if (addressState is AddressInitial || addressState is AddressError) {
      context.read<AddressBloc>().add(const LoadAddressesEvent());
    }

    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        if (state is AddressLoading) {
          return _buildLoadingWidget(context);
        }

        if (state is AddressesLoaded) {
          final address = state.selectedAddress ??
              state.defaultAddress ??
              (state.addresses.isNotEmpty ? state.addresses.first : null);

          if (address == null) {
            return _buildNoAddressWidget(context);
          }

          return _buildAddressWidget(context, address);
        }

        if (state is AddressError) {
          return _buildErrorWidget(context);
        }

        return _buildNoAddressWidget(context);
      },
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading address...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildNoAddressWidget(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToAddressList(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_location_alt,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Delivery Address',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to add your delivery location',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressWidget(BuildContext context, Address address) {
    return InkWell(
      onTap: () => _navigateToAddressList(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getAddressIcon(address),
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.displayLabel,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    showFullAddress
                        ? address.fullAddress
                        : address.shortAddress,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                    maxLines: showFullAddress ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToAddressList(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Failed to load address',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red[700],
                    ),
              ),
            ),
            Text(
              'Retry',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAddressIcon(Address address) {
    switch (address.type) {
      case AddressType.home:
        return Icons.home;
      case AddressType.work:
        return Icons.work;
      case AddressType.other:
        return Icons.location_on;
    }
  }

  Future<void> _navigateToAddressList(BuildContext context) async {
    final selectedAddress = await Navigator.of(context).push<Address>(
      MaterialPageRoute(
        builder: (context) => const AddressListPage(
          isSelectionMode: true,
        ),
      ),
    );

    if (selectedAddress != null && onAddressSelected != null) {
      onAddressSelected!(selectedAddress);
    }
  }
}
