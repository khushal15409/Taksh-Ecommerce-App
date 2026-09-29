# AGENTS.md — Taksh E-Commerce

## Entry points

Four entry points via `flutter run -t lib/main_<env>.dart`:
| File | Mode | Notes |
|------|------|-------|
| `main.dart` | Production | |
| `main_dev.dart` | Development | |
| `main_staging.dart` | Staging | |
| `main_mock.dart` | Mock | No API calls; use any phone, OTP always `123456` |

VSCode launch configs in `.vscode/launch.json` mirror these four.

## Key commands

```bash
flutter pub get

# Codegen (after model changes)
dart run build_runner build --delete-conflicting-outputs

# Localization (after ARB changes)
flutter gen-l10n

# Lint
flutter analyze

# Test
flutter test
# Coverage
flutter test --coverage && genhtml coverage/lcov.info -o coverage/html
```

## Architecture

Feature-first **Clean Architecture** under `lib/features/<feature>/`:
- `domain/` — pure Dart, `Either<Failure, T>` via dartz (`ResultFuture<T>`/`ResultVoid` typedefs in `core/utils/typedef.dart`)
- `data/` — models (json_serializable, `.g.dart` gitignored), datasources, repository impls
- `presentation/` — BLoC (complex flows) or Cubit (simple CRUD)

Shared infra in `lib/core/` (network, DI, routing, theme, error types, websocket, utils).

## DI conventions (`lib/core/di/injector.dart`)

- **DataSources, Repositories, UseCases** → `registerLazySingleton`
- **BLoCs/Cubits** → `registerFactory` (new per widget), **except** `CartCubit`, `SplashCubit`, `WishlistCubit` → `registerLazySingleton`
- Complex features (address, orders, checkout, payment, quick_delivery, wallet, home_service) have their own `di/<feature>_di.dart`
- Mock/real switching uses `useMockData` flag

## Network

`ApiClient` wraps Dio at `lib/core/network/api_client.dart`:
- Auto-injects Bearer token from `SecureStore`
- 401 responses auto-clear the stored token
- Error mapping: DioException → typed AppException

All envs share the same base URL: `https://taksh-admin.takshallinone.in/api`

## Routing

`go_router` with `ShellRoute` for bottom nav tabs. Auth guard in `_redirect()`:
- Routes in `_authRequiredRoutes` → redirect to login with `redirectAfter` param
- Shell tabs (orders, profile, cart) handle guest via `GuestAuthWall` in-page (no redirect)
- Placeholder pages (Onboarding, Register, ForgotPassword, etc.) live in `app_router.dart`

## State management

- Always `result.fold((failure) => emit(ErrorState(...)), (data) => emit(SuccessState(...)))`
- Guard emissions with `isClosed` (Cubit) or `emit.isDone` (BLoC)
- BLoC events extend `Equatable`, one class per action

## Codegen & generated files

- `**/*.g.dart`, `**/*.freezed.dart`, `**/*.mocks.dart` — gitignored and excluded from analyzer
- Run `dart run build_runner build --delete-conflicting-outputs` after modifying models/freezed classes
- ARB files in `lib/l10n/` (`app_en.arb`, `app_hi.arb`), run `flutter gen-l10n` after changes

## Environment

- `.env` file for Razorpay keys (not committed, `.env.example` shows schema)
- `.fvm/versions/stable` — configured in `.vscode/settings.json`

## Imports & style

- Use package imports (`package:taksh_e_commerce/...`), not relative
- Linting inherits `flutter_lints` from `analysis_options.yaml`
- Theme tokens from `lib/core/theme/` — use `AppColors`, `AppSpacing`, `AppTypography`

## Tests

No test files exist yet. Dev deps include `mockito`, `bloc_test`. When adding tests:
- Run `flutter test` for all tests
- Coverage: `flutter test --coverage`

## CI

GitHub Actions workflow (`build-release-apk.yml`) — triggers on push/PR to `main`, `staging`, `master`. Flutter 3.38.5 stable. Builds release APK, renames with version/date, uploads artifact, creates GitHub release on main pushes.
