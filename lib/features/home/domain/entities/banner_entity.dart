import 'package:equatable/equatable.dart';

/// Banner entity representing promotional banners on home screen
class BannerEntity extends Equatable {
  final int id;
  final String title;
  final String imageUrl;
  final String position;
  final String redirectType;
  final int? redirectId;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.position,
    required this.redirectType,
    this.redirectId,
  });

  @override
  List<Object?> get props => [id, title, imageUrl, position, redirectType, redirectId];
}
