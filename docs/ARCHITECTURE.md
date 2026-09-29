# Clean Architecture Guide

## Overview

This project follows **Clean Architecture** principles by Robert C. Martin (Uncle Bob), ensuring:
- Separation of concerns
- Testability
- Independence from frameworks
- Independence from UI
- Independence from databases

## Architecture Layers

### 1. Domain Layer (Innermost - Pure Dart)

**Location**: `lib/features/[feature]/domain/`

**Purpose**: Contains the business logic and rules of the application.

**Components**:

#### Entities (`entities/`)
- Pure Dart classes representing business objects
- No dependencies on Flutter or external packages
- Use `Equatable` for value equality
- Example: `User`, `AuthCredentials`

```dart
class User extends Equatable {
  final String id;
  final String name;
  final String phone;
  
  const User({required this.id, required this.name, required this.phone});
  
  @override
  List<Object?> get props => [id, name, phone];
}
```

#### Repository Interfaces (`repositories/`)
- Abstract contracts defining data operations
- Return types use `Either<Failure, T>` from Dartz
- No implementation details

```dart
abstract class AuthRepository {
  ResultFuture<User> verifyOtp(OtpCredentials credentials);
  ResultVoid logout();
}
```

#### Use Cases (`usecases/`)
- Single responsibility business logic
- Each use case performs one specific action
- Depends only on repository interfaces

```dart
class VerifyOtpUseCase extends UseCase<User, OtpCredentials> {
  final AuthRepository _repository;
  
  const VerifyOtpUseCase(this._repository);
  
  @override
  ResultFuture<User> call(OtpCredentials params) {
    return _repository.verifyOtp(params);
  }
}
```

**Key Rules**:
- ✅ No Flutter imports
- ✅ No external package imports (except Equatable, Dartz)
- ✅ Pure business logic only
- ✅ All methods return `Either<Failure, T>`

---

### 2. Data Layer (Middle Layer)

**Location**: `lib/features/[feature]/data/`

**Purpose**: Implements domain contracts and handles data operations.

**Components**:

#### Models (`models/`)
- Extend domain entities
- Add JSON serialization/deserialization
- Convert between domain entities and API responses

```dart
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.phone,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
}
```

#### Data Sources (`datasources/`)

**Remote Data Source**:
- Communicates with external APIs
- Uses `ApiClient` (Dio wrapper)
- Throws exceptions on errors
- Returns raw data (models)

```dart
abstract class AuthRemoteDataSource {
  Future<String> sendOtp(String phone);
  Future<AuthResponseModel> verifyOtp(String phone, String otp, String token);
}
```

**Local Data Source**:
- Manages local storage (SharedPreferences, Hive)
- Caches data for offline access
- Throws `CacheException` on errors

```dart
abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel> getUser();
  Future<void> clearUserData();
}
```

