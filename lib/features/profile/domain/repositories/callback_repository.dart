import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/callback_response.dart';

/// Repository interface for callback operations
abstract class CallbackRepository {
  /// Request a callback from support
  ResultFuture<CallbackResponse> requestCallback();
}
