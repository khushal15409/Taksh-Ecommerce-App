import 'package:equatable/equatable.dart';

/// Represents a service category (e.g. Logistics & Delivery, Home Services)
class HomeServiceCategory extends Equatable {
  final int id;
  final String name;

  const HomeServiceCategory({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

/// Represents an available home service
class HomeService extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String shortDescription;
  final String description;
  final double basePrice;
  final String duration;
  final String? image;
  final List<String> images;
  final HomeServiceCategory category;

  const HomeService({
    required this.id,
    required this.name,
    required this.slug,
    required this.shortDescription,
    required this.description,
    required this.basePrice,
    required this.duration,
    this.image,
    this.images = const [],
    required this.category,
  });

  bool get isCourier => slug == 'courier-booking';

  String get displayDescription {
    final summary = shortDescription.trim();
    if (summary.isNotEmpty) {
      return summary;
    }

    return description.trim();
  }

  String? get primaryImageUrl {
    final primaryImage = image?.trim();
    if (primaryImage != null && primaryImage.isNotEmpty) {
      return primaryImage;
    }

    for (final imageUrl in images) {
      final normalizedImageUrl = imageUrl.trim();
      if (normalizedImageUrl.isNotEmpty) {
        return normalizedImageUrl;
      }
    }

    return null;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    shortDescription,
    description,
    basePrice,
    duration,
    image,
    images,
    category,
  ];
}
