import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_address.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_location_model.dart';

part 'order_address_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderAddressModel extends OrderAddress {
  @JsonKey(name: 'state')
  final OrderLocationModel? stateModel;

  @JsonKey(name: 'city')
  final OrderLocationModel? cityModel;

  @JsonKey(name: 'area')
  final OrderLocationModel? areaModel;

  const OrderAddressModel({
    required super.id,
    required super.userId,
    required super.stateId,
    required super.cityId,
    required super.areaId,
    required super.name,
    required super.mobile,
    super.addressLine1,
    super.addressLine2,
    required super.pincode,
    super.landmark,
    required super.type,
    required super.isDefault,
    required super.createdAt,
    required super.updatedAt,
    this.stateModel,
    this.cityModel,
    this.areaModel,
  }) : super(state: stateModel, city: cityModel, area: areaModel);

  factory OrderAddressModel.fromJson(DataMap json) {
    int? parseOptionalInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    int parseRequiredInt(dynamic value, {int fallback = 0}) {
      return parseOptionalInt(value) ?? fallback;
    }

    String? parseOptionalString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      return value.toString();
    }

    String parseString(dynamic value, {String fallback = ''}) {
      return parseOptionalString(value) ?? fallback;
    }

    bool parseBool(dynamic value, {bool fallback = false}) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true' || normalized == '1') return true;
        if (normalized == 'false' || normalized == '0') return false;
      }
      return fallback;
    }

    DateTime parseDate(dynamic value) {
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
      return DateTime.now();
    }

    final stateJson = json['state'];
    final cityJson = json['city'];
    final areaJson = json['area'];

    return OrderAddressModel(
      id: parseRequiredInt(json['id']),
      userId: parseRequiredInt(json['user_id']),
      stateId: parseRequiredInt(json['state_id']),
      cityId: parseRequiredInt(json['city_id']),
      areaId: parseRequiredInt(json['area_id']),
      name: parseString(json['name'], fallback: 'Unknown'),
      mobile: parseString(json['mobile']),
      addressLine1:
          parseOptionalString(json['address_line_1']) ??
          parseOptionalString(json['address_line1']),
      addressLine2:
          parseOptionalString(json['address_line_2']) ??
          parseOptionalString(json['address_line2']),
      pincode: parseString(json['pincode']),
      landmark: parseOptionalString(json['landmark']),
      type: parseString(json['type'], fallback: 'home'),
      isDefault: parseBool(json['is_default']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at'] ?? json['created_at']),
      stateModel: stateJson is Map<String, dynamic>
          ? OrderLocationModel.fromJson(stateJson)
          : null,
      cityModel: cityJson is Map<String, dynamic>
          ? OrderLocationModel.fromJson(cityJson)
          : null,
      areaModel: areaJson is Map<String, dynamic>
          ? OrderLocationModel.fromJson(areaJson)
          : null,
    );
  }

  DataMap toJson() => _$OrderAddressModelToJson(this);
}
