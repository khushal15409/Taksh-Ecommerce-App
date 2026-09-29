import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/widgets/item_selector_card.dart';

/// Page for selecting items from cart to checkout
class SelectItemsPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final List<ExtraCharge> extraCharges;

  const SelectItemsPage({
    super.key,
    required this.cartItems,
    this.extraCharges = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Initialize with all items selected by default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cartItems.isNotEmpty) {
        context.read<CheckoutBloc>().add(
          SelectCheckoutItemsEvent(
            cartItems: cartItems,
            selectedItemIds: cartItems.map((item) => item.id).toList(),
            extraCharges: extraCharges,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Items'),
        centerTitle: false,
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              if (state is ItemsSelectionLoaded) {
                final allSelected =
                    state.selectedItems.itemIds.length == state.allItems.length;
                return TextButton(
                  onPressed: () {
                    if (allSelected) {
                      context.read<CheckoutBloc>().add(
                        const DeselectAllItemsEvent(),
                      );
                    } else {
                      context.read<CheckoutBloc>().add(
                        const SelectAllItemsEvent(),
                      );
                    }
                  },
                  child: Text(
                    allSelected ? 'Deselect All' : 'Select All',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: IndiaGradients.subtleTricolor,
        ),
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is ItemsSelectionLoaded) {
              if (state.allItems.isEmpty) {
                return const Center(child: Text('No items in cart'));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.allItems.length,
                      itemBuilder: (context, index) {
                        final item = state.allItems[index];
                        final isSelected = state.selectedItems.itemIds.contains(
                          item.id,
                        );

                        return ItemSelectorCard(
                          item: item,
                          isSelected: isSelected,
                          onChanged: (selected) {
                            context.read<CheckoutBloc>().add(
                              ToggleItemSelectionEvent(item.id),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  _buildBottomBar(context, state),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ItemsSelectionLoaded state) {
    final hasSelection = state.selectedItems.isNotEmpty;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${state.selectedItems.items.length} items selected',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${state.selectedItems.subtotal.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryOrange,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: hasSelection
                      ? () {
                          // Pass selected items to checkout page
                          context.push(
                            AppRoutes.checkout,
                            extra: state.selectedItems,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
