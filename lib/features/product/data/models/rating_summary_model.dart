import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/rating_summary.dart';
import 'package:taksh_e_commerce/features/product/data/models/rating_breakup_model.dart';

part 'rating_summary_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class RatingSummaryModel extends RatingSummary {
  @JsonKey(name: 'rating_breakup')
  final RatingBreakupModel? ratingBreakupModel;

  @override
  @JsonKey(name: 'average_rating', defaultValue: 0.0)
  final double averageRating;

  @override
  @JsonKey(name: 'total_reviews', defaultValue: 0)
  final int totalReviews;

  const RatingSummaryModel({
    required this.averageRating,
    required this.totalReviews,
    this.ratingBreakupModel,
  }) : super(
          averageRating: averageRating,
          totalReviews: totalReviews,
          ratingBreakup: ratingBreakupModel,
        );

  factory RatingSummaryModel.fromJson(DataMap json) =>
      _$RatingSummaryModelFromJson(json);

  DataMap toJson() => _$RatingSummaryModelToJson(this);
}
