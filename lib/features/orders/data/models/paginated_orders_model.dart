import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/paginated_orders.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_model.dart';
import 'package:taksh_e_commerce/features/orders/data/models/pagination_link_model.dart';

part 'paginated_orders_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PaginatedOrdersModel extends PaginatedOrders {
  @JsonKey(name: 'data')
  final List<OrderModel> orderModels;

  @JsonKey(name: 'links')
  final List<PaginationLinkModel> linkModels;

  const PaginatedOrdersModel({
    required super.currentPage,
    required this.orderModels,
    required super.firstPageUrl,
    super.from,
    required super.lastPage,
    required super.lastPageUrl,
    required this.linkModels,
    super.nextPageUrl,
    required super.path,
    required super.perPage,
    super.prevPageUrl,
    super.to,
    required super.total,
  }) : super(orders: orderModels, links: linkModels);

  factory PaginatedOrdersModel.fromJson(DataMap json) {
    int parseRequiredInt(dynamic value, {int fallback = 0}) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    String parseRequiredString(dynamic value, {String fallback = ''}) {
      if (value == null) return fallback;
      if (value is String) return value;
      return value.toString();
    }

    final ordersJson = json['data'];
    final linksJson = json['links'];

    final parsedOrders = ordersJson is List
        ? ordersJson
              .whereType<Map<String, dynamic>>()
              .map(OrderModel.fromJson)
              .toList()
        : <OrderModel>[];

    final parsedLinks = linksJson is List
        ? linksJson
              .whereType<Map<String, dynamic>>()
              .map(PaginationLinkModel.fromJson)
              .toList()
        : <PaginationLinkModel>[];

    return PaginatedOrdersModel(
      currentPage: parseRequiredInt(json['current_page'], fallback: 1),
      orderModels: parsedOrders,
      firstPageUrl: parseRequiredString(json['first_page_url']),
      from: json['from'] == null ? null : parseRequiredInt(json['from']),
      lastPage: parseRequiredInt(json['last_page'], fallback: 1),
      lastPageUrl: parseRequiredString(json['last_page_url']),
      linkModels: parsedLinks,
      nextPageUrl: json['next_page_url']?.toString(),
      path: parseRequiredString(json['path']),
      perPage: parseRequiredInt(json['per_page']),
      prevPageUrl: json['prev_page_url']?.toString(),
      to: json['to'] == null ? null : parseRequiredInt(json['to']),
      total: parseRequiredInt(json['total']),
    );
  }

  DataMap toJson() => _$PaginatedOrdersModelToJson(this);
}
