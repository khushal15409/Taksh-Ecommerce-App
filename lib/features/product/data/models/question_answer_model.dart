import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/question_answer.dart';
import 'package:taksh_e_commerce/features/product/data/models/answer_model.dart';

part 'question_answer_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class QuestionAnswerModel extends QuestionAnswer {
  @JsonKey(name: 'answers')
  final List<AnswerModel>? answerModels;

  const QuestionAnswerModel({
    required super.question,
    this.answerModels,
  }) : super(answers: answerModels);

  factory QuestionAnswerModel.fromJson(DataMap json) =>
      _$QuestionAnswerModelFromJson(json);

  DataMap toJson() => _$QuestionAnswerModelToJson(this);
}
