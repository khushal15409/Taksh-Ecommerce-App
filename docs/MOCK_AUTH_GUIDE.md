# Mock Authentication Guide

This guide explains how to use the mock authentication system to test your app's authentication flow without making actual API calls.

## Overview

The mock authentication system provides a complete simulation of the auth flow:
- **Send OTP**: Accepts any phone number and returns a mock guest token
- **Verify OTP**: Validates OTP and returns a mock user with authentication token
- **No Network Required**: Works completely offline
- **Configurable Delays**: Simulates network latency for realistic testing

## Quick Start

### 1. Enable Mock Auth Mode

To use mock authentication, simply pass `useMockAuth: true` when creating your app configuration:

```dart
// In lib/main.dart
void main() async {
  await app.runApp(
    app.AppConfig.development(useMockAuth: true), // Enable mock auth
  );
}
```

### 2. Test Credentials

When mock auth is enabled, use these test credentials:

- **Phone Number**: Any valid phone number (10+ digits)
- **OTP**: `123456` (this is the only valid OTP in mock mode)
- **Guest Token**: Automatically generated as `mock_guest_token_12345`
- **Auth Token**: Returns `mock_auth_token_abcdef123456`

### 3. Mock User Data

The mock system returns a user with the following structure:

```dart
UserModel(
  id: <timestamp>,              // Unique ID based on current timestamp
  name: 'Mock User',            // Fixed name
  mobile: <your_phone_number>,  // The phone number you provided
  email: 'mock.user@example.com',
  profileImage: null,
  isVerified: true,
  createdAt: <current_time>,
  updatedAt: <current_time>,
)
```

## Usage Examples

### Example 1: Development with Mock Auth

```dart
// lib/main.dart
import 'package:taksh_e_commerce/app.dart' as app;

void main() async {
  // Use mock auth for development
  await app.runApp(
    app.AppConfig.development(useMockAuth: true),
  );
}
```

### Example 2: Testing Real API

```dart
// lib/main.dart
import 'package:taksh_e_commerce/app.dart' as app;

void main() async {
  // Use real API calls
  await app.runApp(
    app.AppConfig.development(useMockAuth: false),
  );
}
```

### Example 3: Staging with Mock Auth

```dart
// lib/main_staging.dart
import 'package:taksh_e_commerce/app.dart' as app;

void main() async {
  // Use mock auth in staging for testing
  await app.runApp(
    app.AppConfig.staging(useMockAuth: true),
  );
}
```

## Testing the Auth Flow

### Step 1: Send OTP

1. Enter any phone number (e.g., `9876543210`)
2. Click "Send OTP"
3. Mock system will:
   - Simulate 1 second network delay
   - Return success with guest token
   - Log the operation

**Expected Behavior:**
- Success message appears
- Guest token is stored internally
- OTP input field becomes active

### Step 2: Verify OTP

1. Enter the OTP: `123456`
2. Click "Verify OTP"
3. Mock system will:
   - Validate the OTP (only `123456` is valid)
   - Simulate 1 second network delay
   - Return mock user data
   - Save user and token locally
   - Navigate to home screen

**Expected Behavior:**
- User is logged in
- Navigation to home/dashboard
- User data is cached locally

### Step 3: Test Invalid OTP

1. Enter any OTP other than `123456` (e.g., `000000`)
2. Click "Verify OTP"
3. Mock system will:
   - Reject the OTP
   - Show error message: "Invalid OTP. Use '123456' for testing."

## Configuration Options

### Network Delay

You can customize the simulated network delay in [`lib/core/di/injector.dart`](../lib/core/di/injector.dart):

```dart
getIt.registerLazySingleton<AuthRemoteDataSource>(
  () => const AuthRemoteDataSourceMock(
    networkDelayMs: 2000, // Change to 2 seconds
  ),
);
```

### Valid OTP

To change the valid OTP, modify [`lib/features/auth/data/datasources/auth_remote_datasource_mock.dart`](../lib/features/auth/data/datasources/auth_remote_datasource_mock.dart):

```dart
/// Valid OTP for testing (any other OTP will fail)
static const String validOtp = '999999'; // Change to your preferred OTP
```

## Switching Between Mock and Real Auth

### Method 1: Environment-Based (Recommended)

Create separate entry points for different modes:

```dart
// lib/main_mock.dart - For mock testing
import 'package:taksh_e_commerce/app.dart' as app;

void main() async {
  await app.runApp(
    app.AppConfig.development(useMockAuth: true),
  );
}

// lib/main.dart - For real API
import 'package:taksh_e_commerce/app.dart' as app;

void main() async {
  await app.runApp(
    app.AppConfig.development(useMockAuth: false),
  );
}
```

