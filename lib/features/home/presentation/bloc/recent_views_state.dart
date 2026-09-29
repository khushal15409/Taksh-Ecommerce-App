import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/recent_view.dart';

/// Base state for recent views
abstract class RecentViewsState extends Equatable {
  const RecentViewsState();

  @override
  List<Object?> get props => [];
}

class RecentViewsInitial extends RecentViewsState {
  const RecentViewsInitial();
}

class RecentViewsLoading extends RecentViewsState {
  const RecentViewsLoading();
}

class RecentViewsLoaded extends RecentViewsState {
  final List<RecentView> recentViews;

  const RecentViewsLoaded(this.recentViews);

  @override
  List<Object?> get props => [recentViews];
}

class RecentViewsError extends RecentViewsState {
  final String message;

  const RecentViewsError(this.message);

  @override
  List<Object?> get props => [message];
}
