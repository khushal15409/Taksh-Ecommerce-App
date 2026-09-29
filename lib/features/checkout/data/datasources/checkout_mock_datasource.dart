import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/data/models/address_model.dart';
import 'package:taksh_e_commerce/features/address/data/models/location_model.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address_type.dart';
import 'package:taksh_e_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';
import 'package:taksh_e_commerce/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:taksh_e_commerce/features/checkout/data/models/checkout_summary_model.dart';
import 'package:taksh_e_commerce/features/checkout/data/models/delivery_option_model.dart';
import 'package:taksh_e_commerce/features/checkout/data/models/place_order_response_model.dart';
import 'package:taksh_e_commerce/features/checkout/data/models/price_breakdown_model.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_address_model.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_item_model.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_model.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_location_model.dart';

/// Mock implementation of CheckoutRemoteDataSource for development/testing
class CheckoutMockDataSource implements CheckoutRemoteDataSource {
  final _log = loggerWithContext({
    'feature': 'checkout',
    'layer': 'datasource',
    'type': 'mock',
  });

  // Store cart items - will be populated from actual cart
  static final List<CartItemModel> _cartItems = [];

  // Method to set cart items (should be called before checkout)
  static void setCartItems(List<CartItemModel> items) {
    _cartItems.clear();
    _cartItems.addAll(items);
  }

  // Mock data (fallback only)
  final List<CartItemModel> _mockCartItems = [
    const CartItemModel(
      id: 1,
      productVariantId: 101,
      productName: 'Fresh Milk',
      sku: 'MILK-001',
      price: '55',
      qty: 2,
      total: 110,
      image: 'https://via.placeholder.com/150',
    ),
    const CartItemModel(
      id: 2,
      productVariantId: 102,
      productName: 'Bread',
      sku: 'BREAD-001',
      price: '40',
      qty: 1,
      total: 40,
      image: 'https://via.placeholder.com/150',
    ),
  ];

  final AddressModel _mockAddress = AddressModel(
    id: '1',
    userId: '1',
    type: AddressType.home,
    customLabel: null,
    recipientName: 'John Doe',
    recipientPhone: '9876543210',
    location: const LocationModel(
      latitude: 12.9716,
      longitude: 77.5946,
      city: 'Bangalore',
      state: 'Karnataka',
      country: 'India',
      postalCode: '560001',
      formattedAddress:
          '123 Main Street, Koramangala, Bangalore, Karnataka 560001',
      street: 'Main Street',
    ),
    addressLine1: '123 Main Street',
    addressLine2: 'Koramangala',
    landmark: 'Near Coffee Shop',
    instructions: 'Ring the bell',
    isDefault: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );

