import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/answer.dart';

/// Question and answer entity
class QuestionAnswer extends Equatable {
  final String question;
  final List<Answer>? answers;

  const QuestionAnswer({
    required this.question,
    this.answers,
  });

  @override
  List<Object?> get props => [
        question,
        answers,
      ];
}
