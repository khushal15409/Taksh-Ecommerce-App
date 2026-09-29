import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address_type.dart';

/// A widget to select address type (Home, Work, Other)
class AddressTypeSelector extends StatelessWidget {
  final AddressType selectedType;
  final ValueChanged<AddressType> onTypeSelected;

  const AddressTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AddressTypeChip(
            type: AddressType.home,
            icon: Icons.home,
            label: 'Home',
            isSelected: selectedType == AddressType.home,
            onTap: () => onTypeSelected(AddressType.home),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _AddressTypeChip(
            type: AddressType.work,
            icon: Icons.work,
            label: 'Work',
            isSelected: selectedType == AddressType.work,
            onTap: () => onTypeSelected(AddressType.work),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _AddressTypeChip(
            type: AddressType.other,
            icon: Icons.location_on,
            label: 'Other',
            isSelected: selectedType == AddressType.other,
            onTap: () => onTypeSelected(AddressType.other),
          ),
        ),
      ],
    );
  }
}

class _AddressTypeChip extends StatelessWidget {
  final AddressType type;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressTypeChip({
    required this.type,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  Color _getColor(BuildContext context) {
    if (!isSelected) return Colors.grey;

    switch (type) {
      case AddressType.home:
        return Colors.blue;
      case AddressType.work:
        return Colors.orange;
      case AddressType.other:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
