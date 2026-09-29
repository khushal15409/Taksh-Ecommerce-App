import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_charge.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_item_model.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_address_model.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_warehouse_model.dart';

class OrderModel extends Order {
  final List<OrderItemModel>? itemModels;
  final OrderAddressModel? addressModel;
  final OrderWarehouseModel? warehouseModel;

  const OrderModel({
    required super.id,
    required super.userId,
    super.warehouseId,
    super.fulfillmentCenterId,
    super.deliveryManId,
    required super.addressId,
    required super.orderNumber,
    required super.deliveryType,
    required super.isExpress,
    required super.slaMinutes,
    super.estimatedDeliveryTime,
    super.confirmedAt,
    super.deliveredAt,
    required super.paymentMethod,
    required super.paymentStatus,
    required super.orderStatus,
    required super.totalAmount,
    super.subtotalAmount,
    super.deliveryCharges,
    super.platformFee,
    super.cgst,
    super.sgst,
    super.discountAmount,
    required super.createdAt,
    required super.updatedAt,
    super.extraCharges,
    this.itemModels,
    this.addressModel,
    this.warehouseModel,
  }) : super(
         items: itemModels ?? const [],
         address: addressModel,
         warehouse: warehouseModel,
       );

  factory OrderModel.fromJson(DataMap json) {
    DateTime? parseOptionalDate(dynamic value) {
      if (value == null) return null;
      if (value is String && value.trim().isNotEmpty) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    DateTime parseRequiredDate(dynamic value) {
      return parseOptionalDate(value) ?? DateTime.now();
    }

    int parseRequiredInt(dynamic value, {int fallback = 0}) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    bool parseBool(dynamic value, {bool fallback = false}) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final normalized = value.toLowerCase();
        if (normalized == 'true' || normalized == '1') return true;
        if (normalized == 'false' || normalized == '0') return false;
      }
      return fallback;
    }

    String parseString(dynamic value, {String fallback = ''}) {
      if (value == null) return fallback;
      if (value is String) return value;
      return value.toString();
    }

