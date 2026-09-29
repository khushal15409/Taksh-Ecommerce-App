import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/recent_view.dart';

/// Model for recently viewed product
class RecentViewModel extends RecentView {
  const RecentViewModel({
    required super.id,
    required super.name,
    required super.price,
    required super.thumbnail,
  });

  factory RecentViewModel.fromJson(DataMap json) {
    return RecentViewModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? 'Product',
      price: (json['price'] as num?)?.toInt() ?? 0,
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  DataMap toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'thumbnail': thumbnail,
    };
  }
}
