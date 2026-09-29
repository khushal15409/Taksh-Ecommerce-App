import 'package:equatable/equatable.dart';

/// Represents how order reward points are calculated
class OrderReward extends Equatable {
  final String pointsFormula;
  final String example;

  const OrderReward({
    required this.pointsFormula,
    required this.example,
  });

  const OrderReward.empty()
      : pointsFormula = '',
        example = '';

  @override
  List<Object?> get props => [pointsFormula, example];
}

/// Wallet summary entity containing balance and reward information
class WalletSummary extends Equatable {
  final int balancePoints;
  final int balanceRupeesEquivalent;
  final int pendingWithdrawalPoints;
  final int availablePoints;
  final int availableRupeesEquivalent;
  final int minWithdrawalPoints;
  final int rupeesPerPoint;
  final OrderReward orderReward;

  const WalletSummary({
    required this.balancePoints,
    required this.balanceRupeesEquivalent,
    required this.pendingWithdrawalPoints,
    required this.availablePoints,
    required this.availableRupeesEquivalent,
    required this.minWithdrawalPoints,
    required this.rupeesPerPoint,
    required this.orderReward,
  });

  const WalletSummary.empty()
      : balancePoints = 0,
        balanceRupeesEquivalent = 0,
        pendingWithdrawalPoints = 0,
        availablePoints = 0,
        availableRupeesEquivalent = 0,
        minWithdrawalPoints = 100,
        rupeesPerPoint = 1,
        orderReward = const OrderReward.empty();

  /// Maximum withdrawal per request (business rule)
  int get maxWithdrawalPoints {
    const hardMax = 1000;
    return availablePoints < hardMax ? availablePoints : hardMax;
  }

  /// Whether withdrawal is possible
  bool get canWithdraw => availablePoints >= minWithdrawalPoints;

  @override
  List<Object?> get props => [
        balancePoints,
        balanceRupeesEquivalent,
        pendingWithdrawalPoints,
        availablePoints,
        availableRupeesEquivalent,
        minWithdrawalPoints,
        rupeesPerPoint,
        orderReward,
      ];
}
