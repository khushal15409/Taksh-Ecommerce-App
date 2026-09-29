# Location Permission Integration Guide

## Overview

Complete location permission handling has been integrated into the app with multiple UI patterns and touchpoints throughout the user journey.

## 🚀 What's Been Implemented

### 1. **Platform Setup** ✅

#### Android (`AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### iOS (`Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby stores and provide accurate delivery services</string>
```

### 2. **Core Components**

#### **SplashCubit** (Already exists)
- Automatically checks location permission during splash
- Requests permission if not granted
- Stores permission status globally
- Provides methods to refresh location anytime

```dart
// Access from anywhere in the app
context.read<SplashCubit>().hasLocationPermission
context.read<SplashCubit>().currentLocation
await context.read<SplashCubit>().requestLocationPermission()
```

#### **LocationPermissionHandler** ✅ NEW
Location: `lib/features/splash/presentation/widgets/location_permission_handler.dart`

**Static methods for permission handling:**
- `requestPermissionWithUI()` - Complete permission flow with dialogs
- `showPermissionRationale()` - Explain why you need permission
- `showPermissionDeniedDialog()` - Handle denial gracefully
- `showAppSettingsDialog()` - Guide user to settings if permanently denied
- `showLocationStatus()` - Show snackbar with status

#### **LocationPermissionPrompt** ✅ NEW
Location: `lib/features/splash/presentation/widgets/location_permission_prompt.dart`

**UI Components:**
- `LocationPermissionPrompt` - Card-style prompt for home page
- `LocationPermissionBanner` - Compact top banner
- `LocationPermissionFAB` - Floating action button

#### **LocationPermissionBottomSheet** ✅ NEW
Location: `lib/features/splash/presentation/widgets/location_permission_handler.dart`

Beautiful bottom sheet with:
- Clear benefits list
- Icon and branding
- Allow/Skip buttons

### 3. **Integration Examples** ✅
Location: `lib/features/splash/presentation/widgets/location_permission_integration_examples.dart`

8 comprehensive examples showing:
1. Home page with prompt card
2. Top banner approach
3. Feature-gated permission request
4. Floating action button
5. Onboarding screen
6. Delivery address with location
7. Global permission listener
8. Settings page toggle

## 📱 User Experience Flow

### Splash Screen
```
App Launch
    ↓
Check Location Permission
    ↓
├─ Granted? → Get current location → Continue
└─ Denied? → Request permission → Continue anyway
```

**Key Point:** Permission denial doesn't block the app. User can enable later.

### Post-Splash Options

#### **Option A: Home Page Prompt (Recommended)**
Show attractive card on home page if permission not granted:

```dart
if (!context.read<SplashCubit>().hasLocationPermission)
  LocationPermissionPrompt(
    onPermissionGranted: () {
      // Refresh data, show nearby stores
    },
  ),
