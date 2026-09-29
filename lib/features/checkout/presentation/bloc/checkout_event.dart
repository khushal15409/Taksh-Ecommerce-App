import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/delivery_option.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/payment_method_selection.dart';

/// Base class for all checkout events
abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

/// Event to select items for checkout
class SelectCheckoutItemsEvent extends CheckoutEvent {
  final List<CartItem> cartItems;
  final List<int> selectedItemIds;
  final List<ExtraCharge> extraCharges;
  final String? deliveryType;

  const SelectCheckoutItemsEvent({
    required this.cartItems,
    required this.selectedItemIds,
    this.extraCharges = const [],
    this.deliveryType,
  });

  @override
  List<Object?> get props => [
    cartItems,
    selectedItemIds,
    extraCharges,
    deliveryType,
  ];
}

/// Event to toggle item selection
class ToggleItemSelectionEvent extends CheckoutEvent {
  final int itemId;

  const ToggleItemSelectionEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Event to select all items
class SelectAllItemsEvent extends CheckoutEvent {
  const SelectAllItemsEvent();
}

/// Event to deselect all items
class DeselectAllItemsEvent extends CheckoutEvent {
  const DeselectAllItemsEvent();
}

/// Event to select address
class SelectAddressEvent extends CheckoutEvent {
  final Address address;

  const SelectAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

/// Event to load delivery options
class LoadDeliveryOptionsEvent extends CheckoutEvent {
  final String addressId;

  const LoadDeliveryOptionsEvent(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

/// Event to select delivery option
class SelectDeliveryOptionEvent extends CheckoutEvent {
  final DeliveryOption option;

  const SelectDeliveryOptionEvent(this.option);

  @override
  List<Object?> get props => [option];
}

/// Event to calculate checkout
class CalculateCheckoutEvent extends CheckoutEvent {
  final String? couponCode;

  const CalculateCheckoutEvent({this.couponCode});

  @override
  List<Object?> get props => [couponCode];
}

/// Event to apply coupon
class ApplyCouponEvent extends CheckoutEvent {
  final String couponCode;

  const ApplyCouponEvent(this.couponCode);

  @override
  List<Object?> get props => [couponCode];
}

/// Event to remove coupon
class RemoveCouponEvent extends CheckoutEvent {
  const RemoveCouponEvent();
}

/// Event to select payment method
class SelectPaymentMethodEvent extends CheckoutEvent {
  final PaymentMethodSelection paymentMethod;

  const SelectPaymentMethodEvent(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

/// Event to validate checkout
class ValidateCheckoutEvent extends CheckoutEvent {
  const ValidateCheckoutEvent();
}

/// Event to create order
class CreateOrderEvent extends CheckoutEvent {
  const CreateOrderEvent();
}

/// Event to place order (new flow - step 1)
class PlaceOrderEvent extends CheckoutEvent {
  const PlaceOrderEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initiate payment after order is placed (new flow - step 2)
class InitiatePaymentEvent extends CheckoutEvent {
  final int orderId;

  const InitiatePaymentEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Event to verify payment after successful payment (new flow - step 3)
class VerifyPaymentEvent extends CheckoutEvent {
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  const VerifyPaymentEvent({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });

  @override
  List<Object?> get props => [
    razorpayOrderId,
    razorpayPaymentId,
    razorpaySignature,
  ];
}

/// Event to reset checkout
class ResetCheckoutEvent extends CheckoutEvent {
  const ResetCheckoutEvent();
}
