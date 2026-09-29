import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/rating_breakup.dart';

part 'rating_breakup_model.g.dart';

@JsonSerializable()
class RatingBreakupModel extends RatingBreakup {
  @JsonKey(name: '1')
  final int one;
  @JsonKey(name: '2')
  final int two;
  @JsonKey(name: '3')
  final int three;
  @JsonKey(name: '4')
  final int four;
  @JsonKey(name: '5')
  final int five;

  const RatingBreakupModel({
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
  }) : super(
          oneStar: one,
          twoStar: two,
          threeStar: three,
          fourStar: four,
          fiveStar: five,
        );

  factory RatingBreakupModel.fromJson(DataMap json) =>
      _$RatingBreakupModelFromJson(json);

  DataMap toJson() => _$RatingBreakupModelToJson(this);
}
