import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/data/models/dashboard_section_model.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/dashboard_entity.dart';

part 'dashboard_model.g.dart';

/// Model for Dashboard data from API
@JsonSerializable(fieldRename: FieldRename.snake)
class DashboardModel extends DashboardEntity {
  @override
  final List<DashboardSectionModel> sections;

  const DashboardModel({
    required this.sections,
  }) : super(sections: sections);

  factory DashboardModel.fromJson(DataMap json) {
    final sectionsJson = json['sections'] as List<dynamic>? ?? [];
    final sections = sectionsJson
        .map((item) => DashboardSectionModel.fromJson(item as DataMap))
        .toList();

    return DashboardModel(sections: sections);
  }

  DataMap toJson() => _$DashboardModelToJson(this);

  /// Get typed section by key
  DashboardSectionModel? getTypedSectionByKey(String key) {
    try {
      return sections.firstWhere((section) => section.key == key);
    } catch (e) {
      return null;
    }
  }
}
