import 'package:equatable/equatable.dart';

/// Pagination link entity
class PaginationLink extends Equatable {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  const PaginationLink({
    this.url,
    required this.label,
    this.page,
    required this.active,
  });

  @override
  List<Object?> get props => [
        url,
        label,
        page,
        active,
      ];
}
