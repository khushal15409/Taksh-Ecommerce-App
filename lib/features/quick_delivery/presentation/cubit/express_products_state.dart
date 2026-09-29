import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/express_products_response.dart';

enum ExpressProductsStatus { initial, loading, loaded, loadingMore, error }

class ExpressProductsState extends Equatable {
  final ExpressProductsStatus status;
  final ExpressProductsResponse? response;
  final String? errorMessage;
  final int currentPage;

  const ExpressProductsState({
    required this.status,
    this.response,
    this.errorMessage,
    this.currentPage = 1,
  });

  const ExpressProductsState.initial()
      : this(status: ExpressProductsStatus.initial);

  bool get hasMorePages => response?.hasMorePages ?? false;

  ExpressProductsState copyWith({
    ExpressProductsStatus? status,
    ExpressProductsResponse? response,
    String? errorMessage,
    bool clearErrorMessage = false,
    int? currentPage,
  }) {
    return ExpressProductsState(
      status: status ?? this.status,
      response: response ?? this.response,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [status, response, errorMessage, currentPage];
}
