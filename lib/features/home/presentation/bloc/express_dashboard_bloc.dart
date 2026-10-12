import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/home/domain/usecases/get_express_dashboard_usecase.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/express_dashboard_event.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/express_dashboard_state.dart';

/// BLoC for express dashboard
class ExpressDashboardBloc
    extends Bloc<ExpressDashboardEvent, ExpressDashboardState> {
  final GetExpressDashboardUseCase _getExpressDashboardUseCase;

  ExpressDashboardBloc({
    required GetExpressDashboardUseCase getExpressDashboardUseCase,
  })  : _getExpressDashboardUseCase = getExpressDashboardUseCase,
        super(const ExpressDashboardInitial()) {
    on<ExpressDashboardLoadRequested>(_onLoadRequested);
    on<ExpressDashboardRefreshRequested>(_onRefreshRequested);
  }

  /// Id of the latest request. Responses of older requests (e.g. for the
  /// previously selected address) are dropped so they never overwrite the
  /// dashboard of the current address.
  int _requestSeq = 0;

  final _log = loggerWithContext({
    'feature': 'home',
    'layer': 'bloc',
    'bloc': 'ExpressDashboardBloc',
  });

  Future<void> _onLoadRequested(
    ExpressDashboardLoadRequested event,
    Emitter<ExpressDashboardState> emit,
  ) async {
    _log.infoWithContext(
      'Express dashboard load requested',
      {
        'latitude': event.latitude,
        'longitude': event.longitude,
        'pincode': event.pincode,
      },
    );

    final seq = ++_requestSeq;
    emit(const ExpressDashboardLoading());

    final params = ExpressDashboardParams(
      latitude: event.latitude,
      longitude: event.longitude,
      pincode: event.pincode,
    );

    final result = await _getExpressDashboardUseCase(params);
    if (seq != _requestSeq) return;

    result.fold(
      (failure) {
        _log.errorWithContext(
          'Express dashboard load failed',
          {'error': failure.message},
        );
        emit(ExpressDashboardError(failure.message));
      },
      (dashboard) {
        _log.infoWithContext(
          'Express dashboard loaded successfully',
          {'sections_count': dashboard.sections.length},
        );
        emit(ExpressDashboardLoaded(dashboard));
      },
    );
  }

  Future<void> _onRefreshRequested(
    ExpressDashboardRefreshRequested event,
    Emitter<ExpressDashboardState> emit,
  ) async {
    _log.infoWithContext(
      'Express dashboard refresh requested',
      {
        'latitude': event.latitude,
        'longitude': event.longitude,
        'pincode': event.pincode,
      },
    );

    final seq = ++_requestSeq;
    if (state is ExpressDashboardLoaded) {
      emit(ExpressDashboardRefreshing(
          (state as ExpressDashboardLoaded).dashboard));
    }

    final params = ExpressDashboardParams(
      latitude: event.latitude,
      longitude: event.longitude,
      pincode: event.pincode,
    );

    final result = await _getExpressDashboardUseCase(params);
    if (seq != _requestSeq) return;

    result.fold(
      (failure) {
        _log.errorWithContext(
          'Express dashboard refresh failed',
          {'error': failure.message},
        );
        if (state is ExpressDashboardRefreshing) {
          emit(ExpressDashboardLoaded(
              (state as ExpressDashboardRefreshing).dashboard));
        } else {
          emit(ExpressDashboardError(failure.message));
        }
      },
      (dashboard) {
        _log.infoWithContext(
          'Express dashboard refreshed successfully',
          {'sections_count': dashboard.sections.length},
        );
        emit(ExpressDashboardLoaded(dashboard));
      },
    );
  }
}
