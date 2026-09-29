import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/checkout_summary.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/delivery_option.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/selected_checkout_items.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart';

/// Describes whether the cart contains only standard-delivery products,
/// only express-delivery products, or a mix of both.
///
/// - [standardOnly]  → all items are standard (normal/1-day). Express option
///   is shown only if the pincode-availability API confirms it is possible.
/// - [expressOnly]   → all items support express (isExpress30 == true).
///   Normal option is shown only if express is not available for this pincode.
/// - [mixed]         → cart has items of both types; the user has NO choice —
///   delivery is forced to normal (express items fall back to standard).
enum CartDeliveryMode { standardOnly, expressOnly, mixed }

/// Base class for all checkout states
abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

/// Item selection loaded state
class ItemsSelectionLoaded extends CheckoutState {
  final List<CartItem> allItems;
  final SelectedCheckoutItems selectedItems;

  const ItemsSelectionLoaded({
    required this.allItems,
    required this.selectedItems,
  });

  @override
  List<Object?> get props => [allItems, selectedItems];
}

/// Delivery options loading state
class DeliveryOptionsLoading extends CheckoutState {
  final Address? selectedAddress;

  const DeliveryOptionsLoading({this.selectedAddress});

  @override
  List<Object?> get props => [selectedAddress];
}

/// Delivery options loaded state
class DeliveryOptionsLoaded extends CheckoutState {
  /// The two possible delivery options (normal + express), each with an
  /// [isAvailable] flag indicating whether they can be used for this cart/pincode.
  final List<DeliveryOption> options;
  final DeliveryOption selectedOption;
  final Address? selectedAddress;

  /// How the cart items are composed w.r.t. delivery mode.
  final CartDeliveryMode cartDeliveryMode;

  /// When true, the user cannot choose a delivery type (mixed cart).
  bool get isDeliveryTypeForced => cartDeliveryMode == CartDeliveryMode.mixed;

  const DeliveryOptionsLoaded({
    required this.options,
    required this.selectedOption,
    required this.cartDeliveryMode,
    this.selectedAddress,
  });

  @override
  List<Object?> get props =>
      [options, selectedOption, cartDeliveryMode, selectedAddress];
}

/// Address selected state
class AddressSelected extends CheckoutState {
  final Address address;

  const AddressSelected(this.address);

  @override
  List<Object?> get props => [address];
}

/// Checkout calculating state
class CheckoutCalculating extends CheckoutState {
  const CheckoutCalculating();
}

/// Checkout calculated state
class CheckoutCalculated extends CheckoutState {
  final CheckoutSummary summary;
  final String? appliedCoupon;

  const CheckoutCalculated({
    required this.summary,
    this.appliedCoupon,
  });

  @override
  List<Object?> get props => [summary, appliedCoupon];
}

/// Checkout validating state
class CheckoutValidating extends CheckoutState {
  const CheckoutValidating();
}

/// Checkout valid state
class CheckoutValid extends CheckoutState {
  const CheckoutValid();
}

/// Checkout invalid state
class CheckoutInvalid extends CheckoutState {
  final List<String> errors;

  const CheckoutInvalid(this.errors);

  @override
  List<Object?> get props => [errors];
}

/// Order creating state
class OrderCreating extends CheckoutState {
  const OrderCreating();
}

/// Order created state (legacy COD flow)
class OrderCreated extends CheckoutState {
  final Order order;

  const OrderCreated(this.order);

  @override
  List<Object?> get props => [order];
}

/// Order placed state (new flow - step 1 complete)
class OrderPlaced extends CheckoutState {
  final int orderId;
  final String? orderNumber;
  final String? message;

  const OrderPlaced({
    required this.orderId,
    this.orderNumber,
    this.message,
  });

  @override
  List<Object?> get props => [orderId, orderNumber, message];
}

/// Payment initiating state (new flow - step 2)
class PaymentInitiating extends CheckoutState {
  const PaymentInitiating();
}

/// Payment initiated state (new flow - step 2 complete)
class PaymentInitiated extends CheckoutState {
  final String razorpayOrderId;
  final int amountInPaise;
  final String? razorpayKey;

  const PaymentInitiated({
    required this.razorpayOrderId,
    required this.amountInPaise,
    this.razorpayKey,
  });

  @override
  List<Object?> get props => [razorpayOrderId, amountInPaise, razorpayKey];
}

/// Payment verifying state (new flow - step 3)
class PaymentVerifying extends CheckoutState {
  const PaymentVerifying();
}

/// Payment verified state (new flow - step 3 complete - success)
class PaymentVerified extends CheckoutState {
  final String? message;
  final int? orderId;
  final String? orderNumber;
  final bool isQuickDelivery;

  const PaymentVerified({
    this.message,
    this.orderId,
    this.orderNumber,
    this.isQuickDelivery = false,
  });

  @override
  List<Object?> get props => [message, orderId, orderNumber, isQuickDelivery];
}

/// Error state
class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}
