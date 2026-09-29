import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/home/domain/usecases/get_dashboard_usecase.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/dashboard_event.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/dashboard_state.dart';

/// BLoC for managing dashboard state
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase _getDashboardUseCase;

  DashboardBloc({
    required GetDashboardUseCase getDashboardUseCase,
  })  : _getDashboardUseCase = getDashboardUseCase,
        super(const DashboardInitial()) {
    on<DashboardLoadRequested>(_onLoadRequested);
    on<DashboardRefreshRequested>(_onRefreshRequested);
  }

  final _log = loggerWithContext({
    'feature': 'home',
    'layer': 'bloc',
    'bloc': 'DashboardBloc',
  });

  /// Handle initial dashboard load
  Future<void> _onLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    _log.infoWithContext(
      'Dashboard load requested',
      {'latitude': event.latitude, 'longitude': event.longitude},
    );

    emit(const DashboardLoading());

    final params = DashboardParams(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    final result = await _getDashboardUseCase(params);

    result.fold(
      (failure) {
        _log.errorWithContext(
          'Dashboard load failed',
          {'error': failure.message},
        );
        emit(DashboardError(failure.message));
      },
      (dashboard) {
        _log.infoWithContext(
          'Dashboard loaded successfully',
          {'sections_count': dashboard.sections.length},
        );
        emit(DashboardLoaded(dashboard));
      },
    );
  }

  /// Handle dashboard refresh
  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    _log.infoWithContext(
      'Dashboard refresh requested',
      {'latitude': event.latitude, 'longitude': event.longitude},
    );

    // Keep existing data while refreshing
    if (state is DashboardLoaded) {
      emit(DashboardRefreshing((state as DashboardLoaded).dashboard));
    }

    final params = DashboardParams(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    final result = await _getDashboardUseCase(params);

    result.fold(
      (failure) {
        _log.errorWithContext(
          'Dashboard refresh failed',
          {'error': failure.message},
        );
        // If we had data before, keep it and show error
        if (state is DashboardRefreshing) {
          emit(DashboardLoaded((state as DashboardRefreshing).dashboard));
        } else {
          emit(DashboardError(failure.message));
        }
      },
      (dashboard) {
        _log.infoWithContext(
          'Dashboard refreshed successfully',
          {'sections_count': dashboard.sections.length},
        );
        emit(DashboardLoaded(dashboard));
      },
    );
  }
}
