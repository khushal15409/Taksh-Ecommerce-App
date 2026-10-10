import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';

/// Orange "Fast Delivery in 30 Minutes" call-to-action. Tapping it opens the
/// Quick Delivery mode through [onTap] (the home page's existing mode switch,
/// including its login and address checks).
class QuickDeliveryPromoBanner extends StatelessWidget {
  final VoidCallback onTap;

  const QuickDeliveryPromoBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Semantics(
        button: true,
        label: 'Fast delivery in 30 minutes. Shop now',
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 148,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFC53D), AppColors.primaryOrange],
              ),
              boxShadow: takshSoftShadow,
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -6,
                  bottom: 4,
                  child: SvgPicture.asset(
                    'assets/illustrations/scooter_clock.svg',
                    height: 132,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Fast Delivery\nin 30 Minutes!',
                        style: TextStyle(
                          fontSize: 21,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF3A1D00),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Selected items only',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Shop Now',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.grey900,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: AppColors.grey900,
                            ),
                          ],
                        ),
                      ),
                    ],
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
