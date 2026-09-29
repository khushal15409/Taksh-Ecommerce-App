import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/brand.dart';

part 'brand_model.g.dart';

/// Brand model with JSON serialization
@JsonSerializable(fieldRename: FieldRename.snake)
class BrandModel extends Brand {
  const BrandModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory BrandModel.fromEntity(Brand brand) {
    return BrandModel(
      id: brand.id,
      name: brand.name,
      slug: brand.slug,
      status: brand.status,
      createdAt: brand.createdAt,
      updatedAt: brand.updatedAt,
    );
  }

  factory BrandModel.fromJson(DataMap json) {
    final processedJson = Map<String, dynamic>.from(json);
    // Express API may not return slug or status for brands
    processedJson.putIfAbsent('slug', () => '');
    processedJson.putIfAbsent('status', () => 'active');
    return _$BrandModelFromJson(processedJson);
  }

  DataMap toJson() => _$BrandModelToJson(this);
}