#### Repository Implementation (`repositories/`)
- Implements domain repository interface
- Coordinates between remote and local data sources
- Handles network connectivity checks
- Converts exceptions to failures
- Returns `Either<Failure, T>`

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  
  @override
  ResultFuture<User> verifyOtp(OtpCredentials credentials) async {
    try {
      // Check network
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      
      // Fetch from remote
      final response = await _remoteDataSource.verifyOtp(...);
      final user = UserModel.fromJson(response.user);
      
      // Cache locally
      await _localDataSource.saveUser(user);
      
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
```

**Key Rules**:
- ✅ Implements domain interfaces
- ✅ Converts exceptions to failures
- ✅ Checks network before remote calls
- ✅ Caches data when possible
- ✅ Returns `Either<Failure, T>`

---

### 3. Presentation Layer (Outermost - UI)

**Location**: `lib/features/[feature]/presentation/`

**Purpose**: Handles UI, user interactions, and state management.

**Components**:

#### BLoC (`bloc/`)

**Events** (`auth_event.dart`):
- User actions and intents
- Immutable classes extending `Equatable`

```dart
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String phone;
  final String otp;
  
  const AuthVerifyOtpRequested({required this.phone, required this.otp});
  
  @override
  List<Object?> get props => [phone, otp];
}
```

**States** (`auth_state.dart`):
- Application states
- Immutable classes extending `Equatable`

```dart
abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
```

**BLoC** (`auth_bloc.dart`):
- Business logic component
- Transforms events into states
- Uses use cases from domain layer

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  
  AuthBloc({required VerifyOtpUseCase verifyOtpUseCase})
      : _verifyOtpUseCase = verifyOtpUseCase,
        super(const AuthInitial()) {
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
  }
  
  Future<void> _onVerifyOtpRequested(
    AuthVerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    final credentials = OtpCredentials(phone: event.phone, otp: event.otp);
    final result = await _verifyOtpUseCase(credentials);
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }
}
```

#### Pages (`pages/`)
- Full-screen widgets
- Contain BlocProvider and BlocListener
- Handle navigation and snackbars

```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(...);
            }
          },
          builder: (context, state) {
            return LoginForm();
          },
        ),
      ),
    );
  }
}
```

#### Widgets (`widgets/`)
- Reusable UI components
- Stateless when possible
- Accept data through constructor

**Key Rules**:
- ✅ Only depends on domain layer
- ✅ Uses BLoC for state management
- ✅ No business logic in widgets
- ✅ Handles UI-related concerns only

---

## Dependency Flow

```
Presentation Layer
       ↓ (uses)
  Domain Layer
       ↓ (implements)
   Data Layer
```

**Important**: 
- Presentation depends on Domain
- Data implements Domain contracts
- Domain depends on nothing (pure Dart)

---

## Error Handling Pattern

### 1. Exceptions (Data Layer)
Thrown by data sources when operations fail:

```dart
throw ServerException('API error', 500);
throw CacheException('Failed to save data');
throw NetworkException('No internet');
```

### 2. Failures (Domain Layer)
Returned as `Left` in `Either<Failure, T>`:

```dart
return const Left(ServerFailure('API error'));
return const Left(CacheFailure('Failed to save'));
return const Left(NetworkFailure('No internet'));
```

### 3. Error States (Presentation Layer)
Displayed to users:

```dart
if (state is AuthError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(state.message)),
  );
}
```

---

## Dependency Injection

All dependencies are registered in `lib/core/di/injector.dart`:

```dart
// Data sources
getIt.registerLazySingleton<AuthRemoteDataSource>(
  () => AuthRemoteDataSourceImpl(apiClient: getIt()),
);

// Repositories
getIt.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: getIt(),
    localDataSource: getIt(),
    networkInfo: getIt(),
  ),
);

// Use cases
getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt()));

// BLoCs (factory - new instance each time)
getIt.registerFactory(() => AuthBloc(verifyOtpUseCase: getIt()));
```

---

## Benefits of This Architecture

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Clear separation makes changes easier
3. **Scalability**: Easy to add new features
4. **Flexibility**: Easy to change implementations
5. **Team Collaboration**: Different teams can work on different layers

---

## Adding a New Feature

1. **Create feature folder**: `lib/features/new_feature/`
2. **Domain Layer**: 
   - Define entities
   - Create repository interface
   - Write use cases
3. **Data Layer**:
   - Create models
   - Implement data sources
   - Implement repository
4. **Presentation Layer**:
   - Create BLoC (events, states, bloc)
   - Build pages
   - Create widgets
5. **Register in DI**: Add to `injector.dart`
6. **Write Tests**: Unit, BLoC, and widget tests

---

## Best Practices

✅ **DO**:
- Keep domain layer pure (no Flutter imports)
- Use `Either<Failure, T>` for operations that can fail
- Write single-responsibility use cases
- Test each layer independently
- Use dependency injection

❌ **DON'T**:
- Put business logic in widgets
- Import Flutter in domain layer
- Skip error handling
- Create god classes
- Tightly couple layers

---

## References

- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture by Reso Coder](https://resocoder.com/flutter-clean-architecture-tdd/)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
