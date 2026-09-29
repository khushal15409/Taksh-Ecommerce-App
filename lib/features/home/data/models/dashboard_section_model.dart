import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/data/models/banner_model.dart';
import 'package:taksh_e_commerce/features/home/data/models/product_model.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/dashboard_section_entity.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';

part 'dashboard_section_model.g.dart';

/// Model for Dashboard Section data from API
@JsonSerializable(fieldRename: FieldRename.snake)
class DashboardSectionModel extends DashboardSectionEntity {
  const DashboardSectionModel({
    required super.key,
    required super.data,
    super.message,
  });

  factory DashboardSectionModel.fromJson(DataMap json) {
    final key = json['key']?.toString() ?? '';
    final rawData = json['data'];
    final message = json['message'] as String?;

    // Parse data based on section key
    List<dynamic> parsedData;
    if (key == 'Banners') {
      final dataList = rawData is List ? rawData : <dynamic>[];
      parsedData = dataList
          .map((item) => BannerModel.fromJson(item as DataMap))
          .toList();
    } else if (key == 'Logo') {
      // Logo data is a map, preserve it as a single-item list
      parsedData = rawData is Map ? [rawData] : [];
    } else if (key == 'Categories') {
      // Parse categories from Express 30 API
      final dataList = rawData is List ? rawData : <dynamic>[];
      parsedData = dataList
          .map((item) => Category.fromJson(item as DataMap))
          .toList();
    } else {
      // All other sections contain products (Flash Deal, Trading Products, etc.)
      final dataList = rawData is List ? rawData : <dynamic>[];
      parsedData = dataList
          .map((item) => ProductModel.fromJson(item as DataMap))
          .toList();
    }

    return DashboardSectionModel(
      key: key,
      data: parsedData,
      message: message,
    );
  }

  DataMap toJson() => _$DashboardSectionModelToJson(this);

  /// Get typed data as banners (if this is a banners section)
  List<BannerModel> get banners {
    if (key != 'Banners') return [];
    return data.whereType<BannerModel>().toList();
  }

  /// Get typed data as products (if this is a product section)
  List<ProductModel> get products {
    if (key == 'Banners' || key == 'Categories') return [];
    return data.whereType<ProductModel>().toList();
  }

  /// Get typed data as categories (if this is a categories section)
  List<Category> get categories {
    if (key != 'Categories') return [];
    return data.whereType<Category>().toList();
  }
}
