import 'package:flutter_test/flutter_test.dart';
import 'package:taksh_e_commerce/core/utils/coordinate_parser.dart';
import 'package:taksh_e_commerce/features/address/data/models/address_model.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';

Map<String, dynamic> _addressJson({Object? latitude, Object? longitude}) => {
      'id': 7,
      'name': 'Home',
      'mobile': '9999999999',
      'address_type': 'home',
      'address_line_1': 'Line 1',
      'pincode': '380001',
      'is_default': true,
      'created_at': '2026-01-01T00:00:00.000Z',
      'updated_at': '2026-01-01T00:00:00.000Z',
      'latitude': latitude,
      'longitude': longitude,
    };

void main() {
  group('parseCoordinate', () {
    test('parses numbers and numeric strings', () {
      expect(parseCoordinate(23.0694), 23.0694);
      expect(parseCoordinate(23), 23.0);
      expect(parseCoordinate('72.6738'), 72.6738);
      expect(parseCoordinate(' 72.6738 '), 72.6738);
    });

    test('returns null for missing or invalid values', () {
      expect(parseCoordinate(null), isNull);
      expect(parseCoordinate(''), isNull);
      expect(parseCoordinate('abc'), isNull);
      expect(parseCoordinate(double.nan), isNull);
      expect(parseCoordinate(<String>[]), isNull);
    });
  });

  group('Location.hasValidCoordinates', () {
    test('real position is valid', () {
      expect(
        const Location(latitude: 23.0694, longitude: 72.6738)
            .hasValidCoordinates,
        isTrue,
      );
    });

    test('0,0 (address without coordinates) is not valid', () {
      expect(
        const Location(latitude: 0, longitude: 0).hasValidCoordinates,
        isFalse,
      );
    });

    test('out-of-range values are not valid', () {
      expect(
        const Location(latitude: 91, longitude: 10).hasValidCoordinates,
        isFalse,
      );
      expect(
        const Location(latitude: 10, longitude: 181).hasValidCoordinates,
        isFalse,
      );
    });
  });

  group('AddressModel.fromJson coordinates', () {
    test('reads backend latitude/longitude (numbers)', () {
      final a = AddressModel.fromJson(
        _addressJson(latitude: 23.0694, longitude: 72.6738),
      );
      expect(a.location.latitude, 23.0694);
      expect(a.location.longitude, 72.6738);
      expect(a.location.hasValidCoordinates, isTrue);
    });

    test('reads coordinates returned as strings', () {
      final a = AddressModel.fromJson(
        _addressJson(latitude: '23.0694', longitude: '72.6738'),
      );
      expect(a.location.hasValidCoordinates, isTrue);
    });

    test('null coordinates stay "unknown", never a default city', () {
      final a = AddressModel.fromJson(_addressJson());
      expect(a.location.hasValidCoordinates, isFalse);
      expect(a.location.latitude, 0.0);
      expect(a.location.longitude, 0.0);
    });
  });
}
