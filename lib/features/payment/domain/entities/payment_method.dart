/// Payment method enum
enum PaymentMethod {
  razorpay,
  cod,
  card,
  upi,
  netbanking,
  wallet;

  String get displayName {
    switch (this) {
      case PaymentMethod.razorpay:
        return 'Razorpay';
      case PaymentMethod.cod:
        return 'Cash on Delivery';
      case PaymentMethod.card:
        return 'Credit/Debit Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.netbanking:
        return 'Net Banking';
      case PaymentMethod.wallet:
        return 'Wallet';
    }
  }
}
