# Splash Screen Architecture

## Overview

The splash screen implementation uses a robust architecture with **SplashCubit** that stays active throughout the app's lifecycle, managing initialization tasks, permissions, and data prefetching.

## Architecture Components

### 1. **SplashCubit** (Singleton)
Located: `lib/features/splash/presentation/cubit/splash_cubit.dart`

**Purpose:** App-wide state manager for:
- Location permissions
- Current location tracking
- Home data prefetch status
- Initialization coordination

**Key Features:**
- ✅ Singleton - registered once in DI container
- ✅ Stays active for entire app lifecycle
- ✅ Accessible from anywhere: `context.read<SplashCubit>()`
- ✅ Handles minimum splash duration (1.5s)
- ✅ Coordinates async initialization tasks in parallel

### 2. **SplashState** 
Located: `lib/features/splash/presentation/cubit/splash_state.dart`

**States:**
- `SplashInitial` - Not started
- `SplashLoading` - Initializing (with optional message)
- `SplashCompleted` - All tasks done
- `SplashError` - Initialization failed
- `LocationPermissionGranted/Denied` - Runtime permission updates

### 3. **SplashPage**
Located: `lib/features/splash/presentation/pages/splash_page.dart`

**Responsibilities:**
- Coordinate between `SplashCubit` and `AuthBloc`
- Navigate only when BOTH are ready
- Show loading status dynamically
- Prefetch home data for authenticated users

## Flow Diagram

```
App Start
    ↓
[SplashCubit.initialize()] ← Parallel execution
    ├─ Check location permission
    ├─ Get current location (if permitted)
    └─ Ensure minimum duration (1.5s)
    ↓
[SplashCompleted]
    ↓
Wait for AuthBloc
    ↓
[Authenticated] → prefetchHomeData() → Navigate to Home
    ↓
[Unauthenticated] → Navigate to Login
```

## Navigation Logic

```dart
Navigate when ALL true:
1. _splashCompleted = true (SplashCubit finished)
2. _authResolved = true (AuthBloc returned state)
3. _authState is Authenticated/Unauthenticated

If Authenticated:
  → Prefetch home APIs
  → Then navigate to home
  
If Unauthenticated:
  → Navigate to login immediately
```

## Dependency Injection

```dart
// Registered in lib/core/di/injector.dart

getIt.registerLazySingleton<SplashCubit>(() => SplashCubit());
```

## App-wide Provision

```dart
// Provided at root level in lib/app.dart

MultiBlocProvider(
  providers: [
    BlocProvider<SplashCubit>(
      create: (context) => getIt<SplashCubit>(),  // Singleton
    ),
    BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>()..add(AuthCheckRequested()),
    ),
  ],
  child: MaterialApp.router(...),
)
```

## Usage Examples

### 1. Check Location Permission Status
```dart
final splashCubit = context.read<SplashCubit>();
if (splashCubit.hasLocationPermission) {
  // Use location features
}
```

### 2. Request Permission at Runtime
```dart
final granted = await context.read<SplashCubit>().requestLocationPermission();
```

### 3. Get Current Location
```dart
final location = context.read<SplashCubit>().currentLocation;
print('Lat: ${location?.latitude}, Lng: ${location?.longitude}');
```

### 4. Refresh Location
```dart
final newLocation = await context.read<SplashCubit>().refreshLocation();
```

### 5. Check Prefetch Status
```dart
if (context.read<SplashCubit>().homeDataPrefetched) {
  // Data already loaded - show immediately
}
```

### 6. Listen to Permission Changes
```dart
BlocListener<SplashCubit, SplashState>(
  listener: (context, state) {
    if (state is LocationPermissionGranted) {
      // Permission granted
    }
  },
  child: YourWidget(),
)
```

## Adding Home API Prefetch

To add actual API calls, update `SplashCubit.prefetchHomeData()`:

```dart
Future<void> prefetchHomeData() async {
  try {
    emit(const SplashLoading(message: 'Loading data...'));

    // Add your repository calls here
    await Future.wait([
      _homeRepository.fetchBanners(),
      _homeRepository.fetchCategories(),
      _homeRepository.fetchFeaturedProducts(),
    ]);

    _homeDataPrefetched = true;
    
    emit(SplashCompleted(
      hasLocationPermission: _hasLocationPermission,
      homeDataPrefetched: _homeDataPrefetched,
    ));
  } catch (e) {
    // Handle error
  }
}
```

## Android Permissions Setup

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## iOS Permissions Setup

Add to `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby stores</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to provide delivery services</string>
```

## Benefits

✅ **Separation of Concerns** - Splash logic separated from auth logic
✅ **Reusable** - SplashCubit accessible throughout app
✅ **Testable** - Easy to mock and test
✅ **Smooth UX** - Guaranteed minimum splash duration
✅ **Optimized** - Parallel execution of initialization tasks
✅ **Instant Feel** - Prefetched data for immediate home screen display
✅ **Permission Management** - Runtime permission handling built-in
