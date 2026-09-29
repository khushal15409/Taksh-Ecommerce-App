import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/quick_delivery/domain/entities/quick_delivery_tracking.dart';

abstract class QuickDeliveryRepository {
  ResultFuture<QuickDeliveryTracking> getDeliveryLocation(int orderId);
}
