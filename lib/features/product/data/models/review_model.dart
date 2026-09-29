import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/review.dart';

part 'review_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReviewModel extends Review {
  const ReviewModel({
    required super.rating,
    required super.title,
    required super.review,
    required super.verified,
    super.createdAt,
  });

  factory ReviewModel.fromJson(DataMap json) => _$ReviewModelFromJson(json);

  DataMap toJson() => _$ReviewModelToJson(this);
}
