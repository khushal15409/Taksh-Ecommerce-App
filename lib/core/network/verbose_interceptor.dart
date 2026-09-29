import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';

/// Verbose logging interceptor for detailed network debugging
class VerboseInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestInfo = StringBuffer();
    requestInfo.writeln(
        '╔════════════════════════════════════════════════════════════');
    requestInfo.writeln('║ 📤 REQUEST');
    requestInfo.writeln(
        '╠════════════════════════════════════════════════════════════');
    requestInfo.writeln('║ Method: ${options.method}');
    requestInfo.writeln('║ URL: ${options.uri}');

    // Headers
    if (options.headers.isNotEmpty) {
      requestInfo.writeln('║ Headers:');
      options.headers.forEach((key, value) {
        // Mask sensitive headers
        if (key.toLowerCase() == 'authorization') {
          requestInfo.writeln('║   $key: ${_maskToken(value.toString())}');
        } else {
          requestInfo.writeln('║   $key: $value');
        }
      });
    }

    // Query Parameters
    if (options.queryParameters.isNotEmpty) {
      requestInfo.writeln('║ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        requestInfo.writeln('║   $key: $value');
      });
    }

    // Request Body
    if (options.data != null) {
      requestInfo.writeln('║ Body:');
      requestInfo.writeln('║   ${_formatData(options.data)}');
    }

    requestInfo.writeln(
        '╚════════════════════════════════════════════════════════════');

    final log = loggerWithContext(
        {'feature': 'network', 'class': 'VerboseInterceptor'});
    log.debug(requestInfo.toString());

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final responseInfo = StringBuffer();
    responseInfo.writeln(
        '╔════════════════════════════════════════════════════════════');
    responseInfo.writeln('║ 📥 RESPONSE');
    responseInfo.writeln(
        '╠════════════════════════════════════════════════════════════');
    responseInfo.writeln('║ URL: ${response.requestOptions.uri}');
    responseInfo.writeln('║ Status Code: ${response.statusCode}');
    responseInfo.writeln('║ Status Message: ${response.statusMessage}');

    // Show redirect information
    if (response.isRedirect) {
      responseInfo.writeln('║ 🔄 Redirect Detected!');
      if (response.headers['location'] != null) {
        responseInfo
            .writeln('║ Redirect Location: ${response.headers['location']}');
      }
    }

    // Response Headers
    if (response.headers.map.isNotEmpty) {
      responseInfo.writeln('║ Headers:');
      response.headers.map.forEach((key, value) {
        responseInfo.writeln('║   $key: ${value.join(', ')}');
      });
    }

    // Response Body
    if (response.data != null) {
      responseInfo.writeln('║ Response Data:');
      responseInfo.writeln('║   ${_formatData(response.data)}');
    }

    responseInfo.writeln(
        '╚════════════════════════════════════════════════════════════');

    // log.debug(responseInfo.toString());

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorInfo = StringBuffer();
    errorInfo.writeln(
        '╔════════════════════════════════════════════════════════════');
    errorInfo.writeln('║ ❌ ERROR');
    errorInfo.writeln(
        '╠════════════════════════════════════════════════════════════');
    errorInfo.writeln('║ URL: ${err.requestOptions.uri}');
    errorInfo.writeln('║ Method: ${err.requestOptions.method}');
    errorInfo.writeln('║ Error Type: ${err.type}');
    errorInfo.writeln('║ Error Message: ${err.message}');

    if (err.response != null) {
      errorInfo.writeln('║ Status Code: ${err.response?.statusCode}');
      errorInfo.writeln('║ Status Message: ${err.response?.statusMessage}');

      if (err.response?.data != null) {
        errorInfo.writeln('║ Error Data:');
        errorInfo.writeln('║   ${_formatData(err.response?.data)}');
      }
    }

    // Stack trace
    errorInfo.writeln('║ Stack Trace:');
    final stackLines = err.stackTrace.toString().split('\n').take(5);
    for (var line in stackLines) {
      errorInfo.writeln('║   $line');
    }

    errorInfo.writeln(
        '╚════════════════════════════════════════════════════════════');

    // log.error('Network Error', err, err.stackTrace);
    // log.debug(errorInfo.toString());

    super.onError(err, handler);
  }

  /// Mask sensitive token information
  String _maskToken(String token) {
    if (token.length <= 10) return '***';
    return '${token.substring(0, 10)}...${token.substring(token.length - 5)}';
  }

  /// Format data for readable output
  String _formatData(dynamic data) {
    try {
      if (data is Map || data is List) {
        // Pretty print JSON-like data
        return data.toString().replaceAll(', ', ',\n║     ');
      }
      return data.toString();
    } catch (e) {
      return 'Unable to format data: $e';
    }
  }
}