Run with:
```bash
# Mock mode
flutter run -t lib/main_mock.dart

# Real API mode
flutter run -t lib/main.dart
```

### Method 2: Environment Variables

```dart
// lib/main.dart
import 'package:taksh_e_commerce/app.dart' as app;

void main() async {
  const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: false);
  
  await app.runApp(
    app.AppConfig.development(useMockAuth: useMock),
  );
}
```

Run with:
```bash
# Mock mode
flutter run --dart-define=USE_MOCK_AUTH=true

# Real API mode
flutter run --dart-define=USE_MOCK_AUTH=false
```

## Logging

When mock auth is enabled, you'll see detailed logs:

```
[INFO] Starting dependency injection setup
  base_url: https://dev-api.example.com
  use_mock_auth: true

[INFO] Using MOCK auth remote datasource
  mode: mock

[INFO] Mock: Sending OTP
  phone_length: 10
  network_delay_ms: 1000

[INFO] Mock: OTP sent successfully
  guest_token: mock_guest_token_12345
  valid_otp: 123456

[INFO] Mock: Verifying OTP
  phone_length: 10
  otp_length: 6

[INFO] Mock: OTP verified successfully
  user_id: 1705308123456
  user_name: Mock User
  user_mobile: 9876543210
```

## Benefits of Mock Auth

1. **Offline Development**: Work without internet connection
2. **Faster Testing**: No network latency or API rate limits
3. **Predictable Results**: Consistent behavior for testing
4. **No API Costs**: Save on API calls during development
5. **Easy Debugging**: Clear logs and predictable flow
6. **UI/UX Testing**: Focus on frontend without backend dependencies

## Limitations

1. **Production**: Mock auth is automatically disabled in production
2. **Single Valid OTP**: Only one OTP (`123456`) is valid
3. **No Real Validation**: Phone number format is minimally validated
4. **Fixed User Data**: Returns the same user structure every time
5. **No Persistence**: Mock data doesn't persist across app restarts (except cached data)

## Troubleshooting

### Issue: Mock auth not working

**Solution**: Check that `useMockAuth: true` is set in your app configuration:

```dart
await app.runApp(
  app.AppConfig.development(useMockAuth: true),
);
```

### Issue: OTP verification fails

**Solution**: Make sure you're using the correct OTP: `123456`

### Issue: Still making API calls

**Solution**: 
1. Check logs for "Using MOCK auth remote datasource"
2. Restart the app after changing configuration
3. Clear app data and reinstall if needed

### Issue: Want different mock data

**Solution**: Modify [`auth_remote_datasource_mock.dart`](../lib/features/auth/data/datasources/auth_remote_datasource_mock.dart) to customize:
- User name
- Email
- Valid OTP
- Network delay
- Token format

## Best Practices

1. **Use Mock for UI Development**: Perfect for building and testing UI flows
2. **Switch to Real for Integration Testing**: Test with actual API before release
3. **Document Test Credentials**: Keep this guide updated with test credentials
4. **Log Everything**: Mock mode includes detailed logging for debugging
5. **Version Control**: Commit mock implementations for team collaboration

## Architecture

The mock system follows the same architecture as the real implementation:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (AuthBloc, LoginPage, etc.)           │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│          Domain Layer                   │
│  (UseCases, Repository Interface)      │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Data Layer                    │
│  ┌─────────────────────────────────┐   │
│  │  AuthRepositoryImpl             │   │
│  └──────────┬──────────────────────┘   │
│             │                           │
│  ┌──────────▼──────────────────────┐   │
│  │  AuthRemoteDataSource           │   │
│  │  ├─ Real (API calls)            │   │
│  │  └─ Mock (simulated)  ◄─────────┼───┤ Switchable
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

## Related Files

- [`lib/features/auth/data/datasources/auth_remote_datasource_mock.dart`](../lib/features/auth/data/datasources/auth_remote_datasource_mock.dart) - Mock implementation
- [`lib/features/auth/data/datasources/auth_remote_datasource.dart`](../lib/features/auth/data/datasources/auth_remote_datasource.dart) - Real implementation
- [`lib/core/di/injector.dart`](../lib/core/di/injector.dart) - Dependency injection configuration
- [`lib/app.dart`](../lib/app.dart) - App configuration with mock flag
- [`lib/main.dart`](../lib/main.dart) - App entry point

## Support

For issues or questions about mock authentication:
1. Check the logs for detailed error messages
2. Review this guide for common solutions
3. Examine the mock implementation source code
4. Contact the development team