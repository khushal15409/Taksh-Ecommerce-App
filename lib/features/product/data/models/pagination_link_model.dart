import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/pagination_link.dart';

part 'pagination_link_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaginationLinkModel extends PaginationLink {
  const PaginationLinkModel({
    super.url,
    required super.label,
    super.page,
    required super.active,
  });

  factory PaginationLinkModel.fromJson(DataMap json) =>
      _$PaginationLinkModelFromJson(json);

  DataMap toJson() => _$PaginationLinkModelToJson(this);
}
