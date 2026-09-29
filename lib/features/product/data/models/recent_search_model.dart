import 'package:taksh_e_commerce/features/product/domain/entities/recent_search.dart';

/// Model for recent search
class RecentSearchModel extends RecentSearch {
  const RecentSearchModel({
    required super.searchTerm,
  });

  factory RecentSearchModel.fromJson(String searchTerm) {
    return RecentSearchModel(
      searchTerm: searchTerm,
    );
  }

  String toJson() => searchTerm;
}
