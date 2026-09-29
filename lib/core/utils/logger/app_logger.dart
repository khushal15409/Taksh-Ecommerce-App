import 'package:flutter/cupertino.dart';

abstract class AppLogger {
  void init({required bool enabled});

  void debug(String message);

  void info(String message);

  void warn(String message);

  void error(String message, [Object? err, StackTrace? st]);

  /// Log debug message with context data
  void debugWithContext(String message, Map<String, dynamic> context);

  /// Log info message with context data
  void infoWithContext(String message, Map<String, dynamic> context);

  /// Log warning message with context data
  void warnWithContext(String message, Map<String, dynamic> context);

  /// Log error message with context data
  void errorWithContext(
    String message,
    Map<String, dynamic> context, [
    Object? err,
    StackTrace? st,
  ]);

  /// Create a child logger with persistent context that will be included in all logs
  AppLogger withContext(Map<String, dynamic> context);

  Widget debugScreen();
}
