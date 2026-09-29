import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/data/models/cart_model.dart';

part 'cart_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CartResponseModel {
  final CartModel cart;
  final String? guestToken;

  const CartResponseModel({required this.cart, this.guestToken});

  factory CartResponseModel.fromJson(DataMap json) {
    final nestedCart = json['cart'];
    final hasNestedCart = nestedCart is Map<String, dynamic>;

    final cartJson = hasNestedCart
        ? Map<String, dynamic>.from(nestedCart)
        : Map<String, dynamic>.from(json);

    if (cartJson['charges'] == null && json['charges'] is List) {
      cartJson['charges'] = json['charges'];
    }

    final responseGuestToken = json['guest_token']?.toString();
    if (cartJson['guest_token'] == null && responseGuestToken != null) {
      cartJson['guest_token'] = responseGuestToken;
    }

    return _$CartResponseModelFromJson({
      'cart': cartJson,
      'guest_token': responseGuestToken ?? cartJson['guest_token']?.toString(),
    });
  }

  DataMap toJson() => _$CartResponseModelToJson(this);
}
