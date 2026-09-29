import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/repositories/order_repository.dart';

/// Parameters for uploading return media
class UploadReturnMediaParams {
  final String returnId;
  final List<String> imagePaths;

  const UploadReturnMediaParams({
    required this.returnId,
    required this.imagePaths,
  });
}

/// Use case for uploading images for a return request
class UploadReturnMedia {
  final OrderRepository _repository;

  UploadReturnMedia(this._repository);

  /// Execute the use case
  /// 
  /// [params] - The parameters for uploading media
  /// 
  /// Returns [Right(DataMap)] with response data on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, DataMap>> call(UploadReturnMediaParams params) async {
    return await _repository.uploadReturnMedia(
      returnId: params.returnId,
      imagePaths: params.imagePaths,
    );
  }
}
