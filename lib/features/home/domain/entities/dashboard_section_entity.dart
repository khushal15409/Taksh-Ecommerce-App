import 'package:equatable/equatable.dart';

/// Dashboard section entity representing a section in the dashboard
/// Sections can contain banners, products, or other data types
class DashboardSectionEntity extends Equatable {
  final String key;
  final List<dynamic> data;
  final String? message;

  const DashboardSectionEntity({
    required this.key,
    required this.data,
    this.message,
  });

  /// Check if section has data
  bool get hasData => data.isNotEmpty;

  /// Check if section is empty with a message
  bool get isEmpty => data.isEmpty && message != null;

  @override
  List<Object?> get props => [key, data, message];
}
