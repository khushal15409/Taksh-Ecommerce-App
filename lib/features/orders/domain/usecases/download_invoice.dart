import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/repositories/order_repository.dart';

/// Use case for downloading the invoice PDF for an order.
///
/// The invoice is returned as a local file path on the device after
/// the PDF has been downloaded from the backend.
class DownloadInvoice {
  final OrderRepository _repository;

  DownloadInvoice(this._repository);

  /// Execute the use case.
  ///
  /// [orderNumber] - The order number (e.g. "ORDAWEVVDVW") whose invoice
  /// should be downloaded.
  ///
  /// [onProgress] - Optional callback that receives the current download
  /// progress (0.0 to 1.0).
  ///
  /// Returns [Right(String)] with the local file path on success.
  /// Returns [Left(Failure)] on error.
  Future<Either<Failure, String>> call(
    String orderNumber, {
    DownloadProgressCallback? onProgress,
  }) async {
    return await _repository.downloadInvoice(
      orderNumber: orderNumber,
      onProgress: onProgress,
    );
  }
}
