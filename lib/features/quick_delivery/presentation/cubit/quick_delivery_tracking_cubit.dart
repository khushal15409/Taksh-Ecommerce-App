import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/quick_delivery/domain/entities/quick_delivery_tracking.dart';
import 'package:taksh_e_commerce/features/quick_delivery/domain/usecases/get_quick_delivery_location.dart';
import 'package:taksh_e_commerce/features/quick_delivery/presentation/cubit/quick_delivery_tracking_state.dart';

class QuickDeliveryTrackingCubit extends Cubit<QuickDeliveryTrackingState> {
  final GetQuickDeliveryLocation _getQuickDeliveryLocation;

  QuickDeliveryTrackingCubit({
    required GetQuickDeliveryLocation getQuickDeliveryLocation,
  })  : _getQuickDeliveryLocation = getQuickDeliveryLocation,
        super(const QuickDeliveryTrackingState.initial());

  static const Duration _pollInterval = Duration(seconds: 8);

  final _log = loggerWithContext({
    'feature': 'quick_delivery',
    'layer': 'presentation',
    'class': 'QuickDeliveryTrackingCubit',
  });

  Timer? _pollTimer;
  int? _activeOrderId;

  Future<void> startTracking({
    required int orderId,
    GeoPoint? customerLocation,
  }) async {
    _activeOrderId = orderId;

    emit(
      state.copyWith(
        status: QuickDeliveryTrackingStatus.loading,
        orderId: orderId,
        customerLocation: customerLocation,
        clearErrorMessage: true,
      ),
    );

    if (customerLocation == null) {
      final resolvedCustomerLocation = await _resolveCurrentLocation();
      if (resolvedCustomerLocation != null) {
        emit(state.copyWith(customerLocation: resolvedCustomerLocation));
      }
    }

    await _fetchDeliveryLocation(orderId);

    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      final activeOrderId = _activeOrderId;
      if (activeOrderId != null) {
        _fetchDeliveryLocation(activeOrderId);
      }
    });
  }

  void stopTracking() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _activeOrderId = null;
  }

  Future<void> _fetchDeliveryLocation(int orderId) async {
    final result = await _getQuickDeliveryLocation(
      GetQuickDeliveryLocationParams(orderId: orderId),
    );

    result.fold(
      (failure) {
        _log.warnWithContext(
          'Quick delivery polling failed',
          {'order_id': orderId, 'message': failure.message},
        );

        emit(
          state.copyWith(
            status: QuickDeliveryTrackingStatus.error,
            orderId: orderId,
            errorMessage: failure.message,
            lastUpdatedAt: DateTime.now(),
          ),
        );
      },
      (trackingData) {
        emit(
          state.copyWith(
            status: QuickDeliveryTrackingStatus.loaded,
            orderId: trackingData.orderId,
            orderStatus: trackingData.orderStatus,
            riderLocation: trackingData.riderLocation,
            clearRiderLocation: trackingData.riderLocation == null,
            message: trackingData.message,
            clearErrorMessage: true,
            lastUpdatedAt: DateTime.now(),
          ),
        );
      },
    );
  }

  Future<GeoPoint?> _resolveCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> close() {
    stopTracking();
    return super.close();
  }
}
