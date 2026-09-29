import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';

/// Widget to display selected address in the home header
class AddressHeaderWidget extends StatelessWidget {
  final Address? selectedAddress;
  final VoidCallback onTap;

  const AddressHeaderWidget({
    super.key,
    this.selectedAddress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: Colors.black,
              size: 16,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          selectedAddress != null
                              ? 'Deliver to'
                              : 'Select Address',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black.withOpacity(0.7),
                        size: 14,
                      ),
                    ],
                  ),
                  if (selectedAddress != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      _getAddressText(selectedAddress!),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else ...[
                    const SizedBox(height: 1),
                    const Text(
                      'Tap to choose',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAddressText(Address address) {
    // Show label and city/area
    final parts = <String>[
      address.displayLabel,
    ];

    if (address.location.city != null && address.location.city!.isNotEmpty) {
      parts.add(address.location.city!);
    } else if (address.addressLine1.isNotEmpty) {
      // Fallback to first line if no city
      final firstLine = address.addressLine1.split(',').first.trim();
      if (firstLine.length <= 20) {
        parts.add(firstLine);
      }
    }

    return parts.join(' - ');
  }
}
