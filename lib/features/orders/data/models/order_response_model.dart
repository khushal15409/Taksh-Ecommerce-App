import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_model.dart';

part 'order_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderResponseModel {
  final bool success;
  final String message;
  final OrderModel? data;

  const OrderResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory OrderResponseModel.fromJson(DataMap json) {
    bool parseBool(dynamic value, {bool fallback = false}) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final normalized = value.trim().toLowerCase();
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

    final dataJson = json['data'];

    return OrderResponseModel(
      success: parseBool(json['success']),
      message: parseString(json['message']),
      data: dataJson is Map<String, dynamic>
          ? OrderModel.fromJson(dataJson)
          : null,
    );
  }

  DataMap toJson() => _$OrderResponseModelToJson(this);
}
