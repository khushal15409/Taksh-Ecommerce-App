import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/dashboard_section_entity.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/express_fulfillment_center_entity.dart';

/// Express dashboard entity
class ExpressDashboardEntity extends Equatable {
  final ExpressFulfillmentCenterEntity fulfillmentCenter;
  final List<DashboardSectionEntity> sections;

  const ExpressDashboardEntity({
    required this.fulfillmentCenter,
    required this.sections,
  });

  /// Get section by key
  DashboardSectionEntity? getSectionByKey(String key) {
    try {
      return sections.firstWhere((section) => section.key == key);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [fulfillmentCenter, sections];
}
