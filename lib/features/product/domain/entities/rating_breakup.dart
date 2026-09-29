import 'package:equatable/equatable.dart';

/// Rating breakup entity
class RatingBreakup extends Equatable {
  final int oneStar;
  final int twoStar;
  final int threeStar;
  final int fourStar;
  final int fiveStar;

  const RatingBreakup({
    required this.oneStar,
    required this.twoStar,
    required this.threeStar,
    required this.fourStar,
    required this.fiveStar,
  });

  @override
  List<Object?> get props => [
        oneStar,
        twoStar,
        threeStar,
        fourStar,
        fiveStar,
      ];
}