  @override
  Future<CheckoutSummaryModel> calculateCheckout({
    required List<int> cartItemIds,
    required String deliveryType,
    String? addressId,
    String? couponCode,
  }) async {
    _log.infoWithContext('Calculating checkout', {
      'itemIds': cartItemIds,
      'deliveryType': deliveryType,
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Use actual cart items if available, otherwise fall back to mock
    final itemsSource = _cartItems.isNotEmpty ? _cartItems : _mockCartItems;

    // Filter items based on selected IDs
    final selectedItems = itemsSource
        .where((item) => cartItemIds.contains(item.id))
        .toList();

    // Calculate totals
    final itemTotal = selectedItems.fold(0, (sum, item) => sum + item.total);
    const deliveryCharges = 0; // No delivery charges for either type
    final cgst = (itemTotal * 0.025).round(); // 2.5% CGST
    final sgst = (itemTotal * 0.025).round(); // 2.5% SGST
    final discount = couponCode != null ? 1000 : 0; // ₹10 discount if coupon
    final grandTotal = itemTotal + deliveryCharges + cgst + sgst - discount;

    final priceBreakdown = PriceBreakdownModel(
      itemTotal: itemTotal,
      deliveryCharges: deliveryCharges,
      cgst: cgst,
      sgst: sgst,
      discount: discount,
      grandTotal: grandTotal,
    );

    final deliveryOption = deliveryType == '30_min'
        ? const DeliveryOptionModel(
            type: '30_min',
            displayName: 'Express Delivery',
            charges: 0,
            slaMinutes: 30,
            isAvailable: true,
          )
        : const DeliveryOptionModel(
            type: 'normal',
            displayName: 'Standard Delivery',
            charges: 0,
            slaMinutes: 1440,
            isAvailable: true,
          );

    return CheckoutSummaryModel(
      itemModels: selectedItems,
      priceBreakdownModel: priceBreakdown,
      deliveryOptionModel: deliveryOption,
      selectedAddressModel: addressId != null ? _mockAddress : null,
    );
  }

  @override
  Future<List<DeliveryOptionModel>> getDeliveryOptions({
    required String addressId,
  }) async {
    _log.infoWithContext('Getting delivery options', {'addressId': addressId});

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      DeliveryOptionModel(
        type: 'normal',
        displayName: 'Standard Delivery',
        charges: 0,
        slaMinutes: 1440,
        isAvailable: true,
      ),
      DeliveryOptionModel(
        type: '30_min',
        displayName: 'Express Delivery',
        charges: 0,
        slaMinutes: 30,
        isAvailable: true,
      ),
    ];
  }

  @override
  Future<bool> validateCheckout({required DataMap orderRequest}) async {
    _log.infoWithContext('Validating checkout', orderRequest);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock validation - always returns true
    return true;
  }

  @override
  Future<OrderModel> createOrder({required DataMap orderRequest}) async {
    _log.infoWithContext('Creating order', orderRequest);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Create mock order
    final now = DateTime.now();
    final orderNumber = 'ORD-${now.millisecondsSinceEpoch}';

    final cartItemIds = orderRequest['cart_item_ids'] as List<dynamic>;
    final selectedItems = _mockCartItems
        .where((item) => cartItemIds.contains(item.id))
        .toList();

    final deliveryType = orderRequest['delivery_type'] as String;
    final slaMinutes = deliveryType == '30_min' ? 30 : 1440;

    return OrderModel(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: 1,
      warehouseId: 1,
      fulfillmentCenterId: null,
      deliveryManId: null,
      addressId: 1,
      orderNumber: orderNumber,
      deliveryType: deliveryType,
      isExpress: orderRequest['is_express'] as bool,
      slaMinutes: slaMinutes,
      estimatedDeliveryTime: now.add(Duration(minutes: slaMinutes)),
      confirmedAt: null,
      deliveredAt: null,
      paymentMethod: orderRequest['payment_method'] as String,
      paymentStatus: 'pending',
      orderStatus: 'pending_payment',
      totalAmount: '${orderRequest['expected_total']}',
      createdAt: now,
      updatedAt: now,
      itemModels: selectedItems.map((item) {
        return OrderItemModel(
          id: item.id,
          orderId: 0,
          productVariantId: item.productVariantId,
          qty: item.qty,
          price: item.price,
          createdAt: now,
          updatedAt: now,
        );
      }).toList(),
      addressModel: OrderAddressModel(
        id: 1,
        userId: 1,
        stateId: 1,
        cityId: 1,
        areaId: 1,
        name: 'Home',
        mobile: '1234567890',
        pincode: '560001',
        addressLine1: _mockAddress.addressLine1,
        addressLine2: _mockAddress.addressLine2,
        landmark: _mockAddress.landmark,
        type: 'home',
        isDefault: true,
        createdAt: now,
        updatedAt: now,
        stateModel: OrderLocationModel(
          id: 1,
          name: _mockAddress.location.state ?? 'Karnataka',
          parentId: null,
          createdAt: now,
          updatedAt: now,
        ),
        cityModel: OrderLocationModel(
          id: 1,
          name: _mockAddress.location.city ?? 'Bangalore',
          parentId: 1,
          createdAt: now,
          updatedAt: now,
        ),
        areaModel: OrderLocationModel(
          id: 1,
          name: 'Koramangala',
          parentId: 1,
          createdAt: now,
          updatedAt: now,
        ),
      ),
      warehouseModel: null,
    );
  }

  @override
  Future<PlaceOrderResponseModel> placeOrder({
    required String addressId,
    required String warehouseId,
    required String deliveryType,
    required String paymentMethod,
    required String vendorId,
    required List<ExtraCharge> extraCharges,
  }) async {
    _log.infoWithContext('Placing order', {
      'addressId': addressId,
      'warehouseId': warehouseId,
      'deliveryType': deliveryType,
      'paymentMethod': paymentMethod,
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Generate order ID
    final orderId = DateTime.now().millisecondsSinceEpoch;
    final orderNumber = 'ORD-$orderId';

    return PlaceOrderResponseModel(
      orderId: orderId,
      orderNumber: orderNumber,
      status: 'success',
      message: 'Order placed successfully',
      totalAmount: '15000',
      paymentStatus: 'pending',
      orderStatus: 'pending',
    );
  }
}
