import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/services/razorpay_service.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_event.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_state.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/payment_method_selection.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/pages/order_review_page.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/widgets/address_selector_widget.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/widgets/checkout_item_card.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/widgets/payment_method_selector_widget.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/widgets/price_breakdown_widget.dart';

/// Main checkout page for completing order
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late RazorpayService _razorpayService;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _razorpayService = RazorpayService();
    _razorpayService.initialize(
      onSuccess: _handleRazorpaySuccess,
      onFailure: _handleRazorpayFailure,
    );

    // Use addPostFrameCallback to ensure AddressBloc has time to load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureAddressesLoaded();
      _syncAddressSelection(context.read<AddressBloc>().state);
    });
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  void _ensureAddressesLoaded() {
    final addressState = context.read<AddressBloc>().state;
    if (addressState is AddressInitial || addressState is AddressError) {
      context.read<AddressBloc>().add(const LoadAddressesEvent());
    }
  }

  Address? _resolveCheckoutAddress(AddressState addressState) {
    if (addressState is! AddressesLoaded || addressState.addresses.isEmpty) {
      return null;
    }

    return addressState.selectedAddress ??
        addressState.defaultAddress ??
        addressState.addresses.first;
  }

  void _syncAddressSelection(AddressState addressState) {
    final resolvedAddress = _resolveCheckoutAddress(addressState);
    if (resolvedAddress == null) {
      return;
    }

    final checkoutBloc = context.read<CheckoutBloc>();
    if (checkoutBloc.selectedAddress != null) {
      return;
    }

    checkoutBloc.add(SelectAddressEvent(resolvedAddress));
  }

  /// Handle Razorpay payment success
  void _handleRazorpaySuccess(PaymentSuccessResponse response) {
    setState(() {
      _isProcessingPayment = false;
    });

    // Step 3: Verify payment with backend
    context.read<CheckoutBloc>().add(
      VerifyPaymentEvent(
        razorpayOrderId: response.orderId ?? '',
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
      ),
    );
  }

  /// Handle Razorpay payment failure
  void _handleRazorpayFailure(PaymentFailureResponse response) {
    setState(() {
      _isProcessingPayment = false;
    });

    // Navigate to payment failure page
    context.push(
      AppRoutes.paymentFailed,
      extra: {
        'errorCode': response.code?.toString(),
        'errorMessage': response.message,
      },
    );
  }

  /// Process checkout and open the order review page.
  ///
  /// The review page is pushed via [Navigator] (not go_router) so that
  /// the existing [CheckoutBloc] instance is shared between the checkout
  /// page and the review page. This lets the checkout page continue to
  /// own the Razorpay flow and the post-placement navigation.
  Future<void> _processCheckout() async {
    if (_isProcessingPayment) return;

    final checkoutBloc = context.read<CheckoutBloc>();
    final state = checkoutBloc.state;

    // Ensure we have calculated checkout
    if (state is! CheckoutCalculated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for checkout calculation'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (checkoutBloc.selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery address'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final calculatedState = state;
    final reviewData = OrderReviewData(
      items: calculatedState.summary.items,
      address: calculatedState.summary.selectedAddress,
      deliveryOption: calculatedState.summary.deliveryOption,
      priceBreakdown: calculatedState.summary.priceBreakdown,
      paymentMethod: checkoutBloc.selectedPaymentMethod,
      extraCharges: checkoutBloc.extraChargesForReview,
    );

    setState(() {
      _isProcessingPayment = false;
    });

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider<CheckoutBloc>.value(
          value: checkoutBloc,
          child: OrderReviewPage(data: reviewData),
        ),
      ),
    );
  }

  void _navigateToQuickDeliveryTracking({
    required int orderId,
    String? orderNumber,
  }) {
    final selectedAddress = context.read<CheckoutBloc>().selectedAddress;
    final customerLat = selectedAddress?.location.latitude;
    final customerLng = selectedAddress?.location.longitude;

    context.go(
      AppRoutes.quickDeliveryTracking(
        orderId.toString(),
        customerLat: customerLat,
        customerLng: customerLng,
        orderNumber: orderNumber,
      ),
    );
  }

  void _navigateToOrderPlaced({
    required int orderId,
    String? orderNumber,
    required String paymentMethod,
  }) {
    context.go(
      AppRoutes.orderPlacedPath(
        orderId: orderId,
        orderNumber: orderNumber,
        paymentMethod: paymentMethod,
      ),
    );
  }

  /// Pop the order review page if it is on the navigator stack.
  ///
  /// The review page is pushed via [Navigator] on top of the checkout
  /// page, so it must be dismissed before navigating to a top-level
  /// route (e.g. the order placed page) so the navigation stack is
  /// clean for the success page.
  void _popOrderReviewIfPresent() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.checkout),
        centerTitle: false,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.primaryOrange
            : Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CheckoutBloc, CheckoutState>(
            listener: (context, state) {
              if (state is CheckoutError) {
                setState(() {
                  _isProcessingPayment = false;
                });

                // Show the specific server error message (e.g.
                // "Insufficient stock available") so the user knows
                // why the order failed, instead of a generic toast.
                AppErrorToast.show(context, message: state.message);

                // Pop the review page (if it's on the stack) so the
                // checkout page can be the one to handle the redirect.
                _popOrderReviewIfPresent();

                // Navigate to cart page after showing error so the
                // user can adjust quantities or remove out-of-stock
                // items before retrying.
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (context.mounted) {
                    context.go(AppRoutes.cart);
                  }
                });
              } else if (state is OrderCreated) {
                final isQuickDelivery =
                    state.order.deliveryType == '30_min' ||
                    state.order.isExpress;

                if (isQuickDelivery) {
                  _navigateToQuickDeliveryTracking(
                    orderId: state.order.id,
                    orderNumber: state.order.orderNumber,
                  );
                } else {
                  _navigateToOrderPlaced(
                    orderId: state.order.id,
                    orderNumber: state.order.orderNumber,
                    paymentMethod:
                        context
                            .read<CheckoutBloc>()
                            .selectedPaymentMethod
                            .type
                            .value,
                  );
                }
              } else if (state is OrderPlaced) {
                // Pop the review page (if it's on the stack) so the
                // checkout page is back on top before we proceed.
                _popOrderReviewIfPresent();

                final paymentMethod =
                    context.read<CheckoutBloc>().selectedPaymentMethod;
                if (paymentMethod.type == PaymentMethodType.cod) {
                  // COD: order is complete, show the success page
                  _navigateToOrderPlaced(
                    orderId: state.orderId,
                    orderNumber: state.orderNumber,
                    paymentMethod: paymentMethod.type.value,
                  );
                } else {
                  // Online: dispatch initiate payment
                  context.read<CheckoutBloc>().add(
                    InitiatePaymentEvent(state.orderId),
                  );
                }
              } else if (state is PaymentInitiated) {
                // Online payment flow - Step 2 complete, open Razorpay checkout
                // SECURITY: razorpayKey comes from backend, not from .env

                if (state.razorpayKey == null || state.razorpayKey!.isEmpty) {
                  setState(() {
                    _isProcessingPayment = false;
                  });
                  AppErrorToast.show(context);
                  return;
                }

                _razorpayService.openCheckout(
                  razorpayOrderId: state.razorpayOrderId,
                  amountInPaise: state.amountInPaise,
                  razorpayKey: state.razorpayKey!,
                  orderNumber: state.razorpayOrderId,
                );
              } else if (state is PaymentVerified) {
                // Online payment flow - Step 3 complete, navigate to success
                setState(() {
                  _isProcessingPayment = false;
                });

                final orderId = state.orderId;
                if (orderId != null && state.isQuickDelivery) {
                  _navigateToQuickDeliveryTracking(
                    orderId: orderId,
                    orderNumber: state.orderNumber,
                  );
                } else if (orderId != null) {
                  _navigateToOrderPlaced(
                    orderId: orderId,
                    orderNumber: state.orderNumber,
                    paymentMethod: PaymentMethodType.online.value,
                  );
                } else {
                  context.go(AppRoutes.orders);
                }
              } else if (state is CheckoutInvalid) {
                AppErrorToast.show(context);
              }
            },
          ),
          BlocListener<AddressBloc, AddressState>(
            listener: (context, state) {
              _syncAddressSelection(state);
            },
          ),
        ],
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          buildWhen: (previous, current) => current is OrderCreating,
          builder: (context, state) {
            if (state is OrderCreating) {
              return const Center(child: CircularProgressIndicator());
            }

            return Container(
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
                          _buildSectionTitle(
                            context,
                            AppLocalizations.of(context)!.deliveryAddress,
                          ),
                          const SizedBox(height: 12),
                          const AddressSelectorWidget(),
                          const SizedBox(height: 24),
                          _buildSectionTitle(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.orderItems(0).split(' (').first,
                          ), // Quick fix or add title key
                          const SizedBox(height: 12),
                          const _OrderItemsSection(),
                          const SizedBox(height: 24),
                          _buildSectionTitle(
                            context,
                            AppLocalizations.of(context)!.paymentMethod,
                          ),
                          const SizedBox(height: 12),
                          const PaymentMethodSelectorWidget(),
                          const SizedBox(height: 24),
                          _buildSectionTitle(
                            context,
                            AppLocalizations.of(context)!.priceDetails,
                          ),
                          const SizedBox(height: 12),
                          const _PriceBreakdownSection(),
                        ],
                      ),
                    ),
                  ),
                  const _CheckoutBottomBar(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// Separate widget for order items section - rebuilds only when CheckoutCalculated changes
class _OrderItemsSection extends StatefulWidget {
  const _OrderItemsSection();

  @override
  State<_OrderItemsSection> createState() => _OrderItemsSectionState();
}

class _OrderItemsSectionState extends State<_OrderItemsSection> {
  bool _showItemDetails = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      buildWhen: (previous, current) =>
          current is CheckoutInitial ||
          current is CheckoutCalculated ||
          current is CheckoutCalculating,
      builder: (context, state) {
        if (state is! CheckoutCalculated) {
          // Check if we're waiting for address selection
          final addressState = context.watch<AddressBloc>().state;
          if (addressState is AddressesLoaded &&
              addressState.addresses.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_off,
                      size: 48,
                      color: Theme.of(context).disabledColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Please add a delivery address to continue',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 16),
                  Text(
                    AppLocalizations.of(context)!.loadingOrderDetails,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }

        final items = state.summary.items;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _showItemDetails = !_showItemDetails;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.itemsCount(items.length),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(AppLocalizations.of(context)!.edit),
                          ),
                          Icon(
                            _showItemDetails
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_showItemDetails) ...[
                const Divider(height: 1),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return CheckoutItemCard(item: items[index]);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Separate widget for price breakdown - rebuilds only when CheckoutCalculated changes
class _PriceBreakdownSection extends StatelessWidget {
  const _PriceBreakdownSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      buildWhen: (previous, current) =>
          current is CheckoutInitial || current is CheckoutCalculated,
      builder: (context, state) {
        if (state is CheckoutCalculated) {
          return PriceBreakdownWidget(
            priceBreakdown: state.summary.priceBreakdown,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// Separate widget for bottom bar - rebuilds only when necessary
class _CheckoutBottomBar extends StatelessWidget {
  const _CheckoutBottomBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      buildWhen: (previous, current) =>
          current is CheckoutInitial ||
          current is CheckoutCalculated ||
          current is OrderCreating ||
          current is PaymentInitiating,
      builder: (context, state) {
        final canPlaceOrder = state is CheckoutCalculated;
        final grandTotal = canPlaceOrder
            ? state.summary.priceBreakdown.grandTotal
            : 0;
        final isProcessing =
            state is OrderCreating ||
            state is PaymentInitiating ||
            (context
                    .findAncestorStateOfType<_CheckoutPageState>()
                    ?._isProcessingPayment ??
                false);
        final paymentMethod = context
            .read<CheckoutBloc>()
            .selectedPaymentMethod;

        // Check if we have addresses
        final addressState = context.watch<AddressBloc>().state;
        final hasNoAddresses =
            addressState is AddressesLoaded && addressState.addresses.isEmpty;

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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasNoAddresses
                            ? '₹0.00'
                            : '₹${grandTotal.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? AppColors.primaryOrange
                              : Colors.orange[300],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: canPlaceOrder && !isProcessing && !hasNoAddresses
                      ? () => context
                            .findAncestorStateOfType<_CheckoutPageState>()
                            ?._processCheckout()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                        ? AppColors.primaryOrange
                        : AppColors.primaryOrangeDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          hasNoAddresses
                              ? AppLocalizations.of(context)!.addAddress
                              : (paymentMethod.type == PaymentMethodType.cod
                                    ? AppLocalizations.of(context)!.placeOrder
                                    : AppLocalizations.of(
                                        context,
                                      )!.proceedToPay),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
