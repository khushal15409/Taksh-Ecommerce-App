import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

enum DeliveryType {
  quick,
  standard,
  services,
}

/// Delivery type selector with tabs for quick, standard, and services
/// Rendered as three tiles; the selected tile is filled with the brand orange
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
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _buildTile(
          DeliveryType.standard,
          l10n.standardDelivery,
          Icons.shopping_cart_outlined,
        ),
        const SizedBox(width: 10),
        _buildTile(
          DeliveryType.quick,
          l10n.quickDelivery,
          Icons.bolt_outlined,
        ),
        const SizedBox(width: 10),
        _buildTile(
          DeliveryType.services,
          l10n.homeService,
          Icons.home_outlined,
        ),
      ],
    );
  }

  Widget _buildTile(DeliveryType type, String label, IconData icon) {
    final isSelected = selectedDeliveryType == type;
    final foreground = isSelected ? Colors.white : AppColors.grey900;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
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
            constraints: const BoxConstraints(minHeight: 76),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryOrange : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryOrange.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : takshSoftShadow,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: foreground, size: 24),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
