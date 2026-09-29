import 'package:equatable/equatable.dart';

/// Response entity for vendor registration
class VendorJoinResponse extends Equatable {
  final int vendorId;
  final int? userId;
  final int? documentsUploaded;
  final String? assignedSalesman;
  final String message;

  const VendorJoinResponse({
    required this.vendorId,
    this.userId,
    this.documentsUploaded,
    this.assignedSalesman,
    required this.message,
  });

  @override
  List<Object?> get props => [
        vendorId,
        userId,
        documentsUploaded,
        assignedSalesman,
        message,
      ];
}
