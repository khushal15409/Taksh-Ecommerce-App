import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/express_dashboard_entity.dart';

/// Repository interface for express dashboard
abstract class ExpressDashboardRepository {
  ResultFuture<ExpressDashboardEntity> getExpressDashboard({
    required double latitude,
    required double longitude,
    required String pincode,
  });
}
