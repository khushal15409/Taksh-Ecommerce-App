import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/express_products_response.dart';
import 'package:taksh_e_commerce/features/product/data/models/fulfillment_center_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/product_model.dart';

part 'express_products_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ExpressProductsResponseModel extends ExpressProductsResponse {
  @JsonKey(name: 'fulfillment_center')
  final FulfillmentCenterModel fulfillmentCenterModel;

  @JsonKey(name: 'products')
  final List<ProductModel> productModels;

  @JsonKey(name: 'pagination')
  final PaginationData paginationData;

  ExpressProductsResponseModel({
    required this.fulfillmentCenterModel,
    required this.productModels,
    required this.paginationData,
  }) : super(
          fulfillmentCenter: fulfillmentCenterModel,
          products: productModels,
          currentPage: paginationData.currentPage,
          perPage: paginationData.perPage,
          total: paginationData.total,
          lastPage: paginationData.lastPage,
          from: paginationData.from,
          to: paginationData.to,
        );

  factory ExpressProductsResponseModel.fromJson(DataMap json) =>
      _$ExpressProductsResponseModelFromJson(json);

  DataMap toJson() => _$ExpressProductsResponseModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PaginationData {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int? from;
  final int? to;

  const PaginationData({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    this.from,
    this.to,
  });

  factory PaginationData.fromJson(DataMap json) =>
      _$PaginationDataFromJson(json);

  DataMap toJson() => _$PaginationDataToJson(this);
}
