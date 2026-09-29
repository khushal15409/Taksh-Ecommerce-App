import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';

import '../../../address/domain/entities/address_type.dart';

/// Card widget for displaying an address in the selection list
class AddressSelectionCard extends StatelessWidget {
  final Address address;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressSelectionCard({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.05)
            : Colors.white,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address type icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getAddressIcon(),
                  color: _getIconColor(context),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Address details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address label/type
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _getAddressLabel(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'DEFAULT',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Address line 1
                    Text(
                      address.addressLine1,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Address line 2 (if exists)
                    if (address.addressLine2 != null &&
                        address.addressLine2!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        address.addressLine2!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Location (city, state)
                    const SizedBox(height: 2),
                    Text(
                      address.location.shortAddress,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),

                    // Landmark (if exists)
                    if (address.landmark != null &&
                        address.landmark!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Near ${address.landmark}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Selection indicator
              const SizedBox(width: 8),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAddressLabel() {
    if (address.customLabel != null && address.customLabel!.isNotEmpty) {
      return address.customLabel!;
    }
    return address.type.displayName;
  }

  IconData _getAddressIcon() {
    if (address.type == AddressType.home) {
      return Icons.home;
    } else if (address.type == AddressType.work) {
      return Icons.work;
    } else {
      return Icons.location_on;
    }
  }

  Color _getIconColor(BuildContext context) {
    if (isSelected) {
      return Theme.of(context).primaryColor;
    }
    if (address.type == AddressType.home) {
      return Colors.blue;
    } else if (address.type == AddressType.work) {
      return Colors.orange;
    } else {
      return Colors.purple;
    }
  }

  Color _getIconBackgroundColor(BuildContext context) {
    if (isSelected) {
      return Theme.of(context).primaryColor.withOpacity(0.1);
    }
    if (address.type == AddressType.home) {
      return Colors.blue.withOpacity(0.1);
    } else if (address.type == AddressType.work) {
      return Colors.orange.withOpacity(0.1);
    } else {
      return Colors.purple.withOpacity(0.1);
    }
  }
}
