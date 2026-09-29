import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';

/// Type alias for Future returning Either<Failure, T>
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// Type alias for Future returning Either<Failure, void>
typedef ResultVoid = Future<Either<Failure, void>>;

/// Type alias for Either<Failure, T>
typedef Result<T> = Either<Failure, T>;

/// Type alias for data map
typedef DataMap = Map<String, dynamic>;

/// Callback signature for reporting progress during long-running
/// operations like file downloads. The value is in the range 0.0 to 1.0.
typedef DownloadProgressCallback = void Function(double progress);
