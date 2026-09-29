import 'package:equatable/equatable.dart';

/// Review entity
class Review extends Equatable {
  final int rating;
  final String title;
  final String review;
  final bool verified;
  final DateTime? createdAt;

  const Review({
    required this.rating,
    required this.title,
    required this.review,
    required this.verified,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        rating,
        title,
        review,
        verified,
        createdAt,
      ];
}
