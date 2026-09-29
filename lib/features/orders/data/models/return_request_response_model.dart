import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';

part 'return_request_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ReturnRequestResponseModel {
  final bool success;
  final String message;
  final DataMap? data;

  const ReturnRequestResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ReturnRequestResponseModel.fromJson(DataMap json) =>
      _$ReturnRequestResponseModelFromJson(json);

  DataMap toJson() => _$ReturnRequestResponseModelToJson(this);
}
