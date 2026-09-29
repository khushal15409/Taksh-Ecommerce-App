import 'package:taksh_e_commerce/features/home_service/domain/entities/home_service.dart';

int _asInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

String _asString(dynamic value) {
  if (value == null) {
    return '';
  }

  return value.toString().trim();
}

String? _asNullableString(dynamic value) {
  final normalizedValue = _asString(value);
  return normalizedValue.isEmpty ? null : normalizedValue;
}

String? _extractImageUrl(dynamic value) {
  if (value is String) {
    return value.trim();
  }

  if (value is Map) {
    for (final key in const ['url', 'image', 'image_url', 'path']) {
      final imageUrl = _asNullableString(value[key]);
      if (imageUrl != null) {
        return imageUrl;
      }
    }
  }

  return _asNullableString(value);
}

List<String> _asStringList(dynamic value) {
  if (value is! List) {
    return const [];
  }

  return value
      .map(_extractImageUrl)
      .whereType<String>()
      .where((imageUrl) => imageUrl.isNotEmpty)
      .toList(growable: false);
}

/// Model for [HomeServiceCategory].
class HomeServiceCategoryModel extends HomeServiceCategory {
  const HomeServiceCategoryModel({required super.id, required super.name});

  factory HomeServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeServiceCategoryModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

/// Model for [HomeService].
class HomeServiceModel extends HomeService {
  const HomeServiceModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.shortDescription,
    required super.description,
    required super.basePrice,
    required super.duration,
    super.image,
    super.images,
    required super.category,
  });

  factory HomeServiceModel.fromJson(Map<String, dynamic> json) {
    final categoryJson = json['category'];

    return HomeServiceModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      slug: _asString(json['slug']),
      shortDescription: _asString(json['short_description']),
      description: _asString(json['description']),
      basePrice: _asDouble(json['base_price']),
      duration: _asString(json['duration']),
      image: _asNullableString(json['image']),
      images: _asStringList(json['images']),
      category: categoryJson is Map
          ? HomeServiceCategoryModel.fromJson(
              Map<String, dynamic>.from(categoryJson),
            )
          : HomeServiceCategoryModel(
              id: _asInt(json['category_id']),
              name: _asString(json['category_name']),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    final categoryJson = category is HomeServiceCategoryModel
        ? (category as HomeServiceCategoryModel).toJson()
        : {'id': category.id, 'name': category.name};

    return {
      'id': id,
      'name': name,
      'slug': slug,
      'short_description': shortDescription,
      'description': description,
      'base_price': basePrice,
      'duration': duration,
      'image': image,
      'images': images,
      'category': categoryJson,
    };
  }
}
