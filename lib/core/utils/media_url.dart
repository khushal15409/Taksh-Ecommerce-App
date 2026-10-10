import 'package:taksh_e_commerce/core/constants/api_constants.dart';

/// Returns an absolute URL for a backend media path.
///
/// - `null`, empty and the literal `"null"` return `null`.
/// - Absolute URLs (with a scheme) are returned unchanged.
/// - Relative paths are resolved against the server origin (the API base URL
///   without its `/api` suffix), the same way the orders screen does.
String? resolveMediaUrl(String? raw) {
  final normalized = raw?.trim();
  if (normalized == null ||
      normalized.isEmpty ||
      normalized.toLowerCase() == 'null') {
    return null;
  }

  final uri = Uri.tryParse(normalized);
  if (uri != null && uri.hasScheme) return normalized;

  final origin = ApiConstants.serverOriginFromBaseUrl(ApiConstants.prodBaseUrl);
  return normalized.startsWith('/') ? '$origin$normalized' : '$origin/$normalized';
}
