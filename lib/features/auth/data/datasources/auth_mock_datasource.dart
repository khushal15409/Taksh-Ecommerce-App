import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:taksh_e_commerce/features/auth/data/models/auth_response_model.dart';
import 'package:taksh_e_commerce/features/auth/data/models/update_profile_data.dart';
import 'package:taksh_e_commerce/features/auth/data/models/user_model.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/update_profile_params.dart';

/// Mock implementation of AuthRemoteDataSource for development/testing
/// This allows you to test the app without making actual API calls
class AuthMockDataSource implements AuthRemoteDataSource {
  final _log = loggerWithContext({
    'feature': 'auth',
    'layer': 'datasource',
    'type': 'mock',
  });

  // Mock users database
  final Map<String, UserModel> _mockUsers = {
    '9876543210': UserModel(
      id: 1,
      name: 'John Doe',
      mobile: '9876543210',
      email: 'john.doe@example.com',
      profileImage: 'https://i.pravatar.cc/150?img=1',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    '9876543211': UserModel(
      id: 2,
      name: 'Jane Smith',
      mobile: '9876543211',
      email: 'jane.smith@example.com',
      profileImage: 'https://i.pravatar.cc/150?img=2',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now(),
    ),
    '9876543212': UserModel(
      id: 3,
      name: 'Bob Johnson',
      mobile: '9876543212',
      email: 'bob.johnson@example.com',
      profileImage: 'https://i.pravatar.cc/150?img=3',
      isVerified: false,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
    ),
  };

  // Mock OTP - always accept "123456" for any phone number
  static const String mockOtp = '1234';

  // Simulate network delay
  final Duration _networkDelay;

  AuthMockDataSource({
    Duration networkDelay = const Duration(milliseconds: 500),
  }) : _networkDelay = networkDelay;

  @override
  Future<String> sendOtp(String phone) async {
    _log.infoWithContext(
      'Mock: Sending OTP',
      {
        'phone': phone,
        'mock_otp': mockOtp,
      },
    );

    // Simulate network delay
    await Future.delayed(_networkDelay);

    // Generate a mock guest token
    final guestToken =
        'mock_guest_token_${DateTime.now().millisecondsSinceEpoch}';

    _log.infoWithContext(
      'Mock: OTP sent successfully',
      {
        'phone': phone,
        'guest_token': guestToken,
        'hint': 'Use OTP: $mockOtp',
      },
    );

    return guestToken;
  }

  @override
  Future<AuthResponseModel> verifyOtp(
    String phone,
    String otp,
    String guestToken,
  ) async {
    _log.infoWithContext(
      'Mock: Verifying OTP',
      {
        'phone': phone,
        'otp': otp,
        'guest_token': guestToken,
      },
    );

    // Simulate network delay
    await Future.delayed(_networkDelay);

    // Check if OTP is correct
    if (otp != mockOtp) {
      _log.warnWithContext(
        'Mock: Invalid OTP',
        {
          'phone': phone,
          'provided_otp': otp,
          'expected_otp': mockOtp,
        },
      );
      throw Exception('Invalid OTP. Use: $mockOtp');
    }

    // Get or create user
    UserModel user;
    if (_mockUsers.containsKey(phone)) {
      user = _mockUsers[phone]!;
      _log.infoWithContext(
        'Mock: Existing user found',
        {
          'user_id': user.id,
          'user_name': user.name,
        },
      );
    } else {
      // Create new user for unknown phone numbers
      user = UserModel(
        id: _mockUsers.length + 1,
        name: 'New User',
        mobile: phone,
        email: null,
        profileImage: 'https://i.pravatar.cc/150?img=${_mockUsers.length + 1}',
        isVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _mockUsers[phone] = user;
      _log.infoWithContext(
        'Mock: New user created',
        {
          'user_id': user.id,
          'phone': phone,
        },
      );
    }

    // Generate mock token
    final token =
        'mock_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';

    final authData = AuthData(
      user: user,
      token: token,
    );

    final response = AuthResponseModel(
      success: true,
      message: 'OTP verified successfully',
      data: authData,
    );

    _log.infoWithContext(
      'Mock: OTP verified successfully',
      {
        'user_id': user.id,
        'user_name': user.name,
        'token_length': token.length,
      },
    );

    return response;
  }

  @override
  Future<UpdateProfileData> fetchProfile() async {
    _log.infoWithContext(
      'Mock: Fetching profile',
      {},
    );

    // Simulate network delay
    await Future.delayed(_networkDelay);

    // Return mock profile data
    return const UpdateProfileData(
      firstName: 'Mock',
      lastName: 'User',
      email: 'mock@example.com',
      mobile: '9876543210',
    );
  }

  @override
  Future<UpdateProfileData> updateProfile(UpdateProfileParams params) async {
    _log.infoWithContext(
      'Mock: Updating profile',
      {
        'has_first_name': params.firstName?.isNotEmpty ?? false,
        'has_last_name': params.lastName?.isNotEmpty ?? false,
        'has_email': params.email?.isNotEmpty ?? false,
        'has_mobile': params.mobile?.isNotEmpty ?? false,
      },
    );

    // Simulate network delay
    await Future.delayed(_networkDelay);

    return UpdateProfileData(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      mobile: params.mobile,
    );
  }

  /// Helper method to add custom mock users
  void addMockUser(UserModel user) {
    _mockUsers[user.mobile] = user;
    _log.debugWithContext(
      'Mock: User added to mock database',
      {
        'user_id': user.id,
        'phone': user.mobile,
      },
    );
  }

  /// Helper method to clear all mock users
  void clearMockUsers() {
    _mockUsers.clear();
    _log.debugWithContext('Mock: All users cleared', {});
  }

  /// Get all mock users (for debugging)
  Map<String, UserModel> getMockUsers() => Map.unmodifiable(_mockUsers);
}