```

#### **Option B: Top Banner**
Persistent but non-intrusive banner:

```dart
if (!hasPermission) const LocationPermissionBanner(),
```

#### **Option C: Feature-Gated**
Request only when user needs location feature:

```dart
onTap: () async {
  if (!hasPermission) {
    await LocationPermissionBottomSheet.show(context);
  }
  // Proceed with location feature
}
```

## 🛠️ How to Use

### 1. Check Permission Status
```dart
final splashCubit = context.read<SplashCubit>();
if (splashCubit.hasLocationPermission) {
  // Has permission
}
```

### 2. Request Permission with UI
```dart
final granted = await LocationPermissionHandler.requestPermissionWithUI(context);
if (granted) {
  // Permission granted - proceed
}
```

### 3. Get Current Location
```dart
final location = context.read<SplashCubit>().currentLocation;
if (location != null) {
  print('Lat: ${location.latitude}, Lng: ${location.longitude}');
}
```

### 4. Refresh Location
```dart
final newLocation = await context.read<SplashCubit>().refreshLocation();
```

### 5. Show Permission Bottom Sheet
```dart
final granted = await LocationPermissionBottomSheet.show(context);
```

### 6. Listen to Permission Changes
```dart
BlocListener<SplashCubit, SplashState>(
  listener: (context, state) {
    if (state is LocationPermissionGranted) {
      // Update UI, refresh data
    }
  },
  child: YourWidget(),
)
```

## 🎨 UI Patterns Summary

| Pattern | When to Use | Intrusiveness |
|---------|-------------|---------------|
| **Bottom Sheet** | First time, onboarding | Medium |
| **Card Prompt** | Home page, after splash | Medium |
| **Top Banner** | Persistent reminder | Low |
| **FAB** | Easy access, non-blocking | Low |
| **Dialog** | Feature blocked | High |
| **Settings** | User-initiated | None |

## 📋 Recommended Implementation

### Step 1: Add to Home Page (After Splash)

```dart
// lib/features/home/presentation/pages/home_page.dart
Column(
  children: [
    // Show prompt only if permission not granted
    BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        if (!context.read<SplashCubit>().hasLocationPermission) {
          return LocationPermissionPrompt(
            onPermissionGranted: () {
              // Refresh nearby stores
              context.read<HomeBloc>().add(RefreshNearbyStores());
            },
            onSkip: () {
              // User skipped - maybe don't show again for a while
            },
          );
        }
        return const SizedBox.shrink();
      },
    ),
    
    // Rest of home page
    Expanded(child: YourHomeContent()),
  ],
)
```

### Step 2: Add to Feature Pages

For location-dependent features (store locator, delivery address):

```dart
ElevatedButton(
  onPressed: () async {
    final hasPermission = context.read<SplashCubit>().hasLocationPermission;
    
    if (!hasPermission) {
      final granted = await LocationPermissionHandler.requestPermissionWithUI(context);
      if (!granted) return;
    }
    
    // Proceed with location feature
    final location = await context.read<SplashCubit>().refreshLocation();
    // Use location...
  },
  child: const Text('Use My Location'),
)
```

### Step 3: Add to Settings

```dart
// lib/features/settings/presentation/pages/settings_page.dart
SwitchListTile(
  title: const Text('Location Services'),
  value: context.read<SplashCubit>().hasLocationPermission,
  onChanged: (value) async {
    if (value) {
      await LocationPermissionHandler.requestPermissionWithUI(context);
    } else {
      // Show info about disabling in system settings
    }
  },
)
```

## ⚠️ Important Notes

### Permission Handling Philosophy
1. **Never block the app** - User should be able to use app without location
2. **Request with context** - Explain WHY you need permission
3. **Handle denial gracefully** - Provide alternatives
4. **Don't repeatedly ask** - If denied, wait for user to re-enable

### Testing Scenarios
- ✅ Permission granted on first request
- ✅ Permission denied on first request
- ✅ Permission permanently denied
- ✅ Location services disabled on device
- ✅ App already has permission (returning user)
- ✅ Permission revoked while app is running

### Edge Cases Handled
- Location services disabled on device → Show enable dialog
- Permission permanently denied → Direct to app settings
- Permission denied once → Show rationale, allow retry
- No internet → Location still works (GPS-based)

## 🔗 File References

**Core Files:**
- [splash_cubit.dart](d:\Frontend Projects\taksh_e_commerce\lib\features\splash\presentation\cubit\splash_cubit.dart)
- [location_permission_handler.dart](d:\Frontend Projects\taksh_e_commerce\lib\features\splash\presentation\widgets\location_permission_handler.dart)
- [location_permission_prompt.dart](d:\Frontend Projects\taksh_e_commerce\lib\features\splash\presentation\widgets\location_permission_prompt.dart)

**Examples:**
- [location_permission_integration_examples.dart](d:\Frontend Projects\taksh_e_commerce\lib\features\splash\presentation\widgets\location_permission_integration_examples.dart)

**Platform Setup:**
- [AndroidManifest.xml](d:\Frontend Projects\taksh_e_commerce\android\app\src\main\AndroidManifest.xml)
- [Info.plist](d:\Frontend Projects\taksh_e_commerce\ios\Runner\Info.plist)

## ✅ Ready to Use

Everything is set up and ready to use! The location permission system:
- ✅ Checks permission during splash automatically
- ✅ Provides multiple UI patterns for requesting permission
- ✅ Handles all edge cases and denial scenarios
- ✅ Works across Android and iOS
- ✅ Accessible from anywhere in the app
- ✅ Non-blocking and user-friendly

Choose the UI pattern that fits your app's UX and integrate!
