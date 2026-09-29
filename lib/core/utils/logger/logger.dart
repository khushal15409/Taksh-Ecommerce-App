import 'package:flutter/cupertino.dart';
import 'package:taksh_e_commerce/core/utils/logger/app_logger.dart';
import 'package:taksh_e_commerce/core/utils/logger/app_logger_impl.dart';

/// Gets the logger instance.
AppLogger get logger => AppLoggerImpl.instance;

/// Initializes the logging system.
///
/// [enabled] determines whether logging is active.
void init({required bool enabled}) => logger.init(enabled: enabled);

/// Logs a debug message.
///
/// [message] the debug message to log.
void logD(String message) => logger.debug(message);

/// Logs an informational message.
///
/// [message] the info message to log.
void logI(String message) => logger.info(message);

/// Logs a warning message.
///
/// [message] the warning message to log.
void logW(String message) => logger.warn(message);

/// Logs an error message with optional error object and stack trace.
///
/// [message] the error message to log.
/// [err] optional error object.
/// [st] optional stack trace.
void logError(String message, [Object? err, StackTrace? st]) =>
    logger.error(message, err, st);

/// Logs a debug message with context data.
///
/// [message] the debug message to log.
/// [context] contextual data to include with the log.
void logDWithContext(String message, Map<String, dynamic> context) =>
    logger.debugWithContext(message, context);

/// Logs an informational message with context data.
///
/// [message] the info message to log.
/// [context] contextual data to include with the log.
void logIWithContext(String message, Map<String, dynamic> context) =>
    logger.infoWithContext(message, context);

/// Logs a warning message with context data.
///
/// [message] the warning message to log.
/// [context] contextual data to include with the log.
void logWWithContext(String message, Map<String, dynamic> context) =>
    logger.warnWithContext(message, context);

/// Logs an error message with context data and optional error object and stack trace.
///
/// [message] the error message to log.
/// [context] contextual data to include with the log.
/// [err] optional error object.
/// [st] optional stack trace.
void logErrorWithContext(
  String message,
  Map<String, dynamic> context, [
  Object? err,
  StackTrace? st,
]) =>
    logger.errorWithContext(message, context, err, st);

/// Creates a logger with persistent context that will be included in all logs.
///
/// [context] the persistent context data to attach to this logger.
/// Returns a new AppLogger instance with the specified context.
///
/// Example:
/// ```dart
/// final authLogger = loggerWithContext({'feature': 'authentication'});
/// authLogger.info('User logged in'); // Includes feature=authentication
/// ```
AppLogger loggerWithContext(Map<String, dynamic> context) =>
    logger.withContext(context);

/// Returns a debug screen widget for viewing logs.
Widget debugScreen() => logger.debugScreen();
