import 'package:equatable/equatable.dart';

/// Entity representing a recent search term
class RecentSearch extends Equatable {
  final String searchTerm;

  const RecentSearch({
    required this.searchTerm,
  });

  @override
  List<Object?> get props => [searchTerm];
}
