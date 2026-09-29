import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:taksh_e_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';
import 'package:taksh_e_commerce/features/checkout/data/datasources/checkout_mock_datasource.dart';
import 'package:taksh_e_commerce/features/checkout/data/datasources/checkout_remote_datasource_impl.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/checkout_summary.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/delivery_option.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/order_request.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/payment_method_selection.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/price_breakdown.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/selected_checkout_items.dart';
import 'package:taksh_e_commerce/features/checkout/domain/usecases/calculate_checkout.dart';
import 'package:taksh_e_commerce/features/checkout/domain/usecases/create_order.dart';
import 'package:taksh_e_commerce/features/checkout/domain/usecases/get_delivery_options.dart';
import 'package:taksh_e_commerce/features/checkout/domain/usecases/place_order.dart';
import 'package:taksh_e_commerce/features/checkout/domain/usecases/validate_checkout.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/initiate_payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/verify_payment_usecase.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/check_delivery_availability.dart';

/// BLoC for managing checkout flow
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CalculateCheckout _calculateCheckout;
  // ignore: unused_field
  final GetDeliveryOptions _getDeliveryOptions;
  final ValidateCheckout _validateCheckout;
  final CreateOrder _createOrder;
  final PlaceOrder _placeOrder;
  final InitiatePayment _initiatePayment;
  final VerifyPaymentUseCase _verifyPayment;
  // ignore: unused_field
  final CheckDeliveryAvailability _checkDeliveryAvailability;

  // Current checkout state data
  List<CartItem> _allItems = [];
  List<int> _selectedItemIds = [];
  List<ExtraCharge> _extraCharges = [];
  Address? _selectedAddress;
  DeliveryOption? _selectedDeliveryOption;
  PaymentMethodSelection _selectedPaymentMethod = PaymentMethodSelection.cod;
  String? _appliedCoupon;
  int? _lastPlacedOrderId;
  String? _lastPlacedOrderNumber;
  bool _lastPlacedWasQuickDelivery = false;

  /// Cached delivery mode for the current item selection (set when address is selected)
  CartDeliveryMode _cartDeliveryMode = CartDeliveryMode.standardOnly;
  List<DeliveryOption> _currentDeliveryOptions = [
    DeliveryOption.normal().copyWith(isAvailable: true),
    // DeliveryOption.oneDay().copyWith(isAvailable: true),
    DeliveryOption.express().copyWith(isAvailable: true),
  ];

  CheckoutBloc({
    required CalculateCheckout calculateCheckout,
    required GetDeliveryOptions getDeliveryOptions,
    required ValidateCheckout validateCheckout,
    required CreateOrder createOrder,
    required PlaceOrder placeOrder,
    required InitiatePayment initiatePayment,
    required VerifyPaymentUseCase verifyPayment,
    required CheckDeliveryAvailability checkDeliveryAvailability,
  }) : _calculateCheckout = calculateCheckout,
       _getDeliveryOptions = getDeliveryOptions,
       _validateCheckout = validateCheckout,
       _createOrder = createOrder,
       _placeOrder = placeOrder,
       _initiatePayment = initiatePayment,
       _verifyPayment = verifyPayment,
       _checkDeliveryAvailability = checkDeliveryAvailability,
       super(const CheckoutInitial()) {
    on<SelectCheckoutItemsEvent>(_onSelectCheckoutItems);
    on<ToggleItemSelectionEvent>(_onToggleItemSelection);
    on<SelectAllItemsEvent>(_onSelectAllItems);
    on<DeselectAllItemsEvent>(_onDeselectAllItems);
    on<SelectAddressEvent>(_onSelectAddress);
    on<LoadDeliveryOptionsEvent>(_onLoadDeliveryOptions);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<SelectDeliveryOptionEvent>(_onSelectDeliveryOption);
    on<CalculateCheckoutEvent>(_onCalculateCheckout);
    on<ApplyCouponEvent>(_onApplyCoupon);
    on<RemoveCouponEvent>(_onRemoveCoupon);
    on<ValidateCheckoutEvent>(_onValidateCheckout);
    on<CreateOrderEvent>(_onCreateOrder);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<ResetCheckoutEvent>(_onResetCheckout);
  }

  final _log = loggerWithContext({
    'feature': 'checkout',
    'layer': 'presentation',
    'class': 'CheckoutBloc',
  });

  /// Handle select checkout items event
  Future<void> _onSelectCheckoutItems(
    SelectCheckoutItemsEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    _log.infoWithContext('Selecting checkout items', {
      'total': event.cartItems.length,
      'selected': event.selectedItemIds.length,
    });

    _allItems = event.cartItems;
    _selectedItemIds = event.selectedItemIds;
    _extraCharges = event.extraCharges;
    if (event.deliveryType == '30_min') {
      _selectedDeliveryOption = DeliveryOption.express();
    } else if (event.deliveryType == 'normal') {
      _selectedDeliveryOption = DeliveryOption.normal();
    }

    // Convert CartItem to CartItemModel and set in datasources
    final cartItemModels = _allItems.map((item) {
      return CartItemModel(
        id: item.id,
        productVariantId: item.productVariantId,
        productName: item.productName,
        sku: item.sku,
        price: item.price,
        qty: item.qty,
        total: item.total,
        image: item.image,
        productId: item.productId,
        isExpress30: item.isExpress30,
      );
    }).toList();

    CheckoutMockDataSource.setCartItems(cartItemModels);
    CheckoutRemoteDataSourceImpl.setCartItems(cartItemModels);

    final selectedItems = _allItems
        .where((item) => _selectedItemIds.contains(item.id))
        .toList();

    final subtotal = selectedItems.fold(0, (sum, item) => sum + item.total);
    final totalQty = selectedItems.fold(0, (sum, item) => sum + item.qty);

    final selection = SelectedCheckoutItems(
      items: selectedItems,
      itemIds: _selectedItemIds,
      subtotal: subtotal,
      totalQuantity: totalQty,
      extraCharges: _extraCharges,
      deliveryType: event.deliveryType,
    );

    _log.infoWithContext('Selected items updated', {
      'subtotal': subtotal,
      'totalQuantity': totalQty,
    });

    emit(ItemsSelectionLoaded(allItems: _allItems, selectedItems: selection));
  }

  /// Handle toggle item selection event
  Future<void> _onToggleItemSelection(
    ToggleItemSelectionEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    if (_selectedItemIds.contains(event.itemId)) {
      _selectedItemIds.remove(event.itemId);
    } else {
      _selectedItemIds.add(event.itemId);
    }

    add(
      SelectCheckoutItemsEvent(
        cartItems: _allItems,
        selectedItemIds: _selectedItemIds,
        extraCharges: _extraCharges,
        deliveryType: _selectedDeliveryOption?.type,
      ),
    );
  }

  /// Handle select all items event
  Future<void> _onSelectAllItems(
    SelectAllItemsEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    _selectedItemIds = _allItems.map((item) => item.id).toList();

    add(
      SelectCheckoutItemsEvent(
        cartItems: _allItems,
        selectedItemIds: _selectedItemIds,
        extraCharges: _extraCharges,
        deliveryType: _selectedDeliveryOption?.type,
      ),
    );
  }

  /// Handle deselect all items event
  Future<void> _onDeselectAllItems(
    DeselectAllItemsEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    _selectedItemIds = [];

    add(
      SelectCheckoutItemsEvent(
        cartItems: _allItems,
        selectedItemIds: _selectedItemIds,
        extraCharges: _extraCharges,
        deliveryType: _selectedDeliveryOption?.type,
      ),
    );
  }

  /// Handle select address event
  Future<void> _onSelectAddress(
    SelectAddressEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    _log.infoWithContext('Address selected', {'addressId': event.address.id});

    _selectedAddress = event.address;
    emit(AddressSelected(event.address));

    // Load delivery options for the selected address
    add(LoadDeliveryOptionsEvent(event.address.id));
  }

  /// Handle load delivery options event
  ///
  /// Determines which delivery modes are available for the current cart/address
  /// by checking the express-30 availability per product via pincode.
  ///
  /// Logic:
  ///  1. Classify each selected item as express-capable or standard-only.
  ///     - If [CartItem.isExpress30] is already set, use it directly.
  ///     - Otherwise try to look up the product ID from [VariantCacheService]
  ///       and call [CheckDeliveryAvailability] using the address pincode.
  ///     - Items whose product ID is unknown default to standard-only.
  ///  2. Derive [CartDeliveryMode]:
  ///     - all items express-capable → expressOnly
  ///     - all items standard-only   → standardOnly
  ///     - mix                       → mixed (forced to normal, no user choice)
  ///  3. For expressOnly carts, verify express is reachable by calling
  ///     [CheckDeliveryAvailability] for each item. If ANY item is not
  ///     deliverable via express, express option is marked unavailable.
  ///  4. For standardOnly carts, also check if express delivery is possible
  ///     (the user might be able to upgrade).
  Future<void> _onLoadDeliveryOptions(
    LoadDeliveryOptionsEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(DeliveryOptionsLoading(selectedAddress: _selectedAddress));

    final options = [
      DeliveryOption.normal().copyWith(isAvailable: true),
      // DeliveryOption.oneDay().copyWith(isAvailable: true),
      DeliveryOption.express().copyWith(isAvailable: true),
    ];
    _currentDeliveryOptions = options;
    _cartDeliveryMode = CartDeliveryMode.standardOnly;

    _selectedDeliveryOption ??= DeliveryOption.normal();
    final selectedType = _selectedDeliveryOption!.type;
    _selectedDeliveryOption = options.firstWhere(
      (option) => option.type == selectedType,
      orElse: DeliveryOption.normal,
    );

    emit(
      DeliveryOptionsLoaded(
        options: options,
        selectedOption: _selectedDeliveryOption!,
        cartDeliveryMode: _cartDeliveryMode,
        selectedAddress: _selectedAddress,
      ),
    );

    // Recalculate checkout totals using selected delivery type.
    if (_selectedItemIds.isNotEmpty) {
      add(CalculateCheckoutEvent(couponCode: _appliedCoupon));
    }
  }

  /// Handle select delivery option event
  Future<void> _onSelectDeliveryOption(
    SelectDeliveryOptionEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    _log.infoWithContext('Delivery option selected', {
      'type': event.option.type,
    });

    _selectedDeliveryOption = event.option;

    // Recalculate checkout with selected delivery option.
    if (_selectedItemIds.isNotEmpty) {
      add(CalculateCheckoutEvent(couponCode: _appliedCoupon));
    }
  }

  /// Handle select payment method event
  Future<void> _onSelectPaymentMethod(
    SelectPaymentMethodEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    _log.infoWithContext('Payment method selected', {
      'method': event.paymentMethod.type.value,
    });

    _selectedPaymentMethod = event.paymentMethod;
  }

  /// Handle calculate checkout event
  Future<void> _onCalculateCheckout(
    CalculateCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    if (_selectedItemIds.isEmpty) {
      emit(const CheckoutError('No items selected'));
      return;
    }

    if (_selectedDeliveryOption == null) {
      emit(const CheckoutError('No delivery option selected'));
      return;
    }

    emit(const CheckoutCalculating());

    final params = CalculateCheckoutParams(
      cartItemIds: _selectedItemIds,
      deliveryType: _selectedDeliveryOption!.type,
      addressId: _selectedAddress?.id,
      couponCode: event.couponCode ?? _appliedCoupon,
    );

    final result = await _calculateCheckout(params);

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to calculate checkout', {
          'error': failure.message,
        });
        emit(CheckoutError(failure.message));
      },
      (summary) {
        _selectedDeliveryOption = summary.deliveryOption;
        final resolvedSummary = CheckoutSummary(
          items: summary.items,
          priceBreakdown: summary.priceBreakdown,
          deliveryOption: summary.deliveryOption,
          selectedAddress: _selectedAddress ?? summary.selectedAddress,
        );
        emit(
          CheckoutCalculated(
            summary: resolvedSummary,
            appliedCoupon: event.couponCode ?? _appliedCoupon,
          ),
        );
      },
    );
  }

  /// Handle apply coupon event
  Future<void> _onApplyCoupon(
    ApplyCouponEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    _appliedCoupon = event.couponCode;
    add(CalculateCheckoutEvent(couponCode: event.couponCode));
  }

  /// Handle remove coupon event
  Future<void> _onRemoveCoupon(
    RemoveCouponEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    _appliedCoupon = null;
    add(const CalculateCheckoutEvent());
  }

  /// Handle validate checkout event
  Future<void> _onValidateCheckout(
    ValidateCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final errors = <String>[];

    if (_selectedItemIds.isEmpty) {
      errors.add('Please select at least one item');
    }

    if (_selectedAddress == null) {
      errors.add('Please select a delivery address');
    }

    if (_selectedDeliveryOption == null) {
      errors.add('Please select a delivery option');
    }

    if (errors.isNotEmpty) {
      emit(CheckoutInvalid(errors));
      return;
    }

    emit(const CheckoutValidating());

    // Get current checkout summary to get expected total
    if (state is! CheckoutCalculated) {
      emit(const CheckoutError('Please calculate checkout first'));
      return;
    }

    final currentState = state as CheckoutCalculated;
    final expectedTotal = currentState.summary.priceBreakdown.grandTotal;

    final orderRequest = OrderRequest(
      cartItemIds: _selectedItemIds,
      addressId: _selectedAddress!.id,
      warehouseId: 1, // Default warehouse
      deliveryType: _selectedDeliveryOption!.type,
      isExpress: _selectedDeliveryOption!.type == '30_min',
      paymentMethod: _selectedPaymentMethod.type.value,
      expectedTotal: expectedTotal,
    );

    final result = await _validateCheckout(orderRequest);

    result.fold(
      (failure) {
        _log.errorWithContext('Checkout validation failed', {
          'error': failure.message,
        });
        emit(CheckoutError(failure.message));
      },
      (isValid) {
        if (isValid) {
          emit(const CheckoutValid());
        } else {
          emit(const CheckoutInvalid(['Checkout validation failed']));
        }
      },
    );
  }

  /// Handle create order event
  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    if (_selectedItemIds.isEmpty ||
        _selectedAddress == null ||
        _selectedDeliveryOption == null) {
      emit(const CheckoutError('Invalid checkout state'));
      return;
    }

    // Get expected total from current state
    if (state is! CheckoutCalculated) {
      emit(const CheckoutError('Please calculate checkout first'));
      return;
    }

    // Save the expected total BEFORE emitting OrderCreating state
    final currentState = state as CheckoutCalculated;
    final expectedTotal = currentState.summary.priceBreakdown.grandTotal;

    emit(const OrderCreating());

    final orderRequest = OrderRequest(
      cartItemIds: _selectedItemIds,
      addressId: _selectedAddress!.id,
      warehouseId: 1, // Default warehouse
      deliveryType: _selectedDeliveryOption!.type,
      isExpress: _selectedDeliveryOption!.type == '30_min',
      paymentMethod: _selectedPaymentMethod.type.value,
      expectedTotal: expectedTotal,
    );

    final result = await _createOrder(orderRequest);

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to create order', {
          'error': failure.message,
        });
        emit(CheckoutError(failure.message));
      },
      (order) {
        _log.infoWithContext('Order created successfully', {
          'orderId': order.id,
          'orderNumber': order.orderNumber,
        });
        emit(OrderCreated(order));
      },
    );
  }

  /// Handle reset checkout event
  Future<void> _onResetCheckout(
    ResetCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    _allItems = [];
    _selectedItemIds = [];
    _extraCharges = [];
    _selectedAddress = null;
    _selectedDeliveryOption = null;
    _selectedPaymentMethod = PaymentMethodSelection.cod;
    _appliedCoupon = null;
    _lastPlacedOrderId = null;
    _lastPlacedOrderNumber = null;
    _lastPlacedWasQuickDelivery = false;
    _currentDeliveryOptions = [
      DeliveryOption.normal().copyWith(isAvailable: true),
      // DeliveryOption.oneDay().copyWith(isAvailable: true),
      DeliveryOption.express().copyWith(isAvailable: true),
    ];

    emit(const CheckoutInitial());
  }

  /// Handle place order event (new flow - step 1)
  ///
  /// This creates the order in our database via POST /orders/place
  /// The backend returns an order response with our internal order ID
  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    if (_selectedItemIds.isEmpty ||
        _selectedAddress == null ||
        _selectedDeliveryOption == null) {
      emit(const CheckoutError('Invalid checkout state'));
      return;
    }

    emit(const OrderCreating());

    final params = PlaceOrderParams(
      addressId: _selectedAddress!.id,
      warehouseId: '1', // Default warehouse
      deliveryType: _selectedDeliveryOption!.type,
      paymentMethod: _selectedPaymentMethod.type.value,
      vendorId: '8', // Default vendor
      extraCharges: _extraCharges,
    );

    final result = await _placeOrder(params);

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to place order', {
          'error': failure.message,
        });
        emit(CheckoutError(failure.message));
      },
      (response) {
        _log.infoWithContext('Order placed successfully', {
          'orderId': response.orderId,
          'orderNumber': response.orderNumber,
        });

        _lastPlacedOrderId = response.orderId;
        _lastPlacedOrderNumber = response.orderNumber;
        _lastPlacedWasQuickDelivery = _selectedDeliveryOption?.type == '30_min';

        emit(
          OrderPlaced(
            orderId: response.orderId,
            orderNumber: response.orderNumber,
            message: response.message,
          ),
        );
      },
    );
  }

  /// Handle initiate payment event (new flow - step 2)
  ///
  /// This calls POST /payments/create with our order_id
  /// Backend creates a Razorpay order and returns:
  /// - razorpay_order_id: The Razorpay order ID to use in checkout
  /// - amount: Amount in paise
  /// - currency: "INR"
  /// - razorpay_key: The PUBLIC Razorpay key (rzp_test_* or rzp_live_*)
  ///
  /// SECURITY: The Razorpay SECRET key is only on the backend
  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const PaymentInitiating());

    final params = InitiatePaymentParams(
      orderId: event.orderId.toString(),
      gateway: 'razorpay',
    );

    final result = await _initiatePayment(params);

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to initiate payment', {
          'error': failure.message,
        });
        emit(CheckoutError(failure.message));
      },
      (response) {
        _log.infoWithContext('Payment initiated successfully', {
          'razorpayOrderId': response.razorpayOrderId,
          'amount': response.amountInPaise,
          'razorpayKey': response.razorpayKey,
          'hasRazorpayKey':
              response.razorpayKey != null && response.razorpayKey!.isNotEmpty,
        });

        if (response.razorpayKey == null || response.razorpayKey!.isEmpty) {
          _log.errorWithContext('Backend did not return Razorpay key', {
            'response': response.toString(),
          });
          emit(
            const CheckoutError(
              'Payment gateway configuration error: Missing Razorpay key',
            ),
          );
          return;
        }

        emit(
          PaymentInitiated(
            razorpayOrderId: response.razorpayOrderId,
            amountInPaise: response.amountInPaise,
            razorpayKey: response.razorpayKey,
          ),
        );
      },
    );
  }

  /// Handle verify payment event (new flow - step 3)
  ///
  /// CRITICAL: This is where payment security happens!
  ///
  /// After Razorpay checkout completes, we receive:
  /// - razorpay_order_id
  /// - razorpay_payment_id
  /// - razorpay_signature (HMAC SHA256)
  ///
  /// We send these to POST /payments/verify where:
  /// 1. Backend verifies signature using SECRET key
  /// 2. Backend updates payment status in database
  /// 3. Backend updates order status
  /// 4. Backend returns verification result
  ///
  /// NEVER trust payment success from client alone!
  /// Always wait for backend verification before showing success.
  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const PaymentVerifying());

    final params = VerifyPaymentParams(
      razorpayOrderId: event.razorpayOrderId,
      razorpayPaymentId: event.razorpayPaymentId,
      razorpaySignature: event.razorpaySignature,
    );

    final result = await _verifyPayment(params);

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to verify payment', {
          'error': failure.message,
        });
        emit(CheckoutError(failure.message));
      },
      (response) {
        if (response.verified) {
          _log.infoWithContext('Payment verified successfully', {
            'paymentId': response.paymentId,
          });
          emit(
            PaymentVerified(
              message: response.message,
              orderId: _lastPlacedOrderId,
              orderNumber: _lastPlacedOrderNumber,
              isQuickDelivery: _lastPlacedWasQuickDelivery,
            ),
          );
        } else {
          _log.errorWithContext('Payment verification failed', {
            'message': response.message,
          });
          emit(
            CheckoutError(response.message ?? 'Payment verification failed'),
          );
        }
      },
    );
  }

  /// Helper method to emit CheckoutCalculated with simple cart totals
  // ignore: unused_element
  void _emitSimpleCheckoutCalculated(Emitter<CheckoutState> emit) {
    final selectedItems = _allItems
        .where((item) => _selectedItemIds.contains(item.id))
        .toList();

    final subtotal = selectedItems.fold(0, (sum, item) => sum + item.total);

    // Create simple price breakdown with no taxes or delivery charges
    final priceBreakdown = PriceBreakdown(
      itemTotal: subtotal,
      deliveryCharges: 0,
      cgst: 0,
      sgst: 0,
      discount: 0,
      grandTotal: subtotal,
    );

    // Create checkout summary
    final summary = CheckoutSummary(
      items: selectedItems,
      priceBreakdown: priceBreakdown,
      deliveryOption: _selectedDeliveryOption ?? DeliveryOption.normal(),
      selectedAddress: _selectedAddress,
    );

    emit(CheckoutCalculated(summary: summary, appliedCoupon: _appliedCoupon));
  }

  /// Get selected payment method
  PaymentMethodSelection get selectedPaymentMethod => _selectedPaymentMethod;

  /// Get selected delivery option
  DeliveryOption? get selectedDeliveryOption => _selectedDeliveryOption;

  /// Get selected address
  Address? get selectedAddress => _selectedAddress;

  /// Expose the extra charges captured during item selection so the
  /// review page can render them inside the price breakdown.
  List<ExtraCharge> get extraChargesForReview => List.unmodifiable(_extraCharges);

  /// Get the current cart delivery mode (set after address selection)
  CartDeliveryMode get cartDeliveryMode => _cartDeliveryMode;

  /// Build the two canonical delivery options based on current state.
  /// Used by the widget when in [CheckoutCalculated] state (no dedicated
  /// [DeliveryOptionsLoaded] state is emitted simultaneously).
  List<DeliveryOption> get currentDeliveryOptions {
    return _currentDeliveryOptions;
  }
}
