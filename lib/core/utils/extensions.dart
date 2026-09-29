

extension AlphaExtension on num {
  int toAlpha() {
    final clampedValue = clamp(0, 1);
    return (clampedValue * 255).toInt();
  }
}
