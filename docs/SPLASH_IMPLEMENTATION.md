# Splash Screen & Authentication Implementation

## Overview
Implemented a splash screen with automatic navigation based on authentication state, managed through SharedPreferences.

## Files Created

### 1. Splash Page
**Location:** `lib/features/splash/presentation/pages/splash_page.dart`

- Displays app logo and name with a loading indicator
- Shows for 2 seconds before checking auth state
- Automatically navigates to home if logged in, otherwise to login page

### 2. Home Page
**Location:** `lib/features/home/presentation/pages/home_page.dart`

- Protected route - only accessible when authenticated
- Shows welcome message and logout button
- Logout clears auth state and redirects to login

### 3. Simple Login Page (For Testing)
**Location:** `lib/features/auth/presentation/pages/simple_login_page.dart`

- Simplified login for testing without backend/OTP
- Single button sets auth state and navigates to home
- Includes link to full OTP login flow

## Files Modified

### 1. App Router
**Location:** `lib/core/routing/app_router.dart`

- Added imports for new splash, home, and simple login pages
- Removed placeholder implementations
- Added route for simple login
- Updated redirect logic to include simple login as auth route

### 2. App Routes
**Location:** `lib/core/routing/app_routes.dart`

- Added `simpleLogin` route constant

## Authentication Flow

### First Launch (Not Logged In)
1. App starts → Splash Screen (2s)
2. Check SharedPreferences → `isLoggedIn = false`
3. Navigate to Simple Login Page
4. User clicks "Login (Demo)" button
5. Set `isLoggedIn = true` in SharedPreferences
6. Navigate to Home Page

### Subsequent Launch (Logged In)
1. App starts → Splash Screen (2s)
2. Check SharedPreferences → `isLoggedIn = true`
3. Navigate directly to Home Page

### Logout
1. User clicks logout button on Home Page
2. Clear `isLoggedIn` from SharedPreferences
3. Navigate to Login Page

## SharedPreferences Keys Used
- `StorageConstants.isLoggedIn`: Boolean flag for authentication state
- `StorageConstants.userName`: Stored username (optional)

## Testing Instructions

1. **First Run:**
   - Launch the app
   - You'll see the splash screen
   - After 2 seconds, you'll be at the Simple Login page
   - Click "Login (Demo)" to simulate authentication
   - You'll be navigated to the Home page

2. **Logout:**
   - On the Home page, click the logout icon/button
   - You'll be logged out and redirected to login

3. **Relaunch After Login:**
   - Close and reopen the app
   - The splash screen will detect you're logged in
   - You'll automatically go to the Home page

## Switching to Full OTP Login

To use the full OTP authentication flow instead of simple login:

**In `splash_page.dart`:**
```dart
// Change line 32 from:
context.go(AppRoutes.simpleLogin);

// To:
context.go(AppRoutes.login);
```

The full OTP login already properly manages auth state through the auth repository and will work seamlessly with this splash implementation.

## Architecture Notes

- Follows Clean Architecture principles
- Splash page is a feature module
- Auth state managed via SharedPreferences (as requested)
- Router uses auth guards to protect routes
- All navigation handled through GoRouter
