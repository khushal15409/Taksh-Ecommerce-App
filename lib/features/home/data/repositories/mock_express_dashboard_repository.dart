import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/data/models/express_dashboard_model.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/express_dashboard_entity.dart';
import 'package:taksh_e_commerce/features/home/domain/repositories/express_dashboard_repository.dart';

/// Mock implementation of ExpressDashboardRepository for testing
class MockExpressDashboardRepository implements ExpressDashboardRepository {
  MockExpressDashboardRepository({this.networkDelayMs = 600});

  /// Simulated network delay in milliseconds
  final int networkDelayMs;

  static final _log = loggerWithContext({
    'feature': 'home',
    'layer': 'repository',
    'type': 'mock',
  });

  static final DataMap _mockResponse = {
    'fulfillment_center': {
      'id': 1,
      'name': 'Ahmedabad Fulfillment Center',
    },
    'sections': [
      {
        'key': 'Banners',
        'data': [
          {
            'id': 17,
            'title': 'Big Sale - Up to 50% Off',
            'image_url':
                'https://taksh-admin.takshallinone.in/storage/banner/2026-01-16-6969e8f1974b7.jpg',
            'position': 'home_top',
            'redirect_type': 'none',
            'redirect_id': null,
          },
          {
            'id': 18,
            'title': 'Daily Essentials • Best Prices',
            'image_url':
                'https://images.unsplash.com/photo-1542838132-92c53300491e',
            'position': 'home_top',
            'redirect_type': 'none',
            'redirect_id': null,
          },
        ],
        'message': null,
      },
      {
        'key': 'Flash Deal',
        'data': [
          {
            'id': 1,
            'product_variant_id': 1,
            'name': 'iPhone 15 Pro',
            'slug': 'iphone-15-pro',
            'short_description':
                'Premium smartphone with cutting-edge technology',
            'original_price': 99900.0,
            'price': 84915.0,
            'sale_price': 84915.0,
            'discount_label': '15% OFF',
            'sale_id': 3,
            'image_url':
                'https://fastly.picsum.photos/id/15/500/500.jpg?hmac=15v15v15v15v15v15v15v15v15v15v15v15v15v15v15v',
            'brand': 'Apple',
          },
          {
            'id': 2,
            'product_variant_id': 5,
            'name': 'Samsung Galaxy S24',
            'slug': 'samsung-galaxy-s24',
            'short_description': 'Premium Android experience.',
            'original_price': 129999.0,
            'price': 116999.0,
            'sale_price': 116999.0,
            'discount_label': '10% OFF',
            'sale_id': 4,
            'image_url':
                'https://fastly.picsum.photos/id/11/500/500.jpg?hmac=11v11v11v11v11v11v11v11v11v11v11v11v11v11v11v',
            'brand': 'Samsung',
          },
          {
            'id': 3,
            'product_variant_id': 9,
            'name': 'OnePlus 12',
            'slug': 'oneplus-12',
            'short_description': 'Flagship killer.',
            'original_price': 64999.0,
            'price': 58499.0,
            'sale_price': 58499.0,
            'discount_label': '10% OFF',
            'sale_id': 5,
            'image_url':
                'https://fastly.picsum.photos/id/12/500/500.jpg?hmac=12v12v12v12v12v12v12v12v12v12v12v12v12v12v12v',
            'brand': 'OnePlus',
          },
        ],
        'message': null,
      },
      {
        'key': 'Trading Products',
        'data': [
          {
            'id': 4,
            'product_variant_id': 13,
            'name': 'Xiaomi 14 Pro',
            'slug': 'xiaomi-14-pro',
            'short_description': 'Photography powerhouse.',
            'original_price': 59999.0,
            'price': 53999.0,
            'sale_price': 53999.0,
            'discount_label': '10% OFF',
            'sale_id': 6,
            'image_url':
                'https://fastly.picsum.photos/id/13/500/500.jpg?hmac=13v13v13v13v13v13v13v13v13v13v13v13v13v13v13v',
            'brand': 'Xiaomi',
          },
          {
            'id': 5,
            'product_variant_id': 17,
            'name': 'Realme GT 5 Pro',
            'slug': 'realme-gt-5-pro',
            'short_description': 'Ultimate gaming phone.',
            'original_price': 49999.0,
            'price': 44999.0,
            'sale_price': 44999.0,
            'discount_label': '10% OFF',
            'sale_id': 7,
            'image_url':
                'https://fastly.picsum.photos/id/14/500/500.jpg?hmac=14v14v14v14v14v14v14v14v14v14v14v14v14v14v14v',
            'brand': 'Realme',
          },
          {
            'id': 1,
            'product_variant_id': 1,
            'name': 'iPhone 15 Pro',
            'slug': 'iphone-15-pro',
            'short_description':
                'Premium smartphone with cutting-edge technology',
            'original_price': 99900.0,
            'price': 84915.0,
            'sale_price': 84915.0,
            'discount_label': '15% OFF',
            'sale_id': 3,
            'image_url':
                'https://fastly.picsum.photos/id/15/500/500.jpg?hmac=15v15v15v15v15v15v15v15v15v15v15v15v15v15v15v',
            'brand': 'Apple',
          },
        ],
        'message': null,
      },
      {
        'key': 'Home Care',
        'data': [
          {
            'id': 2,
            'product_variant_id': 5,
            'name': 'Samsung Galaxy S24',
            'slug': 'samsung-galaxy-s24',
            'short_description': 'Premium Android experience.',
            'original_price': 129999.0,
            'price': 116999.0,
            'sale_price': 116999.0,
            'discount_label': '10% OFF',
            'sale_id': 4,
            'image_url':
                'https://fastly.picsum.photos/id/16/500/500.jpg?hmac=16v16v16v16v16v16v16v16v16v16v16v16v16v16v16v',
            'brand': 'Samsung',
          },
          {
            'id': 3,
            'product_variant_id': 9,
            'name': 'OnePlus 12',
            'slug': 'oneplus-12',
            'short_description': 'Flagship killer.',
            'original_price': 64999.0,
            'price': 58499.0,
            'sale_price': 58499.0,
            'discount_label': '10% OFF',
            'sale_id': 5,
            'image_url':
                'https://fastly.picsum.photos/id/17/500/500.jpg?hmac=17v17v17v17v17v17v17v17v17v17v17v17v17v17v17v',
            'brand': 'OnePlus',
          },
        ],
        'message': null,
      },
      {
        'key': 'Personal Care',
        'data': [
          {
            'id': 4,
            'product_variant_id': 13,
            'name': 'Xiaomi 14 Pro',
            'slug': 'xiaomi-14-pro',
            'short_description': 'Photography powerhouse.',
            'original_price': 59999.0,
            'price': 53999.0,
            'sale_price': 53999.0,
            'discount_label': '10% OFF',
            'sale_id': 6,
            'image_url':
                'https://fastly.picsum.photos/id/21/500/500.jpg?hmac=21v21v21v21v21v21v21v21v21v21v21v21v21v21v21v',
            'brand': 'Xiaomi',
          },
          {
            'id': 5,
            'product_variant_id': 17,
            'name': 'Realme GT 5 Pro',
            'slug': 'realme-gt-5-pro',
            'short_description': 'Ultimate gaming phone.',
            'original_price': 49999.0,
            'price': 44999.0,
            'sale_price': 44999.0,
            'discount_label': '10% OFF',
            'sale_id': 7,
            'image_url':
                'https://fastly.picsum.photos/id/22/500/500.jpg?hmac=22v22v22v22v22v22v22v22v22v22v22v22v22v22v22v',
            'brand': 'Realme',
          },
          {
            'id': 1,
            'product_variant_id': 1,
            'name': 'iPhone 15 Pro',
            'slug': 'iphone-15-pro',
            'short_description':
                'Premium smartphone with cutting-edge technology',
            'original_price': 99900.0,
            'price': 84915.0,
            'sale_price': 84915.0,
            'discount_label': '15% OFF',
            'sale_id': 3,
            'image_url':
                'https://fastly.picsum.photos/id/15/500/500.jpg?hmac=15v15v15v15v15v15v15v15v15v15v15v15v15v15v15v',
            'brand': 'Apple',
          },
          {
            'id': 2,
            'product_variant_id': 5,
            'name': 'Samsung Galaxy S24',
            'slug': 'samsung-galaxy-s24',
            'short_description': 'Premium Android experience.',
            'original_price': 129999.0,
            'price': 116999.0,
            'sale_price': 116999.0,
            'discount_label': '10% OFF',
            'sale_id': 4,
            'image_url':
                'https://fastly.picsum.photos/id/16/500/500.jpg?hmac=16v16v16v16v16v16v16v16v16v16v16v16v16v16v16v',
            'brand': 'Samsung',
          },
        ],
        'message': null,
      },
    ],
  };

  @override
  ResultFuture<ExpressDashboardEntity> getExpressDashboard({
    required double latitude,
    required double longitude,
    required String pincode,
  }) async {
    _log.infoWithContext(
      'Mock express dashboard requested',
      {'latitude': latitude, 'longitude': longitude, 'pincode': pincode},
    );

    await Future.delayed(Duration(milliseconds: networkDelayMs));

    final dashboard = ExpressDashboardModel.fromJson(_mockResponse);

    _log.infoWithContext(
      'Mock express dashboard returned',
      {'sections_count': dashboard.sections.length},
    );

    return Right(dashboard);
  }
}
