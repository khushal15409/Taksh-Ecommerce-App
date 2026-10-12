/// Parses a latitude/longitude value coming from JSON.
///
/// The backend returns floats today, but numeric strings and nulls are
/// tolerated so a changed or partial response never throws. Returns `null`
/// when the value is missing, empty, not a number or not finite.
double? parseCoordinate(dynamic value) {
  if (value == null) return null;
  final double? parsed;
  if (value is num) {
    parsed = value.toDouble();
  } else if (value is String) {
    final text = value.trim();
    if (text.isEmpty) return null;
    parsed = double.tryParse(text);
  } else {
    return null;
  }
  if (parsed == null || !parsed.isFinite) return null;
  return parsed;
}
