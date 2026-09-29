# API Response Models

## Overview
All API responses follow a standardized schema with three mandatory fields:
- `success`: Boolean indicating if the request was successful
- `message`: String message describing the result
- `data`: Generic data object containing response-specific data

## Base Response Model

```dart
class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;
}
```

## Usage Examples

### 1. Send OTP Response

**API Response:**
```json
{
    "success": true,
    "message": "OTP sent successfully",
    "data": {
        "message": "OTP sent. Use 1234 for verification (TEST MODE)",
        "expires_at": "2026-01-12 16:51:34"
    }
}
```

**Dart Model:**
```dart
class SendOtpData {
  final String message;
  final String expiresAt;
}

// Usage in datasource
final baseResponse = BaseResponse.fromJson(
  responseData,
  (json) => SendOtpData.fromJson(json as DataMap),
);

if (!baseResponse.success) {
  throw ServerException(baseResponse.message);
}

print(baseResponse.data?.message); // "OTP sent. Use 1234..."
print(baseResponse.data?.expiresAt); // "2026-01-12 16:51:34"
```

### 2. Verify OTP Response

**API Response:**
```json
{
    "success": true,
    "message": "Login successful",
    "data": {
        "access_token": "eyJhbGciOiJIUzI1NiIs...",
        "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
        "user": {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com",
            "phone": "+919876543210"
        }
    }
}
```

**Dart Model:**
```dart
class AuthData {
  final String? accessToken;
  final String? refreshToken;
  final DataMap? user;
}

// Usage in datasource
final baseResponse = BaseResponse.fromJson(
  responseData,
  (json) => AuthData.fromJson(json as DataMap),
);

if (!baseResponse.success) {
  throw AuthException(baseResponse.message);
}

final authData = baseResponse.data;
if (authData?.accessToken == null) {
  throw const AuthException('Access token not received');
}
```

## Creating New Response Models

When creating a new API endpoint response:

1. **Create the data model** for the `data` field:
```dart
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class YourData {
  final String someField;
  final int anotherField;

  const YourData({
    required this.someField,
    required this.anotherField,
  });

  factory YourData.fromJson(DataMap json) => _$YourDataFromJson(json);
  DataMap toJson() => _$YourDataToJson(this);
}
```

2. **Use BaseResponse in your datasource**:
```dart
Future<YourData> yourMethod() async {
  final response = await _apiClient.post('/your-endpoint');
  final responseData = response.data as DataMap;
  
  final baseResponse = BaseResponse.fromJson(
    responseData,
    (json) => YourData.fromJson(json as DataMap),
  );

  if (!baseResponse.success) {
    throw ServerException(baseResponse.message);
  }

  if (baseResponse.data == null) {
    throw ServerException('Data not received');
  }

  return baseResponse.data!;
}
```

3. **Run build_runner** to generate serialization code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Error Handling

All responses will have the `success` field. Check this field first:

```dart
final baseResponse = BaseResponse.fromJson(responseData, ...);

if (!baseResponse.success) {
  // Handle error - message field contains error description
  throw ServerException(baseResponse.message);
}

// Success case - proceed with data
final data = baseResponse.data;
```

## Benefits of This Approach

1. **Consistency**: All API responses follow the same structure
2. **Type Safety**: Generic type parameter ensures compile-time type checking
3. **Error Handling**: Standardized success/message fields for uniform error handling
4. **Flexibility**: Can wrap any data type in BaseResponse
5. **Maintainability**: Easy to add new endpoints following the same pattern
