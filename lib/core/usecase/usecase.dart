import 'package:taksh_e_commerce/core/utils/typedef.dart';

/// Base UseCase interface for all use cases
/// T: Return type
/// Params: Parameters type
abstract class UseCase<T, Params> {
  const UseCase();

  /// Execute the use case with given parameters
  ResultFuture<T> call(Params params);
}

/// UseCase without parameters
abstract class UseCaseNoParams<T> {
  const UseCaseNoParams();

  /// Execute the use case without parameters
  ResultFuture<T> call();
}

/// UseCase that returns void
abstract class UseCaseVoid<Params> {
  const UseCaseVoid();

  /// Execute the use case with given parameters
  ResultVoid call(Params params);
}

/// UseCase that returns void and has no parameters
abstract class UseCaseVoidNoParams {
  const UseCaseVoidNoParams();

  /// Execute the use case without parameters
  ResultVoid call();
}
