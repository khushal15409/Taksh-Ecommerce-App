import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/widgets/animated_taksh_logo.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/address_header_widget.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/delivery_type_selector.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Home page header: logo + delivery address + notifications, search bar and
/// the three delivery-mode tiles. Scrolls with the page content.
class HomeHeader extends StatelessWidget {
  // Same Taksh logo as image.png, with the white background made transparent.
  static const String _homeLogoAssetPath =
      'assets/images/taksh_logo_transparent.png';
  static final _log = loggerWithContext({
    'feature': 'home',
    'widget': 'HomeHeader',
  });

  final DeliveryType selectedDeliveryType;
  final ValueChanged<DeliveryType> onDeliveryTypeChanged;
  final Address? selectedAddress;
  final VoidCallback onAddressTap;

  const HomeHeader({
    super.key,
    required this.selectedDeliveryType,
    required this.onDeliveryTypeChanged,
    this.selectedAddress,
    required this.onAddressTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverToBoxAdapter(
      // Transparent: the page-level TakshSoftBackground shows through.
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, topPadding + 8, 16, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildLogo(),
                const SizedBox(width: 10),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AddressHeaderWidget(
                      selectedAddress: selectedAddress,
                      onTap: onAddressTap,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildNotificationButton(),
              ],
            ),
            // The product search bar is hidden in Home Service mode, where the
            // services list has its own search field.
            if (selectedDeliveryType != DeliveryType.services) ...[
              const SizedBox(height: 14),
              TakshSearchBar(
                hint: AppLocalizations.of(context)!.searchHint,
                onTap: () {
                  _log.infoWithContext('Search bar tapped', {
                    'action': 'user_action',
                  });
                  context.push(AppRoutes.search);
                },
              ),
            ],
            const SizedBox(height: 14),
            DeliveryTypeSelector(
              selectedDeliveryType: selectedDeliveryType,
              onDeliveryTypeChanged: onDeliveryTypeChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const AnimatedTakshLogo(
      asset: _homeLogoAssetPath,
      width: 108,
      height: 66,
      fallback: Center(
        child: Text(
          'Taksh',
          style: TextStyle(
            color: AppColors.secondaryGreen,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Semantics(
      button: true,
      label: 'Notifications',
      child: GestureDetector(
        onTap: () {
          _log.infoWithContext('Notification button tapped', {
            'action': 'user_action',
          });
        },
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: takshSoftShadow,
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.grey900,
            size: 24,
          ),
        ),
      ),
    );
  }
}
