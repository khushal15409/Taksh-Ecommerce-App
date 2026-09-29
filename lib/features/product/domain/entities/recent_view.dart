import 'package:equatable/equatable.dart';

/// Entity representing a recently viewed product
class RecentView extends Equatable {
  final int id;
  final String name;
  final int price;
  final String thumbnail;

  const RecentView({
    required this.id,
    required this.name,
    required this.price,
    required this.thumbnail,
  });

  @override
  List<Object?> get props => [id, name, price, thumbnail];
}
