import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
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
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: AppColors.primaryOrange,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedAddress != null ? 'Deliver to' : 'Select Address',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          selectedAddress != null
                              ? _getAddressText(selectedAddress!)
                              : 'Tap to choose',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                        size: 18,
                      ),
                    ],
                  ),
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
