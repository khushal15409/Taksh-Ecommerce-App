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
/// Rendered as three colorful tiles; the selected tile is tinted and outlined
/// in its own color
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

  static const _standardColors = [Color(0xFF5CDB7A), Color(0xFF1FA34A)];
  static const _quickColors = [Color(0xFFFFC53D), Color(0xFFFF6A00)];
  static const _servicesColors = [Color(0xFF56B4FF), Color(0xFF6B5BFF)];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _buildTile(
          DeliveryType.standard,
          l10n.standardDelivery,
          Icons.shopping_basket_rounded,
          _standardColors,
        ),
        const SizedBox(width: 10),
        _buildTile(
          DeliveryType.quick,
          l10n.quickDelivery,
          Icons.bolt_rounded,
          _quickColors,
        ),
        const SizedBox(width: 10),
        _buildTile(
          DeliveryType.services,
          l10n.homeService,
          Icons.home_repair_service_rounded,
          _servicesColors,
        ),
      ],
    );
  }

  Widget _buildTile(
    DeliveryType type,
    String label,
    IconData icon,
    List<Color> colors,
  ) {
    final isSelected = selectedDeliveryType == type;
    final accent = colors.last;

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
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            constraints: const BoxConstraints(minHeight: 84),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? accent : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: accent.withOpacity(0.30),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : takshSoftShadow,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: colors,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? accent : AppColors.grey900,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
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
