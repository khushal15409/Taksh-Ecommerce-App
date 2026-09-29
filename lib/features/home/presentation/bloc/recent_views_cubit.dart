import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/recent_views_state.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_recent_views.dart';

/// Cubit for managing recent views state
class RecentViewsCubit extends Cubit<RecentViewsState> {
  final GetRecentViews getRecentViews;
  final _log = loggerWithContext({'feature': 'home', 'layer': 'cubit'});

  RecentViewsCubit({required this.getRecentViews})
      : super(const RecentViewsInitial());

  Future<void> loadRecentViews() async {
    _log.infoWithContext('Loading recent views', {});
    emit(const RecentViewsLoading());

    final result = await getRecentViews();

    if (isClosed) return;

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to load recent views', {
          'error': failure.message,
        });
        emit(RecentViewsError(failure.message));
      },
      (views) {
        _log.infoWithContext('Recent views loaded', {
          'count': views.length,
        });
        emit(RecentViewsLoaded(views));
      },
    );
  }
}
