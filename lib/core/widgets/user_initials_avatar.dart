import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_tokens.dart';

/// Predefined avatar sizes that map to [AppTokens] avatar dimensions.
enum AvatarSize {
  /// 24×24 — icon-like contexts (e.g. chips, compact lists).
  xs(AppTokens.avatarXS),

  /// 32×32 — small list tiles, tags.
  sm(AppTokens.avatarSM),

  /// 40×40 — standard list tiles, comments.
  md(AppTokens.avatarMD),

  /// 56×56 — cards, detailed list items.
  lg(AppTokens.avatarLG),

  /// 72×72 — profile headers.
  xl(AppTokens.avatarXL);

  const AvatarSize(this.diameter);

  /// The diameter in logical pixels.
  final double diameter;

  /// Convenience getter for [CircleAvatar.radius].
  double get radius => diameter / 2;
}

/// A reusable circular avatar that displays:
///
/// 1. A network **profile image** if [imageUrl] is provided and loads
///    successfully.
/// 2. Otherwise, the user's **initials** derived from [name].
/// 3. As a last resort, a generic person icon.
///
/// ### Usage
/// ```dart
/// UserInitialsAvatar(
///   name: user.name,
///   imageUrl: user.profileImage,
///   size: AvatarSize.xl,
/// )
/// ```
///
/// The widget follows the project's design-token system ([AppTokens],
/// [AppColors], [AppTypography]) and is safe for use in any layer of the
/// widget tree.
class UserInitialsAvatar extends StatelessWidget {
  const UserInitialsAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.size = AvatarSize.md,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// The full display name of the user (e.g. "Rock Gental").
  /// Initials are extracted from the first and last word.
  final String? name;

  /// Optional profile image URL.  When non-null **and** the image loads
  /// without error, it takes precedence over initials.
  final String? imageUrl;

  /// One of the predefined [AvatarSize] values.
  final AvatarSize size;

  /// Override the default background colour of the initials circle.
  /// Defaults to [AppColors.secondaryGreen].
  final Color? backgroundColor;

  /// Override the text / icon colour.
  /// Defaults to [AppColors.white].
  final Color? foregroundColor;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Extracts up to two initials from [name].
  ///
  /// * `"Rock Gental"`  → `"RG"`
  /// * `"Arpit"`        → `"A"`
  /// * `null` / `""`    → `null` (triggers fallback icon)
  static String? getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return null;

    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return null;

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Returns a font size that scales with the avatar [size] so the initials
  /// remain visually balanced.
  double _fontSize() {
    switch (size) {
      case AvatarSize.xs:
        return 10;
      case AvatarSize.sm:
        return 13;
      case AvatarSize.md:
        return 16;
      case AvatarSize.lg:
        return 22;
      case AvatarSize.xl:
        return 28;
    }
  }

  /// Returns an icon size proportional to the avatar.
  double _iconSize() {
    switch (size) {
      case AvatarSize.xs:
        return AppTokens.iconXS;
      case AvatarSize.sm:
        return AppTokens.iconSM;
      case AvatarSize.md:
        return AppTokens.iconMD;
      case AvatarSize.lg:
        return AppTokens.iconLG;
      case AvatarSize.xl:
        return AppTokens.iconXL;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.secondaryGreen;
    final fgColor = foregroundColor ?? AppColors.white;
    final initials = getInitials(name);
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return CircleAvatar(
      radius: size.radius,
      backgroundColor: bgColor,
      backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      onBackgroundImageError: hasImage ? (_, __) {} : null,
      child: hasImage
          ? null // image covers the child when it loads
          : initials != null
              ? Text(
                  initials,
                  style: GoogleFonts.nunito(
                    fontSize: _fontSize(),
                    fontWeight: FontWeight.w700,
                    color: fgColor,
                    letterSpacing: 1.0,
                  ),
                )
              : Icon(
                  Icons.person,
                  size: _iconSize(),
                  color: fgColor,
                ),
    );
  }
}
