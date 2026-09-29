import 'package:equatable/equatable.dart';

/// Answer entity
class Answer extends Equatable {
  final String answer;
  final DateTime? createdAt;

  const Answer({
    required this.answer,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        answer,
        createdAt,
      ];
}
