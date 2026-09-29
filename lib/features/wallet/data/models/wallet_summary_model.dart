import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/wallet_summary.dart';

/// Model for the order reward calculation info
class OrderRewardModel extends OrderReward {
  const OrderRewardModel({
    required super.pointsFormula,
    required super.example,
  });

  factory OrderRewardModel.fromJson(DataMap json) {
    return OrderRewardModel(
      pointsFormula: json['points_formula'] as String? ?? '',
      example: json['example'] as String? ?? '',
    );
  }

  DataMap toJson() {
    return {
      'points_formula': pointsFormula,
      'example': example,
    };
  }
}

/// Model for the wallet summary API response
class WalletSummaryModel extends WalletSummary {
  const WalletSummaryModel({
    required super.balancePoints,
    required super.balanceRupeesEquivalent,
    required super.pendingWithdrawalPoints,
    required super.availablePoints,
    required super.availableRupeesEquivalent,
    required super.minWithdrawalPoints,
    required super.rupeesPerPoint,
    required super.orderReward,
  });

  factory WalletSummaryModel.fromJson(DataMap json) {
    return WalletSummaryModel(
      balancePoints: _toInt(json['balance_points']),
      balanceRupeesEquivalent: _toInt(json['balance_rupees_equivalent']),
      pendingWithdrawalPoints: _toInt(json['pending_withdrawal_points']),
      availablePoints: _toInt(json['available_points']),
      availableRupeesEquivalent: _toInt(json['available_rupees_equivalent']),
      minWithdrawalPoints: _toInt(json['min_withdrawal_points']),
      rupeesPerPoint: _toInt(json['rupees_per_point']),
      orderReward: json['order_reward'] != null
          ? OrderRewardModel.fromJson(json['order_reward'] as DataMap)
          : const OrderRewardModel(pointsFormula: '', example: ''),
    );
  }

  DataMap toJson() {
    return {
      'balance_points': balancePoints,
      'balance_rupees_equivalent': balanceRupeesEquivalent,
      'pending_withdrawal_points': pendingWithdrawalPoints,
      'available_points': availablePoints,
      'available_rupees_equivalent': availableRupeesEquivalent,
      'min_withdrawal_points': minWithdrawalPoints,
      'rupees_per_point': rupeesPerPoint,
      'order_reward': (orderReward as OrderRewardModel).toJson(),
    };
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
