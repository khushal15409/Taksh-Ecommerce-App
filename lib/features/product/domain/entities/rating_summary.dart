import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/rating_breakup.dart';

/// Rating summary entity
class RatingSummary extends Equatable {
  final double averageRating;
  final int totalReviews;
  final RatingBreakup? ratingBreakup;

  const RatingSummary({
    required this.averageRating,
    required this.totalReviews,
    this.ratingBreakup,
  });

  @override
  List<Object?> get props => [
        averageRating,
        totalReviews,
        ratingBreakup,
      ];
}
