import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_quote.dart';

int _quoteAsInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _quoteAsDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

String _quoteAsString(dynamic value) {
  if (value == null) {
    return '';
  }

  return value.toString().trim();
}

class CourierQuoteOptionModel extends CourierQuoteOption {
  const CourierQuoteOptionModel({
    required super.courierDeliveryPartnerId,
    required super.name,
    required super.slug,
    required super.totalAmount,
  });

  factory CourierQuoteOptionModel.fromJson(Map<String, dynamic> json) {
    return CourierQuoteOptionModel(
      courierDeliveryPartnerId: _quoteAsInt(
        json['courier_delivery_partner_id'],
      ),
      name: _quoteAsString(json['name']),
      slug: _quoteAsString(json['slug']),
      totalAmount: _quoteAsDouble(json['total_amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courier_delivery_partner_id': courierDeliveryPartnerId,
      'name': name,
      'slug': slug,
      'total_amount': totalAmount,
    };
  }
}

class CourierQuoteModel extends CourierQuote {
  const CourierQuoteModel({
    required super.actualWeightGrams,
    required super.volumetricWeightGrams,
    required super.chargeableWeightGrams,
    required super.chargeableWeightSource,
    required super.quotes,
  });

  factory CourierQuoteModel.fromJson(Map<String, dynamic> json) {
    final quotesList = (json['quotes'] as List<dynamic>? ?? const [])
        .map(
          (quote) => CourierQuoteOptionModel.fromJson(
            Map<String, dynamic>.from(quote as Map),
          ),
        )
        .toList(growable: false);

    return CourierQuoteModel(
      actualWeightGrams: _quoteAsInt(json['actual_weight_grams']),
      volumetricWeightGrams: _quoteAsInt(json['volumetric_weight_grams']),
      chargeableWeightGrams: _quoteAsInt(json['chargeable_weight_grams']),
      chargeableWeightSource: _quoteAsString(json['chargeable_weight_source']),
      quotes: quotesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actual_weight_grams': actualWeightGrams,
      'volumetric_weight_grams': volumetricWeightGrams,
      'chargeable_weight_grams': chargeableWeightGrams,
      'chargeable_weight_source': chargeableWeightSource,
      'quotes': quotes
          .map(
            (quote) => quote is CourierQuoteOptionModel
                ? quote.toJson()
                : {
                    'courier_delivery_partner_id':
                        quote.courierDeliveryPartnerId,
                    'name': quote.name,
                    'slug': quote.slug,
                    'total_amount': quote.totalAmount,
                  },
          )
          .toList(growable: false),
    };
  }
}
