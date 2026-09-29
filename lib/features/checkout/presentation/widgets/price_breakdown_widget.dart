import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/price_breakdown.dart';

/// Widget for displaying price breakdown
class PriceBreakdownWidget extends StatelessWidget {
  final PriceBreakdown priceBreakdown;

  const PriceBreakdownWidget({
    super.key,
    required this.priceBreakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPriceRow(
              context,
              'Item Total',
              priceBreakdown.itemTotalInRupees,
              isRegular: true,
            ),
            const SizedBox(height: 12),
            _buildPriceRow(
              context,
              'Delivery Charges',
              priceBreakdown.deliveryChargesInRupees,
              isRegular: true,
              isFree: priceBreakdown.deliveryCharges == 0,
            ),
            const SizedBox(height: 12),
            _buildPriceRow(
              context,
              'Taxes (CGST + SGST)',
              priceBreakdown.totalTaxInRupees,
              isRegular: true,
            ),
            if (priceBreakdown.discount > 0) ...[
              const SizedBox(height: 12),
              _buildPriceRow(
                context,
                'Discount',
                -priceBreakdown.discountInRupees,
                isRegular: true,
                isDiscount: true,
              ),
            ],
            const Divider(height: 24),
            _buildPriceRow(
              context,
              'Grand Total',
              priceBreakdown.grandTotalInRupees,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    double amount, {
    bool isRegular = false,
    bool isTotal = false,
    bool isFree = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
              : Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(width: 16),
        if (isFree)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryGreen,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'FREE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          )
        else
          Text(
            '${isDiscount ? '-' : ''}₹${amount.abs().toStringAsFixed(2)}',
            style: isTotal
                ? Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryOrange,
                    )
                : Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDiscount ? AppColors.secondaryGreen : null,
                      fontWeight: isDiscount ? FontWeight.bold : null,
                    ),
          ),
      ],
    );
  }
}
