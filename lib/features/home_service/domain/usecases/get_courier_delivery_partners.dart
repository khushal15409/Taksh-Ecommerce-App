import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_delivery_partner.dart';
import 'package:taksh_e_commerce/features/home_service/domain/repositories/home_service_repository.dart';

class GetCourierDeliveryPartners
    implements UseCaseNoParams<List<CourierDeliveryPartner>> {
  final HomeServiceRepository repository;

  const GetCourierDeliveryPartners(this.repository);

  @override
  ResultFuture<List<CourierDeliveryPartner>> call() async {
    return repository.getCourierDeliveryPartners();
  }
}