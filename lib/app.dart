import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/routing/app_router.dart';
import 'package:taksh_e_commerce/core/theme/theme.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_event.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_state.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Environment configuration
enum Environment {
  development,
  staging,
  production,
  mock,
}

/// App configuration based on environment
class AppConfig {
  final Environment environment;
  final String baseUrl;
  final Level logLevel;
  final bool enableDebugLogs;
  final bool useMockData;

  const AppConfig({
    required this.environment,
    required this.baseUrl,
    required this.logLevel,
    required this.enableDebugLogs,
    this.useMockData = false,
  });

  /// Development configuration
  factory AppConfig.development() {
    return const AppConfig(
      environment: Environment.development,
      baseUrl: ApiConstants.devBaseUrl,
      logLevel: Level.debug,
      enableDebugLogs: true,
      useMockData: false,
    );
  }

  /// Staging configuration
  factory AppConfig.staging() {
    return const AppConfig(
      environment: Environment.staging,
      baseUrl: ApiConstants.stagingBaseUrl,
      logLevel: Level.info,
      enableDebugLogs: true,
      useMockData: false,
    );
  }

  /// Production configuration
  factory AppConfig.production() {
    return const AppConfig(
      environment: Environment.production,
      baseUrl: ApiConstants.prodBaseUrl,
      logLevel: Level.warning,
      enableDebugLogs: false,
      useMockData: false,
    );
  }

  /// Mock configuration (no API calls)
  factory AppConfig.mock() {
    return const AppConfig(
      environment: Environment.mock,
      baseUrl: ApiConstants.prodBaseUrl,
      logLevel: Level.debug,
      enableDebugLogs: true,
      useMockData: true,
    );
  }

  String get environmentName {
    switch (environment) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
      case Environment.mock:
        return 'Mock (No API)';
    }
  }
}

/// Main app widget
class TakshECommerceApp extends material.StatelessWidget {
  final AppConfig config;

  const TakshECommerceApp({
    super.key,
    required this.config,
  });

  @override
  material.Widget build(material.BuildContext context) {
    final log =
        loggerWithContext({'feature': 'app', 'widget': 'TakshECommerceApp'});

    final router = getIt<AppRouter>();
    init(enabled: config.enableDebugLogs);

    log.infoWithContext(
      'Building app widget',
      {
        'environment': config.environmentName,
        'base_url': config.baseUrl,
        'debug_logs_enabled': config.enableDebugLogs,
        'log_level': config.logLevel.toString(),
      },
    );

    return MultiBlocProvider(
      providers: [
        // SplashCubit - singleton, stays active for entire app lifecycle
        BlocProvider<SplashCubit>(
          create: (context) => getIt<SplashCubit>(),
        ),
        // AuthBloc - triggers auth check on app start
        BlocProvider<AuthBloc>(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        BlocProvider<AddressBloc>(
          create: (context) => getIt<AddressBloc>(),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.read<AddressBloc>().add(const ResetAddressesEvent());
          }
        },
        child: BlocBuilder<SplashCubit, SplashState>(
          buildWhen: (previous, current) => current is SplashCompleted,
          builder: (context, state) {
            material.Locale locale = const material.Locale('en');
            material.ThemeMode themeMode = material.ThemeMode.light;

            if (state is SplashCompleted) {
              locale = state.locale;
              themeMode = state.themeMode;
            }

            return material.MaterialApp.router(
              title: 'Taksh E-Commerce',
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                material.Locale('en'),
                material.Locale('hi'),
              ],
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: themeMode,
              routerConfig: router.router,
            );
          },
        ),
      ),
    );
  }
}

/// Initialize and run the app
Future<void> runApp(AppConfig config) async {
  final appStartTime = DateTime.now();

  // Ensure Flutter bindings are initialized
  material.WidgetsFlutterBinding.ensureInitialized();

  final log = loggerWithContext({
    'feature': 'app',
    'action': 'startup',
    'environment': config.environmentName,
  });

  // Log environment
  log.infoWithContext(
    'App initialization started',
    {
      'environment': config.environmentName,
      'base_url': config.baseUrl,
      'log_level': config.logLevel.toString(),
      'debug_logs': config.enableDebugLogs,
    },
  );

  try {
    // Load environment variables
    log.debugWithContext(
        'Loading environment variables', {'action': 'env_init'});
    try {
      await dotenv.load(fileName: '.env');
      log.info('Environment variables loaded successfully');
    } catch (e) {
      log.infoWithContext('Failed to load .env file, continuing without it',
          {'error': e.toString()});
    }

    // Initialize Hive
    log.debugWithContext('Initializing Hive', {'action': 'hive_init'});
    final hiveStartTime = DateTime.now();

    await Hive.initFlutter();

    log.infoWithContext(
      'Hive initialized successfully',
      {
        'duration_ms': DateTime.now().difference(hiveStartTime).inMilliseconds,
      },
    );

    // Initialize dependencies
    log.debugWithContext('Initializing dependencies', {'action': 'di_init'});
    final diStartTime = DateTime.now();

    await initializeDependencies(
      baseUrl: config.baseUrl,
      useMockData: config.useMockData,
    );

    log.infoWithContext(
      'Dependencies initialized successfully',
      {
        'duration_ms': DateTime.now().difference(diStartTime).inMilliseconds,
      },
    );

    // Log startup metrics
    final totalStartupTime =
        DateTime.now().difference(appStartTime).inMilliseconds;
    log.infoWithContext(
      'App startup completed',
      {
        'total_startup_ms': totalStartupTime,
        'flutter_version':
            material.WidgetsBinding.instance.runtimeType.toString(),
      },
    );

    // Run the app
    material.runApp(
      TakshECommerceApp(config: config),
    );
  } catch (e, stackTrace) {
    log.errorWithContext(
      'App initialization failed',
      {
        'error_type': e.runtimeType.toString(),
        'startup_ms': DateTime.now().difference(appStartTime).inMilliseconds,
      },
      e,
      stackTrace,
    );
    rethrow;
  }
}
