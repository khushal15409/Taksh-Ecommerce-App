import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_state.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/address_selection_bottom_sheet.dart';

/// Header widget displaying the current selected address
/// Tapping opens a bottom sheet for address selection
class AddressHeader extends StatelessWidget {
  const AddressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        Address? defaultAddress;
        
        if (state is AddressesLoaded) {
          defaultAddress = state.defaultAddress;
        } else if (state is AddressOperationSuccess) {
          // Find the default address from the addresses list
          defaultAddress = state.addresses.cast<Address?>().firstWhere(
            (address) => address?.isDefault ?? false,
            orElse: () => null,
          );
        }

        return InkWell(
          onTap: () => _showAddressSelectionSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Deliver to',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        defaultAddress != null
                            ? _getAddressLabel(defaultAddress)
                            : 'Select delivery location',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getAddressLabel(Address address) {
    if (address.customLabel != null && address.customLabel!.isNotEmpty) {
      return address.customLabel!;
    }
    return '${address.type.displayName} - ${address.location.shortAddress}';
  }

  void _showAddressSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: context.read<AddressBloc>(),
        child: const AddressSelectionBottomSheet(),
      ),
    );
  }
}
