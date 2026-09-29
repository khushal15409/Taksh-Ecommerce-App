import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/delivery_option.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/payment_method_selection.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/price_breakdown.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/widgets/checkout_item_card.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Immutable snapshot of the checkout data used by the review page.
///
/// The page does not read directly from [CheckoutBloc]; it consumes a
/// pre-computed snapshot so it can be pushed on top of the checkout page
/// via [Navigator] (sharing the bloc for state changes only).
class OrderReviewData {
  final List<CartItem> items;
  final Address? address;
  final DeliveryOption deliveryOption;
  final PriceBreakdown priceBreakdown;
  final PaymentMethodSelection paymentMethod;
  final List<ExtraCharge> extraCharges;

  const OrderReviewData({
    required this.items,
    required this.address,
    required this.deliveryOption,
    required this.priceBreakdown,
    required this.paymentMethod,
    required this.extraCharges,
  });
}

/// Page for reviewing order details before confirming the order.
///
/// Pushed on top of the checkout page via [Navigator]. Reads
/// processing state from the shared [CheckoutBloc]; navigation after
/// order placement is handled by the parent checkout page listener.
class OrderReviewPage extends StatefulWidget {
  final OrderReviewData data;

  const OrderReviewPage({super.key, required this.data});

  @override
  State<OrderReviewPage> createState() => _OrderReviewPageState();
}

class _OrderReviewPageState extends State<OrderReviewPage> {
  void _handleBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go(AppRoutes.checkout);
    }
  }

  void _handleConfirm() {
    final state = context.read<CheckoutBloc>().state;
    if (state is! CheckoutCalculated) {
      return;
    }
    context.read<CheckoutBloc>().add(const PlaceOrderEvent());
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orderReview),
        centerTitle: false,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.primaryOrange
            : Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).appBarTheme.foregroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDescriptionCard(context),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: AppLocalizations.of(context)!.deliveryAddress,
                      icon: Icons.location_on_outlined,
                      child: _buildAddress(context, data.address),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: AppLocalizations.of(context)!.deliveryType,
                      icon: Icons.local_shipping_outlined,
                      child: _buildDelivery(context, data.deliveryOption),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: AppLocalizations.of(context)!.itemsCount(
                        data.items.length,
                      ),
                      icon: Icons.shopping_bag_outlined,
                      child: _buildItems(context, data.items),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: AppLocalizations.of(context)!.payment,
                      icon: data.paymentMethod.type == PaymentMethodType.cod
                          ? Icons.money_outlined
                          : Icons.payment_outlined,
                      child: _buildPayment(context, data.paymentMethod),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: AppLocalizations.of(context)!.orderSummaryTitle,
                      icon: Icons.summarize_outlined,
                      child: _PriceBreakdownView(
                        priceBreakdown: data.priceBreakdown,
                        extraCharges: data.extraCharges,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildConfirmBar(context, data),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.reviewOrderDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(BuildContext context, Address? address) {
    if (address == null) {
      return Text(
        AppLocalizations.of(context)!.addAddressToContinue,
        style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.recipientName.isNotEmpty
              ? address.recipientName
              : address.displayLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        if (address.recipientPhone.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            address.recipientPhone,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 6),
        Text(
          _formatAddress(address),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildDelivery(BuildContext context, DeliveryOption option) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          option.displayName,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        if (option.chargesInRupees > 0)
          Text(
            '₹${option.chargesInRupees.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryGreen,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              AppLocalizations.of(context)!.free,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildItems(BuildContext context, List<CartItem> items) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          CheckoutItemCard(item: items[i]),
        ],
      ],
    );
  }

  Widget _buildPayment(
    BuildContext context,
    PaymentMethodSelection paymentMethod,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paymentMethod.type.displayName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                paymentMethod.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const Icon(
          Icons.check_circle,
          color: AppColors.secondaryGreen,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildConfirmBar(BuildContext context, OrderReviewData data) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      buildWhen: (previous, current) =>
          current is CheckoutCalculated || current is OrderCreating,
      builder: (context, state) {
        final isProcessing = state is OrderCreating;
        final grandTotal = data.priceBreakdown.grandTotalInRupees;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.totalAmount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${grandTotal.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? AppColors.primaryOrange
                                  : Colors.orange[300],
                            ),
                        maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: isProcessing ? null : _handleConfirm,
                  icon: isProcessing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline, size: 18),
                  label: Text(
                    isProcessing
                        ? AppLocalizations.of(context)!.confirmingOrder
                        : AppLocalizations.of(context)!.confirmOrder,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).brightness ==
                            Brightness.light
                        ? AppColors.secondaryGreen
                        : AppColors.secondaryGreenDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatAddress(Address address) {
    final parts = <String>[
      address.addressLine1,
      if (address.addressLine2 != null && address.addressLine2!.isNotEmpty)
        address.addressLine2!,
      if (address.landmark != null && address.landmark!.isNotEmpty)
        address.landmark!,
      address.location.city ?? '',
      address.location.state ?? '',
      address.location.postalCode ?? '',
    ].where((part) => part.trim().isNotEmpty).toList();

    return parts.join(', ');
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primaryOrange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

class _PriceBreakdownView extends StatelessWidget {
  final PriceBreakdown priceBreakdown;
  final List<ExtraCharge> extraCharges;

  const _PriceBreakdownView({
    required this.priceBreakdown,
    this.extraCharges = const [],
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row(context, l10n.itemTotal, priceBreakdown.itemTotalInRupees),
        const SizedBox(height: 8),
        _row(
          context,
          l10n.deliveryCharges,
          priceBreakdown.deliveryChargesInRupees,
          isFree: priceBreakdown.deliveryCharges == 0,
        ),
        if (priceBreakdown.totalTax > 0) ...[
          const SizedBox(height: 8),
          _row(
            context,
            '${l10n.cgst} + ${l10n.sgst}',
            priceBreakdown.totalTaxInRupees,
          ),
        ],
        if (priceBreakdown.discount > 0) ...[
          const SizedBox(height: 8),
          _row(
            context,
            l10n.discountLabel,
            -priceBreakdown.discountInRupees,
            isDiscount: true,
          ),
        ],
        for (final charge in extraCharges) ...[
          const SizedBox(height: 8),
          _row(
            context,
            charge.label,
            charge.amount.toDouble(),
            isDiscount: charge.isDiscount,
          ),
        ],
        const Divider(height: 24),
        _row(
          context,
          l10n.totalAmount,
          priceBreakdown.grandTotalInRupees,
          isTotal: true,
        ),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    double amount, {
    bool isTotal = false,
    bool isFree = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: isTotal
                ? Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )
                : Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        if (isFree)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryGreen,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              AppLocalizations.of(context)!.free,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else
          Text(
            '${isDiscount ? '- ' : ''}₹${amount.abs().toStringAsFixed(2)}',
            style: isTotal
                ? Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryOrange,
                    )
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDiscount ? AppColors.secondaryGreen : null,
                      fontWeight: isDiscount ? FontWeight.w600 : null,
                    ),
          ),
      ],
    );
  }
}