    String? parseOptionalString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      return value.toString();
    }

    String? parseNonEmptyString(dynamic value) {
      final parsed = parseOptionalString(value)?.trim();
      if (parsed == null || parsed.isEmpty || parsed.toLowerCase() == 'null') {
        return null;
      }
      return parsed;
    }

    double? parseAmount(dynamic value) {
      final normalized = parseNonEmptyString(value);
      if (normalized == null) return null;
      return double.tryParse(normalized.replaceAll(',', ''));
    }

    double? firstAmount(Iterable<dynamic> values) {
      for (final value in values) {
        final parsed = parseAmount(value);
        if (parsed != null) {
          return parsed;
        }
      }
      return null;
    }

    String? formatAmount(double? value) {
      if (value == null) return null;

      final roundedValue = double.parse(value.toStringAsFixed(2));
      if (roundedValue == roundedValue.truncateToDouble()) {
        return roundedValue.toStringAsFixed(0);
      }

      return roundedValue.toStringAsFixed(2);
    }

    List<OrderCharge> parseExtraCharges(dynamic value) {
      if (value is! List) return const [];

      return value.whereType<Map>().map((charge) {
        final chargeMap = charge.cast<String, dynamic>();
        final label = parseString(chargeMap['label']).trim();
        final type = parseString(chargeMap['type'], fallback: 'extra_charge');
        final amount = parseString(chargeMap['amount'], fallback: '0');
        final normalizedLabel = label.isNotEmpty
            ? label
            : type
                  .replaceAll('_', ' ')
                  .replaceAllMapped(
                    RegExp(r'(^|\s)(\w)'),
                    (m) => m.group(0)!.toUpperCase(),
                  );

        return OrderCharge(
          type: type,
          label: normalizedLabel,
          amount: amount,
          isDiscount: parseBool(chargeMap['is_discount']),
          sortOrder: chargeMap['sort_order'] == null
              ? null
              : parseRequiredInt(chargeMap['sort_order']),
        );
      }).toList();
    }

    final itemsJson = json['items'];
    final parsedItems = itemsJson is List
        ? itemsJson
              .whereType<Map<String, dynamic>>()
              .map(OrderItemModel.fromJson)
              .toList()
        : <OrderItemModel>[];

    final addressJson = json['address'];
    final vendorJson = json['vendor'];
    final latestPaymentJson = json['latest_payment'];
    final latestPayment = latestPaymentJson is Map<String, dynamic>
        ? latestPaymentJson
        : null;
    final paymentsJson = json['payments'];
    final payments = paymentsJson is List
        ? paymentsJson.whereType<Map<String, dynamic>>().toList()
        : const <Map<String, dynamic>>[];
    final fallbackPayment =
        latestPayment ?? (payments.isNotEmpty ? payments.last : null);

    final deliveryTypeRaw = parseString(
      json['delivery_type'],
      fallback: 'normal',
    );
    final deliveryChargeRaw = json['delivery_charge'];
    final priceBreakdownRaw = json['price_breakdown'];
    final deliveryCharge = deliveryChargeRaw is Map<String, dynamic>
        ? deliveryChargeRaw
        : null;
    final priceBreakdown = priceBreakdownRaw is Map<String, dynamic>
        ? priceBreakdownRaw
        : null;

    final paymentMethod =
        parseOptionalString(json['payment_method']) ??
        parseOptionalString(fallbackPayment?['method']) ??
        parseOptionalString(fallbackPayment?['gateway']) ??
        'unknown';
    final paymentStatus =
        parseOptionalString(json['payment_status']) ??
        parseOptionalString(fallbackPayment?['status']) ??
        'pending';

    final deliveryChargeAmount = parseOptionalString(deliveryCharge?['price']);
    final parsedExtraCharges = parseExtraCharges(
      json['extra_charges'] ?? json['charges'],
    );

    final itemsSubtotal = parsedItems.fold<double>(0, (sum, item) {
      final itemPrice = parseAmount(item.price) ?? 0;
      return sum + (itemPrice * item.qty);
    });

    final subtotalAmountValue = firstAmount([
      json['subtotal_amount'],
      json['subtotal'],
      json['sub_total'],
      json['item_total'],
      json['items_total'],
      json['product_total'],
      priceBreakdown?['item_total'],
      priceBreakdown?['subtotal'],
    ]);
    final deliveryChargesValue = firstAmount([
      json['delivery_charges'],
      json['delivery_charge_amount'],
      deliveryChargeAmount,
      deliveryCharge?['amount'],
      priceBreakdown?['delivery_charges'],
    ]);
    final platformFeeValue = firstAmount([
      json['platform_fee'],
      priceBreakdown?['platform_fee'],
    ]);
    final cgstValue = firstAmount([json['cgst'], priceBreakdown?['cgst']]);
    final sgstValue = firstAmount([json['sgst'], priceBreakdown?['sgst']]);
    final discountAmountValue = firstAmount([
      json['discount'],
      json['discount_amount'],
      json['coupon_discount'],
      priceBreakdown?['discount'],
    ]);
    final totalAmountValue = firstAmount([
      json['total_amount'],
      json['total_with_delivery'],
      json['grand_total'],
      json['final_total'],
      json['payable_amount'],
      json['amount_payable'],
      json['total_price'],
      json['total'],
      priceBreakdown?['grand_total'],
    ]);

    final resolvedSubtotalValue =
        subtotalAmountValue ?? (itemsSubtotal > 0 ? itemsSubtotal : null);
    double? resolvedTotalValue = totalAmountValue;

    if ((resolvedTotalValue == null || resolvedTotalValue == 0) &&
        resolvedSubtotalValue != null &&
        resolvedSubtotalValue > 0) {
      final fallbackTotal =
          resolvedSubtotalValue +
          (deliveryChargesValue ?? 0) +
          (platformFeeValue ?? 0) +
          (cgstValue ?? 0) +
          (sgstValue ?? 0) -
          (discountAmountValue ?? 0);

      resolvedTotalValue = fallbackTotal > 0
          ? fallbackTotal
          : resolvedSubtotalValue;
    }

    return OrderModel(
      id: parseRequiredInt(json['id']),
      userId: parseRequiredInt(json['user_id']),
      warehouseId: json['warehouse_id'] == null
          ? null
          : parseRequiredInt(json['warehouse_id']),
      fulfillmentCenterId: json['fulfillment_center_id'] == null
          ? null
          : parseRequiredInt(json['fulfillment_center_id']),
      deliveryManId: json['delivery_man_id'] == null
          ? null
          : parseRequiredInt(json['delivery_man_id']),
      addressId: parseRequiredInt(json['address_id']),
      orderNumber: parseString(json['order_number'], fallback: 'N/A'),
      deliveryType: deliveryTypeRaw,
      isExpress: parseBool(json['is_express']) || deliveryTypeRaw == '30_min',
      slaMinutes: parseRequiredInt(json['sla_minutes']),
      estimatedDeliveryTime: parseOptionalDate(json['estimated_delivery_time']),
      confirmedAt: parseOptionalDate(json['confirmed_at']),
      deliveredAt: parseOptionalDate(json['delivered_at']),
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      orderStatus: parseString(json['order_status'], fallback: 'placed'),
      totalAmount:
          formatAmount(resolvedTotalValue) ??
          parseString(
            json['total_amount'] ??
                json['total_with_delivery'] ??
                json['grand_total'] ??
                json['final_total'] ??
                json['payable_amount'] ??
                json['amount_payable'] ??
                json['total_price'] ??
                json['total'],
            fallback: '0',
          ),
      subtotalAmount:
          formatAmount(resolvedSubtotalValue) ??
          parseString(
            json['subtotal_amount'] ??
                json['subtotal'] ??
                json['sub_total'] ??
                json['item_total'] ??
                json['items_total'] ??
                json['product_total'],
          ),
      deliveryCharges:
          formatAmount(deliveryChargesValue) ??
          parseString(
            json['delivery_charges'] ??
                json['delivery_charge_amount'] ??
                deliveryChargeAmount,
          ),
      platformFee:
          formatAmount(platformFeeValue) ?? parseString(json['platform_fee']),
      cgst: formatAmount(cgstValue) ?? parseString(json['cgst']),
      sgst: formatAmount(sgstValue) ?? parseString(json['sgst']),
      discountAmount:
          formatAmount(discountAmountValue) ??
          parseString(json['discount'] ?? json['discount_amount']),
      createdAt: parseRequiredDate(json['created_at']),
      updatedAt: parseRequiredDate(json['updated_at']),
      itemModels: parsedItems,
      extraCharges: parsedExtraCharges,
      addressModel: addressJson is Map<String, dynamic>
          ? OrderAddressModel.fromJson(addressJson)
          : null,
      warehouseModel: vendorJson is Map<String, dynamic>
          ? OrderWarehouseModel.fromJson(vendorJson)
          : null,
    );
  }

  DataMap toJson() => {
    'id': id,
    'user_id': userId,
    'warehouse_id': warehouseId,
    'fulfillment_center_id': fulfillmentCenterId,
    'delivery_man_id': deliveryManId,
    'address_id': addressId,
    'order_number': orderNumber,
    'delivery_type': deliveryType,
    'is_express': isExpress,
    'sla_minutes': slaMinutes,
    'estimated_delivery_time': estimatedDeliveryTime?.toIso8601String(),
    'confirmed_at': confirmedAt?.toIso8601String(),
    'delivered_at': deliveredAt?.toIso8601String(),
    'payment_method': paymentMethod,
    'payment_status': paymentStatus,
    'order_status': orderStatus,
    'total_amount': totalAmount,
    'subtotal_amount': subtotalAmount,
    'delivery_charges': deliveryCharges,
    'platform_fee': platformFee,
    'cgst': cgst,
    'sgst': sgst,
    'discount_amount': discountAmount,
    'extra_charges': extraCharges
        .map(
          (c) => {
            'type': c.type,
            'label': c.label,
            'amount': c.amount,
            'is_discount': c.isDiscount,
            if (c.sortOrder != null) 'sort_order': c.sortOrder,
          },
        )
        .toList(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'items': itemModels?.map((e) => e.toJson()).toList(),
    'address': addressModel?.toJson(),
    'vendor': warehouseModel?.toJson(),
  };
}
