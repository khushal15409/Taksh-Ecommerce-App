import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/data/models/extra_charge_model.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';
import 'package:taksh_e_commerce/features/cart/data/models/cart_item_model.dart';

class CartModel extends Cart {
  final List<CartItemModel> itemModels;

  const CartModel({
    required this.itemModels,
    required super.total,
    super.guestToken,
    super.extraCharges,
    super.deliveryChargeCode,
    super.deliveryEstimatedMinutes,
    super.deliveryChargePrice,
    super.totalWithDelivery,
  }) : super(items: itemModels);

  factory CartModel.fromJson(DataMap json) {
    final itemsRaw = (json['items'] as List<dynamic>?) ?? const [];

    final itemModels = itemsRaw.map((raw) {
      final itemJson = (raw as Map).cast<String, dynamic>();
      return CartItemModel.fromJson(itemJson);
    }).toList();

    final totalRaw = json['total'];
    final total = totalRaw is num
        ? totalRaw.toInt()
        : int.tryParse(totalRaw?.toString() ?? '') ?? 0;

    final totalWithDeliveryRaw = json['total_with_delivery'];
    final totalWithDelivery = totalWithDeliveryRaw is num
        ? totalWithDeliveryRaw.toInt()
        : int.tryParse(totalWithDeliveryRaw?.toString() ?? '');

    final deliveryChargeRaw = json['delivery_charge'];
    final deliveryCharge = deliveryChargeRaw is Map
        ? deliveryChargeRaw.cast<String, dynamic>()
        : const <String, dynamic>{};

    final deliveryChargeCode = deliveryCharge['code']?.toString();
    final deliveryEstimatedMinutesRaw = deliveryCharge['estimated_minutes'];
    final deliveryEstimatedMinutes = deliveryEstimatedMinutesRaw is num
        ? deliveryEstimatedMinutesRaw.toInt()
        : int.tryParse(deliveryEstimatedMinutesRaw?.toString() ?? '');
    final deliveryChargePriceRaw = deliveryCharge['price'];
    final deliveryChargePrice = deliveryChargePriceRaw is num
        ? deliveryChargePriceRaw.toDouble()
        : double.tryParse(deliveryChargePriceRaw?.toString() ?? '');

    final chargesRaw = (json['charges'] as List<dynamic>?) ?? const [];
    final extraCharges = chargesRaw
        .whereType<Map>()
        .map((raw) => ExtraChargeModel.fromJson(raw.cast<String, dynamic>()))
        .toList();

    return CartModel(
      itemModels: itemModels,
      total: total,
      guestToken: json['guest_token'] as String?,
      extraCharges: extraCharges,
      deliveryChargeCode: deliveryChargeCode,
      deliveryEstimatedMinutes: deliveryEstimatedMinutes,
      deliveryChargePrice: deliveryChargePrice,
      totalWithDelivery: totalWithDelivery,
    );
  }

  DataMap toJson() => {
    'total': total,
    'total_with_delivery': totalWithDelivery,
    'guest_token': guestToken,
    'items': itemModels.map((e) => e.toJson()).toList(),
    'delivery_charge': {
      'code': deliveryChargeCode,
      'estimated_minutes': deliveryEstimatedMinutes,
      'price': deliveryChargePrice,
    },
    'charges': extraCharges
        .map((charge) => ExtraChargeModel.fromEntity(charge).toJson())
        .toList(),
  };
}
