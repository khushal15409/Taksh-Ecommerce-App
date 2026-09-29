import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taksh_e_commerce/core/utils/secure_store.dart';
import 'package:taksh_e_commerce/core/constants/storage_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/auth/data/models/user_model.dart';

/// Local data source for authentication
abstract class AuthLocalDataSource {
  /// Save user data to local storage
  Future<void> saveUser(UserModel user);

  /// Get user data from local storage
  Future<UserModel> getUser();

  /// Save authentication token
  Future<void> saveToken(String token);

  /// Get authentication token
  Future<String?> getToken();

  /// Mark user as logged in
  Future<void> setLoggedIn(bool isLoggedIn);

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Clear all user data (logout)
  Future<void> clearUserData();
}

/// Implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;
  final SecureStore _secureStore;

  AuthLocalDataSourceImpl({
    required SharedPreferences sharedPreferences,
    SecureStore? secureStore,
  })  : _prefs = sharedPreferences,
        _secureStore = secureStore ?? GetIt.instance<SecureStore>();

  @override
  Future<void> saveUser(UserModel user) async {
    final log = loggerWithContext(
        {'feature': 'auth', 'source': 'local', 'action': 'saveUser'});
    try {
      await _prefs.setInt(StorageConstants.userId, user.id);
      await _prefs.setString(StorageConstants.userName, user.name ?? '');
      await _prefs.setString(StorageConstants.userPhone, user.mobile);
      await _prefs.setBool(StorageConstants.userIsVerified, user.isVerified);

      // Handle email: save if not null/empty, remove if null/empty to avoid stale data
      if (user.email != null && user.email!.trim().isNotEmpty) {
        await _prefs.setString(StorageConstants.userEmail, user.email!.trim());
      } else {
        await _prefs.remove(StorageConstants.userEmail);
      }

      // Handle profile image: save if not null/empty, remove if null/empty
      if (user.profileImage != null && user.profileImage!.trim().isNotEmpty) {
        await _prefs.setString(
            StorageConstants.userProfileImage, user.profileImage!.trim());
      } else {
        await _prefs.remove(StorageConstants.userProfileImage);
      }

      log.debug(
          'SAVE user: ${user.name ?? ''}, email: ${user.email ?? 'null'}');
    } catch (e) {
      log.error('Error saving user data', e);
      throw CacheException('Failed to save user data: $e');
    }
  }

  @override
  Future<UserModel> getUser() async {
    final log = loggerWithContext(
        {'feature': 'auth', 'source': 'local', 'action': 'getUser'});
    try {
      final userId = _prefs.getInt(StorageConstants.userId);
      final userName = _prefs.getString(StorageConstants.userName);
      final userPhone = _prefs.getString(StorageConstants.userPhone);
      final isVerified =
          _prefs.getBool(StorageConstants.userIsVerified) ?? false;

      if (userId == null || userName == null || userPhone == null) {
        throw const CacheException('User data not found');
      }

      final user = UserModel(
        id: userId,
        name: userName,
        mobile: userPhone,
        isVerified: isVerified,
        email: _prefs.getString(StorageConstants.userEmail),
        profileImage: _prefs.getString(StorageConstants.userProfileImage),
        createdAt: null,
        updatedAt: null,
      );

      log.debug('GET user: ${user.name}');
      return user;
    } catch (e) {
      log.error('Error getting user data', e);
      if (e is CacheException) rethrow;
      throw CacheException('Failed to get user data: $e');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    final log = loggerWithContext(
        {'feature': 'auth', 'source': 'local', 'action': 'saveToken'});
    try {
      await _secureStore.saveToken(token);
      log.debug('SAVE token');
    } catch (e) {
      log.error('Error saving token', e);
      throw CacheException('Failed to save token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    final log = loggerWithContext(
        {'feature': 'auth', 'source': 'local', 'action': 'getToken'});
    try {
      return await _secureStore.getToken();
    } catch (e) {
      log.error('Error getting token', e);
      return null;
    }
  }

  @override
  Future<void> setLoggedIn(bool isLoggedIn) async {
    final log = loggerWithContext(
        {'feature': 'auth', 'source': 'local', 'action': 'setLoggedIn'});
    try {
      await _prefs.setBool(StorageConstants.isLoggedIn, isLoggedIn);
      log.debug('SET isLoggedIn: $isLoggedIn');
    } catch (e) {
      log.error('Error setting logged in status', e);
      throw CacheException('Failed to set logged in status: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return _prefs.getBool(StorageConstants.isLoggedIn) ?? false;
    } catch (e) {
      final log = loggerWithContext(
          {'feature': 'auth', 'source': 'local', 'action': 'isLoggedIn'});
      log.error('Error checking logged in status', e);
      return false;
    }
  }

  @override
  Future<void> clearUserData() async {
    final log = loggerWithContext(
        {'feature': 'auth', 'source': 'local', 'action': 'clearUserData'});
    try {
      await _secureStore.clearToken();
      await _prefs.remove(StorageConstants.userId);
      await _prefs.remove(StorageConstants.userName);
      await _prefs.remove(StorageConstants.userPhone);
      await _prefs.remove(StorageConstants.userEmail);
      await _prefs.remove(StorageConstants.userProfileImage);
      await _prefs.remove(StorageConstants.userIsVerified);
      await _prefs.setBool(StorageConstants.isLoggedIn, false);

      log.debug('CLEAR user_data');
    } catch (e) {
      log.error('Error clearing user data', e);
      throw CacheException('Failed to clear user data: $e');
    }
  }
}
