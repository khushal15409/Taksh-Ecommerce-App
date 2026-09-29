import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_quote.dart';
import 'package:taksh_e_commerce/features/home_service/domain/repositories/home_service_repository.dart';

class GetCourierQuote implements UseCase<CourierQuote, GetCourierQuoteParams> {
  final HomeServiceRepository repository;

  const GetCourierQuote(this.repository);

  @override
  ResultFuture<CourierQuote> call(GetCourierQuoteParams params) async {
    return repository.getCourierQuote(
      weightGrams: params.weightGrams,
      dimensionLength: params.dimensionLength,
      dimensionHeight: params.dimensionHeight,
      dimensionWidth: params.dimensionWidth,
      dimensionUnit: params.dimensionUnit,
    );
  }
}

class GetCourierQuoteParams extends Equatable {
  final double weightGrams;
  final double dimensionLength;
  final double dimensionHeight;
  final double dimensionWidth;
  final String dimensionUnit;

  const GetCourierQuoteParams({
    required this.weightGrams,
    required this.dimensionLength,
    required this.dimensionHeight,
    required this.dimensionWidth,
    required this.dimensionUnit,
  });

  @override
  List<Object?> get props => [
    weightGrams,
    dimensionLength,
    dimensionHeight,
    dimensionWidth,
    dimensionUnit,
  ];
}
