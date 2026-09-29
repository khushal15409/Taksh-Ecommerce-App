import 'package:taksh_e_commerce/app.dart' as app;

/// Mock entry point for development without API calls
/// 
/// This main file uses mock data sources instead of real API calls,
/// allowing you to develop and test the app without a backend connection.
/// 
/// To use this:
/// 1. Run: flutter run -t lib/main_mock.dart
/// 2. Use any phone number (e.g., 9876543210, 9876543211, 9876543212)
/// 3. Use OTP: 123456 (always works)
/// 
/// Pre-configured mock users:
/// - 9876543210: John Doe (verified)
/// - 9876543211: Jane Smith (verified)
/// - 9876543212: Bob Johnson (not verified)
/// 
/// Any other phone number will create a new mock user automatically.
void main() async {
  await app.runApp(app.AppConfig.mock());
}
