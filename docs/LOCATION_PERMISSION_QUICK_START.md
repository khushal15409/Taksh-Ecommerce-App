# Location Permission Integration - Quick Start

## ✅ What's Configured

### 1. Platform Permissions
- ✅ Android: `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`
- ✅ iOS: Location usage descriptions added

### 2. Core Components Created
- ✅ `LocationPermissionHandler` - Static methods for permission handling
- ✅ `LocationPermissionPrompt` - Card-style UI prompt
- ✅ `LocationPermissionBanner` - Compact top banner
- ✅ `LocationPermissionBottomSheet` - Beautiful bottom sheet
- ✅ `LocationPermissionFAB` - Floating action button

### 3. SplashCubit Integration
- ✅ Automatically checks permission on app start
- ✅ Stores permission status globally
- ✅ Tracks current location
- ✅ Provides methods to request/refresh

## 🚀 Quick Integration (3 Steps)

### Step 1: Add to Home Page (Recommended)

```dart
// In your home page widget
Column(
  children: [
    // Show prompt if permission not granted
    BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        if (!context.read<SplashCubit>().hasLocationPermission) {
          return LocationPermissionPrompt(
            onPermissionGranted: () {
              // Permission granted - refresh data
            },
            onSkip: () {
              // User skipped
            },
          );
        }
        return const SizedBox.shrink();
      },
    ),
    
    // Your home content
    Expanded(child: YourHomeContent()),
  ],
)
```

### Step 2: Add to Feature Pages

```dart
// When user needs location feature
ElevatedButton(
  onPressed: () async {
    final hasPermission = context.read<SplashCubit>().hasLocationPermission;
    
    if (!hasPermission) {
      final granted = await LocationPermissionHandler.requestPermissionWithUI(context);
      if (!granted) return;
    }
    
    // Use location
    final location = await context.read<SplashCubit>().refreshLocation();
  },
  child: const Text('Use My Location'),
)
```

### Step 3: Add Import Statements

```dart
import 'package:taksh_e_commerce/features/splash/presentation/widgets/location_permission_handler.dart';
import 'package:taksh_e_commerce/features/splash/presentation/widgets/location_permission_prompt.dart';
```

## 📖 Full Documentation

See [LOCATION_PERMISSION_INTEGRATION.md](./LOCATION_PERMISSION_INTEGRATION.md) for:
- Complete examples
- All UI patterns
- Edge case handling
- Best practices

## 🎯 Key Features

- ✅ Non-blocking (app works without permission)
- ✅ Multiple UI patterns (choose what fits your UX)
- ✅ Handles all edge cases (denied, permanently denied, service disabled)
- ✅ App-wide access to location data
- ✅ User-friendly dialogs and prompts
- ✅ Works on Android & iOS

## 💡 Quick Access

```dart
// Check permission status
context.read<SplashCubit>().hasLocationPermission

// Get current location
context.read<SplashCubit>().currentLocation

// Request permission with UI
await LocationPermissionHandler.requestPermissionWithUI(context)

// Show bottom sheet
await LocationPermissionBottomSheet.show(context)

// Refresh location
await context.read<SplashCubit>().refreshLocation()
```

## 🎨 Choose Your UI Pattern

| UI Component | File | When to Use |
|--------------|------|-------------|
| Card Prompt | `location_permission_prompt.dart` | Home page after splash |
| Top Banner | `location_permission_prompt.dart` | Persistent reminder |
| Bottom Sheet | `location_permission_handler.dart` | Onboarding, first time |
| FAB | `location_permission_prompt.dart` | Easy access |
| Dialog | `location_permission_handler.dart` | Feature blocked |

Ready to use! 🎉
