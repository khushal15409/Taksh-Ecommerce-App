import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';

part 'category_model.g.dart';

/// Category model with JSON serialization
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CategoryModel extends Category {
  @JsonKey(name: 'children')
  final List<CategoryModel>? childrenModels;

  const CategoryModel({
    required super.id,
    super.parentId,
    super.fulfillmentCenterId,
    required super.name,
    required super.slug,
    super.imageUrl,
    super.iconUrl,
    required super.status,
    super.createdAt,
    super.updatedAt,
    this.childrenModels,
  }) : super(children: childrenModels);

  factory CategoryModel.fromJson(DataMap json) {
    final processedJson = Map<String, dynamic>.from(json);
    // Express API may not return slug or status for categories
    processedJson.putIfAbsent('slug', () => '');
    processedJson.putIfAbsent('status', () => 'active');
    return _$CategoryModelFromJson(processedJson);
  }

  /// Create CategoryModel from Category entity
  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      parentId: category.parentId,
      fulfillmentCenterId: category.fulfillmentCenterId,
      name: category.name,
      slug: category.slug,
      imageUrl: category.imageUrl,
      iconUrl: category.iconUrl,
      status: category.status,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      childrenModels: category.children
          ?.map((child) => CategoryModel.fromEntity(child))
          .toList(),
    );
  }

  /// Create empty CategoryModel
  factory CategoryModel.empty() {
    return const CategoryModel(
      id: 0,
      name: '',
      slug: '',
      status: '',
    );
  }

  /// Convert CategoryModel to JSON
  DataMap toJson() => _$CategoryModelToJson(this);

  /// Copy with method
  CategoryModel copyWith({
    int? id,
    int? parentId,
    int? fulfillmentCenterId,
    String? name,
    String? slug,
    String? imageUrl,
    String? iconUrl,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CategoryModel>? childrenModels,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      fulfillmentCenterId: fulfillmentCenterId ?? this.fulfillmentCenterId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      childrenModels: childrenModels ?? this.childrenModels,
    );
  }
}
