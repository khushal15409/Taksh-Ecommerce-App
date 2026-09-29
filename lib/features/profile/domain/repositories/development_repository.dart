import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_request.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_response.dart';

/// Repository interface for development operations
abstract class DevelopmentRepository {
  /// Submit a development request (app or web)
  ResultFuture<DevelopmentResponse> submitDevelopmentRequest(
    DevelopmentRequest request,
  );
}
