import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/dashboard_section_entity.dart';

/// Dashboard entity representing the complete dashboard data
class DashboardEntity extends Equatable {
  final List<DashboardSectionEntity> sections;

  const DashboardEntity({
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

  /// Get all non-empty sections
  List<DashboardSectionEntity> get nonEmptySections =>
      sections.where((section) => section.hasData).toList();

  @override
  List<Object?> get props => [sections];
}
