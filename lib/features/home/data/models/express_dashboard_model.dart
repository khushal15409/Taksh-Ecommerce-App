import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/data/models/dashboard_section_model.dart';
import 'package:taksh_e_commerce/features/home/data/models/express_fulfillment_center_model.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/express_dashboard_entity.dart';

/// Model for express dashboard response
class ExpressDashboardModel extends ExpressDashboardEntity {
  @override
  final ExpressFulfillmentCenterModel fulfillmentCenter;

  @override
  final List<DashboardSectionModel> sections;

  const ExpressDashboardModel({
    required this.fulfillmentCenter,
    required this.sections,
  }) : super(fulfillmentCenter: fulfillmentCenter, sections: sections);

  factory ExpressDashboardModel.fromJson(DataMap json) {
    final fulfillmentCenterJson = (json['fulfillment_center'] as DataMap?) ??
      (json['vendors'] as DataMap?) ??
      <String, dynamic>{};
    final sectionsJson = json['sections'] as List<dynamic>? ?? [];

    return ExpressDashboardModel(
      fulfillmentCenter:
          ExpressFulfillmentCenterModel.fromJson(fulfillmentCenterJson),
      sections: sectionsJson
          .map((item) => DashboardSectionModel.fromJson(item as DataMap))
          .toList(),
    );
  }

  DataMap toJson() {
    return {
      'fulfillment_center': fulfillmentCenter.toJson(),
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }
}
