import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/delivery_option.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_state.dart';

/// Widget for selecting delivery options.
///
/// Shows only two options: Standard Delivery (1 day) and Express Delivery (30 min).
///
/// Behaviour:
/// - If the cart has a mix of express + standard items → both options are
///   shown as informational tiles (no radio selection); the delivery type is
///   forced to Standard Delivery and a banner explains why.
/// - If a particular delivery type is unavailable for the selected address
///   pincode, that tile is hidden entirely.
/// - If only one type is available and the cart is homogeneous, a single
///   tile is shown (pre-selected, no radio interaction needed).
class DeliveryOptionsWidget extends StatelessWidget {
  const DeliveryOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      buildWhen: (previous, current) {
        return current is CheckoutInitial ||
            current is DeliveryOptionsLoading ||
            current is DeliveryOptionsLoaded ||
            current is CheckoutCalculated;
      },
      builder: (context, state) {
        if (state is DeliveryOptionsLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        List<DeliveryOption> options = [];
        DeliveryOption? selectedOption;
        bool isForced = false;

        if (state is DeliveryOptionsLoaded) {
          options = state.options;
          selectedOption = state.selectedOption;
          isForced = state.isDeliveryTypeForced;
        } else if (state is CheckoutCalculated) {
          final bloc = context.read<CheckoutBloc>();
          selectedOption = bloc.selectedDeliveryOption;
          options = bloc.currentDeliveryOptions;
          isForced = bloc.cartDeliveryMode == CartDeliveryMode.mixed;
        }

        if (options.isEmpty) return const SizedBox.shrink();

        // Only show options that are available.
        final visibleOptions = options.where((o) => o.isAvailable).toList();

        if (visibleOptions.isEmpty) return const SizedBox.shrink();

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mixed-cart banner: inform user that delivery type is fixed.
                if (isForced) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      border: Border.all(color: Colors.amber.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your cart has items with different delivery types. '
                            'Standard Delivery has been selected automatically.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.amber.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                ...visibleOptions.map((option) {
                  final isSelected = selectedOption?.type == option.type;
                  return _DeliveryOptionTile(
                    option: option,
                    isSelected: isSelected,
                    isInteractive: !isForced,
                    onSelect: isForced
                        ? null
                        : () {
                            context.read<CheckoutBloc>().add(
                              SelectDeliveryOptionEvent(option),
                            );
                          },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DeliveryOptionTile extends StatelessWidget {
  final DeliveryOption option;
  final bool isSelected;

  /// When false the tile is rendered as informational (no tap, greyed radio).
  final bool isInteractive;
  final VoidCallback? onSelect;

  const _DeliveryOptionTile({
    required this.option,
    required this.isSelected,
    required this.isInteractive,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isInteractive ? onSelect : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.primaryOrange
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? AppColors.primaryOrange.withOpacity(0.05) : null,
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: isInteractive ? (_) => onSelect?.call() : null,
              activeColor: AppColors.primaryOrange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        option.displayName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (option.isExpress) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'FAST',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Delivery in ${option.estimatedTime}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              option.charges == 0
                  ? 'FREE'
                  : '+₹${option.chargesInRupees.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: option.charges == 0
                    ? AppColors.secondaryGreen
                    : AppColors.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
