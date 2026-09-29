# Razorpay Payment Gateway Integration

This document provides instructions for setting up and using the Razorpay payment gateway integration in the checkout feature.

## Overview

The payment gateway integration supports two payment methods:
1. **Cash on Delivery (COD)** - Default option
2. **Online Payment via Razorpay** - Card, UPI, Wallets, Net Banking

## Setup Instructions

### 1. Configure Razorpay Credentials

1. Sign up at [Razorpay Dashboard](https://dashboard.razorpay.com/signup)
2. Get your API keys from [API Keys section](https://dashboard.razorpay.com/app/keys)
3. Update the `.env` file in the project root:

```env
# Razorpay Test Keys (for development)
RAZORPAY_KEY_ID=rzp_test_your_key_id_here
RAZORPAY_KEY_SECRET=your_key_secret_here

# For Production, use live keys:
# RAZORPAY_KEY_ID=rzp_live_your_key_id_here
# RAZORPAY_KEY_SECRET=your_key_secret_here
```

### 2. Install Dependencies

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 3. Test Payment Gateway

Use Razorpay test cards for testing:
- **Test Card**: 4111 1111 1111 1111
- **Any future expiry date**
- **Any CVV (e.g., 123)**

## Architecture

### Clean Architecture Layers

```
lib/
├── core/
│   └── services/
│       └── razorpay_service.dart         # Razorpay gateway service
├── features/
    ├── checkout/
    │   ├── domain/
    │   │   └── entities/
    │   │       ├── payment_method_selection.dart
    │   │       └── order_request.dart (updated with warehouse_id)
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── checkout_bloc.dart (payment method handling)
    │       │   ├── checkout_event.dart (SelectPaymentMethodEvent)
    │       │   └── checkout_state.dart
    │       ├── pages/
    │       │   └── checkout_page.dart (Razorpay integration)
    │       └── widgets/
    │           └── payment_method_selector_widget.dart
    └── payment/
        ├── domain/
        │   └── usecases/
        │       └── create_razorpay_order.dart
        ├── data/
        │   └── datasources/
        │       └── payment_mock_datasource.dart (mock order creation)
        └── presentation/
            └── pages/
                ├── payment_success_page.dart
                └── payment_failed_page.dart (with auto-redirect)
```

## Payment Flow

### Cash on Delivery (COD)
```
User selects COD → Clicks "Place Order" → Order created directly → Success page
```

### Online Payment (Razorpay)
```
User selects Pay Online → Clicks "Proceed to Pay" → Mock Razorpay order created → 
Razorpay checkout opens → User completes payment → On Success: Place order API → Success page
                                                  → On Failure: Failure page (auto-redirects to cart in 10s)
```

## Key Features

### 1. Payment Method Selection
- Radio button UI for choosing between COD and Online payment
- Visual indicators with payment method icons
- Payment logos (Razorpay, Cards, UPI, Wallets)

### 2. Razorpay Integration
- Mock server-side order creation
- Secure API key management via `.env`
- Comprehensive error handling
- Payment success/failure callbacks

### 3. Order Creation
- Default `warehouse_id = 1`
- Backend API call format:
  ```
  POST /api/order/place
  - address_id
  - warehouse_id
  - delivery_type
  - payment_method: "cod" or "online"
  ```

### 4. Success & Failure Pages
- **Success Page**: Shows order number and confirmation
- **Failure Page**: 
  - Displays error message and code
  - Auto-redirects to cart after 10 seconds
  - Manual retry and navigation options

## State Management

### Payment Method State (CheckoutBloc)
```dart
// Event
SelectPaymentMethodEvent(PaymentMethodSelection)

// State tracked in bloc
_selectedPaymentMethod: PaymentMethodSelection

// Getter for current selection
get selectedPaymentMethod => _selectedPaymentMethod
```

## Backend Integration Points

### 1. Razorpay Order Creation (Mocked)
Currently using mock data source. To integrate with backend:

```dart
// Update: lib/features/payment/data/datasources/payment_remote_datasource.dart
Future<PaymentOrderModel> createRazorpayOrder({
  required int amount,
  required String currency,
  required String receipt,
}) async {
  // Call your backend API: POST /api/razorpay/create-order
  final response = await dio.post('/api/razorpay/create-order', data: {
    'amount': amount,
    'currency': currency,
    'receipt': receipt,
  });
  return PaymentOrderModel.fromJson(response.data);
}
```

### 2. Order Placement
After successful payment, the app calls:
```
POST /api/order/place
Headers: Authorization: Bearer <token>
Body (form-data):
  - address_id: "6"
  - warehouse_id: "1"
  - delivery_type: "normal" | "express"
  - payment_method: "cod" | "online"
```

## Testing

### Test Payment Flow

1. **COD Testing**:
   - Select COD payment method
   - Click "Place Order"
   - Verify order creation

2. **Razorpay Testing**:
   - Select "Pay Online" method
   - Click "Proceed to Pay"
   - Use test card: 4111 1111 1111 1111
   - Complete payment
   - Verify order creation and success page

3. **Failure Testing**:
   - Use an invalid card or cancel payment
   - Verify failure page appears
   - Confirm auto-redirect to cart after 10 seconds

## Security Considerations

1. **API Keys**: Never commit real API keys to version control
2. **Key Management**: Use different keys for test and production
3. **Backend Verification**: Always verify payment signatures on the backend
4. **Amount Validation**: Backend should validate order amounts

## Troubleshooting

### Issue: "Payment gateway not configured"
**Solution**: Ensure `.env` file exists and contains valid `RAZORPAY_KEY_ID`

### Issue: Payment succeeds but order fails
**Solution**: Check backend API endpoint and authentication token

### Issue: Razorpay checkout doesn't open
**Solution**: 
- Verify razorpay_flutter package is installed
- Check Android/iOS permissions if needed
- Review console logs for errors

## Next Steps

1. Replace mock Razorpay order creation with actual backend API
2. Add payment verification on backend
3. Implement payment history tracking
4. Add refund functionality if needed
5. Configure production Razorpay keys before deployment

## Support

For Razorpay-specific issues, refer to:
- [Razorpay Documentation](https://razorpay.com/docs/)
- [Razorpay Flutter SDK](https://github.com/razorpay/razorpay-flutter)
- [Razorpay Support](https://razorpay.com/support/)
