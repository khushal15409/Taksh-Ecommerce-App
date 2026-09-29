import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

enum DeliveryType {
  quick,
  standard,
  services,
}

/// Delivery type selector with tabs for quick, standard, and services
/// Uses Indian flag tricolor theme
class DeliveryTypeSelector extends StatelessWidget {
  final DeliveryType selectedDeliveryType;
  final ValueChanged<DeliveryType> onDeliveryTypeChanged;

  const DeliveryTypeSelector({
    super.key,
    required this.selectedDeliveryType,
    required this.onDeliveryTypeChanged,
  });

  static final _log =
      loggerWithContext({'feature': 'home', 'widget': 'DeliveryTypeSelector'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildDeliveryTab(
            DeliveryType.standard,
            AppLocalizations.of(context)!.standardDelivery.replaceAll(' ', '\n'),
            AppColors.secondaryGreen,
          ),
          const SizedBox(width: 3),
          _buildDeliveryTab(
            DeliveryType.quick,
            AppLocalizations.of(context)!.quickDelivery.replaceAll(' ', '\n'),
            AppColors.primaryOrange,
          ),
          const SizedBox(width: 3),
          _buildDeliveryTab(
            DeliveryType.services,
            AppLocalizations.of(context)!.homeService.replaceAll(' ', '\n'),
            AppColors.primaryOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTab(DeliveryType type, String label, Color accentColor) {
    final isSelected = selectedDeliveryType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onDeliveryTypeChanged(type);
          _log.infoWithContext(
            'Delivery type changed',
            {'type': type.name},
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: accentColor.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? accentColor : Colors.black,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              fontSize: 12,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
