import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/paginated_products.dart';
import 'package:taksh_e_commerce/features/product/data/models/product_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/pagination_link_model.dart';

part 'paginated_products_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PaginatedProductsModel extends PaginatedProducts {
  @JsonKey(name: 'data')
  final List<ProductModel> productModels;

  @JsonKey(name: 'links')
  final List<PaginationLinkModel>? linkModels;

  const PaginatedProductsModel({
    required super.currentPage,
    required this.productModels,
    required super.firstPageUrl,
    super.from,
    required super.lastPage,
    required super.lastPageUrl,
    this.linkModels,
    super.nextPageUrl,
    required super.path,
    required super.perPage,
    super.prevPageUrl,
    super.to,
    required super.total,
  }) : super(
          products: productModels,
          links: linkModels,
        );

  factory PaginatedProductsModel.fromJson(DataMap json) =>
      _$PaginatedProductsModelFromJson(json);

  DataMap toJson() => _$PaginatedProductsModelToJson(this);
}
