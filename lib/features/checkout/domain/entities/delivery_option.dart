import 'package:equatable/equatable.dart';

/// Entity representing a delivery option
class DeliveryOption extends Equatable {
  final String type;
  final String displayName;
  final int charges;
  final int slaMinutes;
  final bool isAvailable;

  const DeliveryOption({
    required this.type,
    required this.displayName,
    required this.charges,
    required this.slaMinutes,
    required this.isAvailable,
  });

  /// Standard delivery option (1 day)
  factory DeliveryOption.normal() {
    return const DeliveryOption(
      type: 'normal',
      displayName: 'Standard Delivery',
      charges: 0,
      slaMinutes: 1440,
      isAvailable: true,
    );
  }

  /// 1-day delivery option
  // factory DeliveryOption.oneDay() {
  //   return const DeliveryOption(
  //     type: '1_day',
  //     displayName: '1-Day Delivery',
  //     charges: 0,
  //     slaMinutes: 1440,
  //     isAvailable: true,
  //   );
  // }

  /// Express 30-min delivery option
  factory DeliveryOption.express() {
    return const DeliveryOption(
      type: '30_min',
      displayName: 'Quick Delivery',
      charges: 0,
      slaMinutes: 30,
      isAvailable: true,
    );
  }

  /// Return a copy with updated availability
  DeliveryOption copyWith({bool? isAvailable}) {
    return DeliveryOption(
      type: type,
      displayName: displayName,
      charges: charges,
      slaMinutes: slaMinutes,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  /// Whether this option is express (30-min)
  bool get isExpress => type == '30_min';

  /// Get estimated delivery time as string
  String get estimatedTime {
    if (slaMinutes < 60) {
      return '$slaMinutes mins';
    }
    final hours = (slaMinutes / 60).floor();
    final mins = slaMinutes % 60;
    if (mins == 0) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'}';
    }
    return '$hours hr $mins mins';
  }

  /// Get charges in rupees
  double get chargesInRupees => charges / 100;

  @override
  List<Object?> get props => [
    type,
    displayName,
    charges,
    slaMinutes,
    isAvailable,
  ];

  @override
  String toString() {
    return 'DeliveryOption(type: $type, charges: $charges, sla: $slaMinutes, available: $isAvailable)';
  }
}
