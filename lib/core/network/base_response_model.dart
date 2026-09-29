import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';

part 'base_response_model.g.dart';

/// Base response model for all API responses
@JsonSerializable(
    genericArgumentFactories: true, fieldRename: FieldRename.snake)
class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;

  const BaseResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Create BaseResponse from JSON with custom data parser
  factory BaseResponse.fromJson(
    DataMap json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);

  /// Convert BaseResponse to JSON
  DataMap toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);
}
