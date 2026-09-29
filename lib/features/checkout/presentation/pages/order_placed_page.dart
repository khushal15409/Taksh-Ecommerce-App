import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/payment_method_selection.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Page displayed after an order is placed successfully.
/// Shows a back button in the top-left that navigates to the My Orders
/// tab, allowing the user to return to the normal app flow.
class OrderPlacedPage extends StatelessWidget {
  final int orderId;
  final String? orderNumber;
  final String? paymentMethod;

  const OrderPlacedPage({
    super.key,
    required this.orderId,
    this.orderNumber,
    this.paymentMethod,
  });

  bool get _isCod =>
      paymentMethod != null &&
      paymentMethod!.toLowerCase() == PaymentMethodType.cod.value;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Intercept system back so the back gesture/button always returns
      // to the orders tab rather than popping the checkout stack.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _navigateToOrders(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? AppColors.primaryOrange
              : Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Theme.of(context).appBarTheme.foregroundColor,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: AppLocalizations.of(context)!.back,
            onPressed: () => _navigateToOrders(context),
          ),
          title: Text(
            AppLocalizations.of(context)!.orderPlacedTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).brightness == Brightness.light
                ? IndiaGradients.subtleTricolor
                : null,
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).scaffoldBackgroundColor
                : null,
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    _buildSuccessIcon(context),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.thankYouForOrder,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isCod
                          ? AppLocalizations.of(context)!.orderPlacedSubtitle
                          : AppLocalizations.of(context)!
                              .orderPlacedOnlineSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    if (orderNumber != null && orderNumber!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildOrderNumberCard(context, orderNumber!),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToOrders(context),
                        icon: const Icon(Icons.receipt_long),
                        label: Text(
                          AppLocalizations.of(context)!.viewMyOrders,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => context.go(AppRoutes.home),
                        icon: const Icon(Icons.home),
                        label: Text(
                          AppLocalizations.of(context)!.continueShopping,
                        ),
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToOrders(BuildContext context) {
    // Use goNamed with the named route so the bottom-nav highlights Orders.
    context.go(AppRoutes.orders);
  }

  Widget _buildSuccessIcon(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.secondaryGreen,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryGreen.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 60,
      ),
    );
  }

  Widget _buildOrderNumberCard(BuildContext context, String orderNumber) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.orderNumberLabel,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            orderNumber,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryOrange,
                ),
          ),
        ],
      ),
    );
  }
}
