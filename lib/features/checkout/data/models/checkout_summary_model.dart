import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/data/models/address_model.dart';
import 'package:taksh_e_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:taksh_e_commerce/features/checkout/data/models/delivery_option_model.dart';
import 'package:taksh_e_commerce/features/checkout/data/models/price_breakdown_model.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/checkout_summary.dart';

part 'checkout_summary_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CheckoutSummaryModel extends CheckoutSummary {
  @JsonKey(name: 'items')
  final List<CartItemModel> itemModels;

  @JsonKey(name: 'price_breakdown')
  final PriceBreakdownModel priceBreakdownModel;

  @JsonKey(name: 'delivery_option')
  final DeliveryOptionModel deliveryOptionModel;

  @JsonKey(name: 'selected_address')
  final AddressModel? selectedAddressModel;

  const CheckoutSummaryModel({
    required this.itemModels,
    required this.priceBreakdownModel,
    required this.deliveryOptionModel,
    this.selectedAddressModel,
  }) : super(
          items: itemModels,
          priceBreakdown: priceBreakdownModel,
          deliveryOption: deliveryOptionModel,
          selectedAddress: selectedAddressModel,
        );

  factory CheckoutSummaryModel.fromJson(DataMap json) =>
      _$CheckoutSummaryModelFromJson(json);

  DataMap toJson() => _$CheckoutSummaryModelToJson(this);

  /// Convert to entity
  CheckoutSummary toEntity() {
    return CheckoutSummary(
      items: itemModels,
      priceBreakdown: priceBreakdownModel.toEntity(),
      deliveryOption: deliveryOptionModel.toEntity(),
      selectedAddress: selectedAddressModel,
    );
  }
}
