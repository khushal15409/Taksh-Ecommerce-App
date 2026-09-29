import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';

class ExtraChargeModel extends ExtraCharge {
  const ExtraChargeModel({
    required super.type,
    required super.label,
    required super.amount,
    required super.isDiscount,
    super.sortOrder,
  });

  factory ExtraChargeModel.fromJson(DataMap json) {
    final rawAmount = json['amount'];
    final amount = rawAmount is num
        ? rawAmount.toInt()
        : int.tryParse(rawAmount?.toString() ?? '') ?? 0;

    return ExtraChargeModel(
      type: json['type']?.toString() ?? 'other',
      label: json['label']?.toString() ?? '',
      amount: amount,
      isDiscount: json['is_discount'] == true,
      sortOrder: json['sort_order'] is num
          ? (json['sort_order'] as num).toInt()
          : int.tryParse(json['sort_order']?.toString() ?? ''),
    );
  }

  DataMap toJson() => {
    'type': type,
    'label': label,
    'amount': amount,
    'is_discount': isDiscount,
    if (sortOrder != null) 'sort_order': sortOrder,
  };

  DataMap toOrderJson() => {
    'type': type,
    'label': label,
    'amount': amount,
    'is_discount': isDiscount,
  };

  factory ExtraChargeModel.fromEntity(ExtraCharge entity) {
    return ExtraChargeModel(
      type: entity.type,
      label: entity.label,
      amount: entity.amount,
      isDiscount: entity.isDiscount,
      sortOrder: entity.sortOrder,
    );
  }
}
