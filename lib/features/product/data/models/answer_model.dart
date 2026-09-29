import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/answer.dart';

part 'answer_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AnswerModel extends Answer {
  const AnswerModel({
    required super.answer,
    super.createdAt,
  });

  factory AnswerModel.fromJson(DataMap json) => _$AnswerModelFromJson(json);

  DataMap toJson() => _$AnswerModelToJson(this);
}
