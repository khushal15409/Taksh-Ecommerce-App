import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/dashboard_entity.dart';

/// Repository interface for dashboard data operations
abstract class DashboardRepository {
  /// Get dashboard data for given location
  /// [latitude] and [longitude] are the user's location coordinates
  ResultFuture<DashboardEntity> getDashboard({
    required double latitude,
    required double longitude,
  });
}
