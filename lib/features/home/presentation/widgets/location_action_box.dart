import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_event.dart';
import 'package:taksh_e_commerce/features/address/presentation/pages/add_address_page.dart';

/// Box containing location action buttons
/// - Use current location
/// - Add new address
class LocationActionBox extends StatelessWidget {
  const LocationActionBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Use current location
          InkWell(
            onTap: () => _navigateToAddAddressWithCurrentLocation(context),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.my_location,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Use your current location',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Enable location services',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),

          // Add new address
          InkWell(
            onTap: () => _navigateToAddAddress(context),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_location_alt,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add new address',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Enter address manually',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddAddressWithCurrentLocation(BuildContext context) async {
    // Store the bloc reference before closing bottom sheet
    final addressBloc = context.read<AddressBloc>();
    
    // Close bottom sheet first, then navigate
    Navigator.of(context).pop();
    
    // Use Future.microtask to ensure navigation happens after pop completes
    await Future.microtask(() async {
      final result = await Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => const AddAddressPage(
            useCurrentLocation: true,
          ),
        ),
      );
      
      // Reload addresses if address was added
      if (result == true) {
        addressBloc.add(const LoadAddressesEvent());
      }
    });
  }

  void _navigateToAddAddress(BuildContext context) async {
    // Store the bloc reference before closing bottom sheet
    final addressBloc = context.read<AddressBloc>();
    
    // Close bottom sheet first, then navigate
    Navigator.of(context).pop();
    
    // Use Future.microtask to ensure navigation happens after pop completes
    await Future.microtask(() async {
      final result = await Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => const AddAddressPage(),
        ),
      );
      
      // Reload addresses if address was added
      if (result == true) {
        addressBloc.add(const LoadAddressesEvent());
      }
    });
  }
}
