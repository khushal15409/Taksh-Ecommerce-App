import 'package:equatable/equatable.dart';

/// Request entity for delivery boy join request
class DeliveryBoyJoinRequest extends Equatable {
  final String name;
  final String mobile;
  final String? email;
  final String? address;
  final String? pincode;
  final String? description;

  const DeliveryBoyJoinRequest({
    required this.name,
    required this.mobile,
    this.email,
    this.address,
    this.pincode,
    this.description,
  });

  @override
  List<Object?> get props => [name, mobile, email, address, pincode, description];
}
