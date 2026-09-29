import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_item.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_address.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_charge.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_warehouse.dart';

/// Order entity representing a customer order
class Order extends Equatable {
  final int id;
  final int userId;
  final int? warehouseId;
  final int? fulfillmentCenterId;
  final int? deliveryManId;
  final int addressId;
  final String orderNumber;
  final String deliveryType;
  final bool isExpress;
  final int slaMinutes;
  final DateTime? estimatedDeliveryTime;
  final DateTime? confirmedAt;
  final DateTime? deliveredAt;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String totalAmount;
  final String? subtotalAmount;
  final String? deliveryCharges;
  final String? platformFee;
  final String? cgst;
  final String? sgst;
  final String? discountAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> items;
  final List<OrderCharge> extraCharges;
  final OrderAddress? address;
  final OrderWarehouse? warehouse;

  const Order({
    required this.id,
    required this.userId,
    this.warehouseId,
    this.fulfillmentCenterId,
    this.deliveryManId,
    required this.addressId,
    required this.orderNumber,
    required this.deliveryType,
    required this.isExpress,
    required this.slaMinutes,
    this.estimatedDeliveryTime,
    this.confirmedAt,
    this.deliveredAt,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.totalAmount,
    this.subtotalAmount,
    this.deliveryCharges,
    this.platformFee,
    this.cgst,
    this.sgst,
    this.discountAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    this.extraCharges = const [],
    this.address,
    this.warehouse,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    warehouseId,
    fulfillmentCenterId,
    deliveryManId,
    addressId,
    orderNumber,
    deliveryType,
    isExpress,
    slaMinutes,
    estimatedDeliveryTime,
    confirmedAt,
    deliveredAt,
    paymentMethod,
    paymentStatus,
    orderStatus,
    totalAmount,
    subtotalAmount,
    deliveryCharges,
    platformFee,
    cgst,
    sgst,
    discountAmount,
    createdAt,
    updatedAt,
    items,
    extraCharges,
    address,
    warehouse,
  ];

  @override
  String toString() {
    return 'Order(id: $id, orderNumber: $orderNumber, status: $orderStatus, total: $totalAmount)';
  }
}
