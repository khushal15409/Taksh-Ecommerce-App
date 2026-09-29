import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/data/models/paginated_orders_model.dart';

part 'orders_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrdersResponseModel {
  final bool success;
  final String message;
  final PaginatedOrdersModel? data;

  const OrdersResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory OrdersResponseModel.fromJson(DataMap json) =>
      _$OrdersResponseModelFromJson(json);

  DataMap toJson() => _$OrdersResponseModelToJson(this);
}
