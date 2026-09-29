# Taksh E-Commerce - Food Delivery Application

A production-ready Flutter food delivery application built with **Clean Architecture** principles, designed for enterprise-level scalability, maintainability, and testability.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.0%2B-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.0%2B-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🚀 Features

- ✅ **Clean Architecture** with clear separation of concerns
- ✅ **State Management** using BLoC pattern
- ✅ **Dependency Injection** with GetIt
- ✅ **Type-safe Routing** with go_router
- ✅ **Network Layer** with Dio and comprehensive error handling
- ✅ **Local Storage** with SharedPreferences and Hive
- ✅ **Functional Programming** with Dartz for error handling
- ✅ **OTP-based Authentication** system
- ✅ **Environment-specific configurations** (dev, staging, production)
- ✅ **Comprehensive logging** with structured logs
- ✅ **Form validation** with custom validators
- ✅ **Material 3 Design** with theme support

## 📋 Requirements

- Flutter SDK: >=3.0.0 <4.0.0
- Dart SDK: >=3.0.0 <4.0.0
- Android Studio / VS Code with Flutter extensions
- An Android device/emulator or iOS device/simulator

## 🛠️ Tech Stack

### Core Technologies
- **Flutter 3.x** - UI framework
- **Dart 3.x** - Programming language
- **Material 3** - Design system

### State Management & Architecture
- **flutter_bloc** - State management
- **equatable** - Value equality
- **get_it** - Dependency injection
- **dartz** - Functional programming

### Networking & Storage
- **dio** - HTTP client
- **connectivity_plus** - Network connectivity
- **shared_preferences** - Simple key-value storage
- **hive** - NoSQL database

### Routing & Navigation
- **go_router** - Declarative routing

### UI & UX
- **cached_network_image** - Image caching

### Code Generation
- **freezed** - Code generation for models
- **json_serializable** - JSON serialization
- **build_runner** - Code generation runner

### Development Tools
- **logger** - Structured logging
- **flutter_lints** - Linting rules

### Testing
- **mockito** - Mocking framework
- **bloc_test** - BLoC testing utilities
- **flutter_test** - Flutter testing framework

## 📁 Project Structure

```
lib/
├── core/                      # Core utilities and infrastructure
│   ├── constants/             # App-wide constants
│   ├── error/                 # Error handling (failures & exceptions)
│   ├── network/               # Network layer (API client, connectivity)
│   ├── utils/                 # Utilities (validators, logger, typedefs)
│   ├── routing/               # Navigation configuration
│   ├── di/                    # Dependency injection setup
│   └── usecase/               # Base use case interface
│
├── features/                  # Feature modules (Clean Architecture)
│   └── auth/                  # Authentication feature
│       ├── domain/            # Business logic layer
│       │   ├── entities/      # Domain entities
│       │   ├── repositories/  # Repository interfaces
│       │   └── usecases/      # Business use cases
│       ├── data/              # Data layer
│       │   ├── models/        # Data models with JSON serialization
│       │   ├── datasources/   # Remote & Local data sources
│       │   └── repositories/  # Repository implementations
│       └── presentation/      # UI layer
│           ├── bloc/          # BLoC state management
│           ├── pages/         # Screen widgets
│           └── widgets/       # Reusable UI components
│
├── app.dart                   # Main app configuration
├── main.dart                  # Production entry point
├── main_dev.dart              # Development entry point
└── main_staging.dart          # Staging entry point
```

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/taksh_e_commerce.git
cd taksh_e_commerce
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate code (for JSON serialization and other code generation)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. Run the app

**Development mode:**
```bash
flutter run -t lib/main_dev.dart
```

**Staging mode:**
```bash
flutter run -t lib/main_staging.dart
```

**Production mode:**
```bash
flutter run -t lib/main.dart
```

### 5. Build for release

**Android:**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📚 Documentation

Comprehensive documentation is available in the `docs/` folder:

- [Architecture Guide](docs/ARCHITECTURE.md) - Clean Architecture explanation
- [Setup Guide](docs/SETUP.md) - Development environment setup
- [Routing Guide](docs/ROUTING.md) - Navigation implementation
- [Quick Reference](docs/QUICK_REFERENCE.md) - Common code patterns
- [Logger Guide](docs/LOGGER_GUIDE.md) - Logging best practices
- [Testing Guide](docs/TESTING.md) - Testing guidelines
- [CI/CD Setup](docs/CI_CD_SETUP.md) - Continuous integration

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with three distinct layers:

### 1. Domain Layer (Business Logic)
- Pure Dart, no Flutter dependencies
- Contains entities, repository interfaces, and use cases
- Defines business rules and application logic

### 2. Data Layer (Implementation)
- Implements repository interfaces from domain
- Handles data sources (remote API, local storage)
- Manages data transformation (models to entities)

### 3. Presentation Layer (UI)
- Flutter widgets and BLoC state management
- Displays data and handles user interactions
- Depends on domain layer only

**Dependency Rule**: Domain ← Data ← Presentation

## 🔐 Authentication Flow

The app uses OTP-based authentication:

1. User enters phone number
2. System sends OTP via API
3. User enters OTP
4. System verifies OTP and creates session
5. User is authenticated and redirected to home

## 🧪 Testing

Run tests with:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🎨 Code Style

This project follows the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and uses `flutter_lints` for code analysis.

Run analysis:
```bash
flutter analyze
```

Format code:
```bash
dart format .
```

## 🔧 Environment Configuration

The app supports three environments:

- **Development**: `main_dev.dart` - Uses dev API, verbose logging
- **Staging**: `main_staging.dart` - Uses staging API, moderate logging
- **Production**: `main.dart` - Uses production API, minimal logging

Each environment has its own:
- Base URL
- Log level
- Debug settings

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Contact

For questions or support, please contact: [your-email@example.com](mailto:your-email@example.com)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All contributors who helped build this project
- Open source community for the excellent packages

---

Made with ❤️ using Flutter

