import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/utils/logger/app_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AppLoggerImpl implements AppLogger {
  AppLoggerImpl._({Map<String, dynamic>? persistentContext})
      : _persistentContext = persistentContext ?? {},
        _sessionId = DateTime.now().millisecondsSinceEpoch.toString(),
        _talker = TalkerFlutter.init(
          settings: TalkerSettings(),
          logger: TalkerLogger(
            settings: TalkerLoggerSettings(),
          ),
        );

  static final AppLoggerImpl _instance = AppLoggerImpl._();

  static AppLoggerImpl get instance => _instance;

  final Talker _talker;
  final Map<String, dynamic> _persistentContext;
  final String _sessionId;
  static int _logCounter = 0;

  @override
  void init({required bool enabled}) {
    _instance._talker.settings.enabled = enabled;
  }

  /// Helper to format message with context
  String _formatWithContext(
      String message, Map<String, dynamic>? additionalContext) {
    _logCounter++;
    final now = DateTime.now();
    final timestamp = now.toIso8601String();

    final allContext = <String, dynamic>{
      'session_id': _sessionId,
      'log_id': _logCounter,
      'timestamp': timestamp,
      ..._persistentContext,
      if (additionalContext != null) ...additionalContext,
    };

    // Format as two lines:
    // Line 1: message
    // Line 2: full-length separator + pretty-printed JSON context
    const encoder = JsonEncoder.withIndent('  ', _toEncodable);
    final jsonContext = encoder.convert(allContext);
    final separator = '-' * 110;
    
    return '$message\n$separator\n$jsonContext';
  }

  /// Convert non-encodable objects to strings for JSON serialization
  static Object? _toEncodable(dynamic object) {
    if (object == null) return null;
    // Handle common non-encodable types
    if (object is DateTime) return object.toIso8601String();
    if (object is Duration) return object.inMilliseconds;
    // Convert any other object to its string representation
    return object.toString();
  }

  @override
  void debug(String message) => _talker.debug(message);

  @override
  void info(String message) => _talker.info(message);

  @override
  void warn(String message) => _talker.warning(message);

  @override
  void error(String message, [Object? err, StackTrace? st]) =>
      _talker.error(message, err, st);

  @override
  void debugWithContext(String message, Map<String, dynamic> context) {
    _talker.debug(_formatWithContext(message, context));
  }

  @override
  void infoWithContext(String message, Map<String, dynamic> context) {
    _talker.info(_formatWithContext(message, context));
  }

  @override
  void warnWithContext(String message, Map<String, dynamic> context) {
    _talker.warning(_formatWithContext(message, context));
  }

  @override
  void errorWithContext(
    String message,
    Map<String, dynamic> context, [
    Object? err,
    StackTrace? st,
  ]) {
    _talker.error(_formatWithContext(message, context), err, st);
  }

  @override
  AppLogger withContext(Map<String, dynamic> context) {
    return _ContextualLogger(
      sessionId: _sessionId,
      talker: _talker,
      persistentContext: {..._persistentContext, ...context},
    );
  }

  @override
  Widget debugScreen() {
    if (kReleaseMode) return const SizedBox.shrink();
    return TalkerScreen(talker: _instance._talker);
  }
}

/// Private class for contextual loggers with persistent context
class _ContextualLogger implements AppLogger {
  _ContextualLogger({
    required Talker talker,
    required Map<String, dynamic> persistentContext,
    required String sessionId,
  })  : _talker = talker,
        _persistentContext = persistentContext,
        _sessionId = sessionId;

  final Talker _talker;
  final Map<String, dynamic> _persistentContext;
  final String _sessionId;

  String _formatWithContext(
      String message, Map<String, dynamic>? additionalContext) {
    AppLoggerImpl._logCounter++;
    final now = DateTime.now();
    final timestamp = now.toIso8601String();

    final allContext = <String, dynamic>{
      'session_id': _sessionId,
      'log_id': AppLoggerImpl._logCounter,
      'timestamp': timestamp,
      ..._persistentContext,
      if (additionalContext != null) ...additionalContext,
    };

    // Format as two lines:
    // Line 1: message
    // Line 2: full-length separator + pretty-printed JSON context
    const encoder = JsonEncoder.withIndent('  ', AppLoggerImpl._toEncodable);
    final jsonContext = encoder.convert(allContext);
    final separator = '-' * 109;
    
    return '$message\n$separator\n$jsonContext';
  }

  @override
  void init({required bool enabled}) {
    _talker.settings.enabled = enabled;
  }

  @override
  void debug(String message) =>
      _talker.debug(_formatWithContext(message, null));

  @override
  void info(String message) => _talker.info(_formatWithContext(message, null));

  @override
  void warn(String message) =>
      _talker.warning(_formatWithContext(message, null));

  @override
  void error(String message, [Object? err, StackTrace? st]) =>
      _talker.error(_formatWithContext(message, null), err, st);

  @override
  void debugWithContext(String message, Map<String, dynamic> context) {
    _talker.debug(_formatWithContext(message, context));
  }

  @override
  void infoWithContext(String message, Map<String, dynamic> context) {
    _talker.info(_formatWithContext(message, context));
  }

  @override
  void warnWithContext(String message, Map<String, dynamic> context) {
    _talker.warning(_formatWithContext(message, context));
  }

  @override
  void errorWithContext(
    String message,
    Map<String, dynamic> context, [
    Object? err,
    StackTrace? st,
  ]) {
    _talker.error(_formatWithContext(message, context), err, st);
  }

  @override
  AppLogger withContext(Map<String, dynamic> context) {
    return _ContextualLogger(
      talker: _talker,
      persistentContext: {..._persistentContext, ...context},
      sessionId: _sessionId,
    );
  }

  @override
  Widget debugScreen() {
    if (kReleaseMode) return const SizedBox.shrink();
    return TalkerScreen(talker: _talker);
  }
}
