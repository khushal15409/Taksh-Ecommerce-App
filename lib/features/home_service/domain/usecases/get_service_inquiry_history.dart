import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/service_inquiry.dart';
import 'package:taksh_e_commerce/features/home_service/domain/repositories/home_service_repository.dart';

/// Fetches the service inquiry history for the current user.
class GetServiceInquiryHistory
    implements UseCase<List<ServiceInquiry>, GetServiceInquiryHistoryParams> {
  final HomeServiceRepository repository;

  const GetServiceInquiryHistory(this.repository);

  @override
  ResultFuture<List<ServiceInquiry>> call(
    GetServiceInquiryHistoryParams params,
  ) async {
    return repository.getServiceInquiryHistory(
      serviceId: params.serviceId,
      status: params.status,
      paymentStatus: params.paymentStatus,
      perPage: params.perPage,
    );
  }
}

class GetServiceInquiryHistoryParams extends Equatable {
  final int? serviceId;
  final String? status;
  final String? paymentStatus;
  final int perPage;

  const GetServiceInquiryHistoryParams({
    this.serviceId,
    this.status,
    this.paymentStatus,
    this.perPage = 15,
  });

  @override
  List<Object?> get props => [serviceId, status, paymentStatus, perPage];
}
