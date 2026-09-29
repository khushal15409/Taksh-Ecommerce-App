import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// A text widget that collapses long content to a fixed number of lines and
/// reveals a "Read more" / "Read less" toggle only when overflow is detected.
///
/// The widget measures the text in a hidden, unconstrained pass to determine
/// whether truncation is required. This avoids showing the toggle for text
/// that would fit within [collapseMaxLines] regardless of its character count.
class ExpandableText extends StatefulWidget {
  /// The text to display.
  final String text;

  /// Number of lines shown when collapsed.
  final int collapseMaxLines;

  /// Base text style. Only `fontSize` and `height` are read for layout; the
  /// remaining style properties are forwarded to the rendered [Text] widgets.
  final TextStyle? style;

  /// Color for the "Read more" / "Read less" link. Defaults to
  /// [AppColors.primaryOrange] to match the rest of the product UI.
  final Color? linkColor;

  const ExpandableText({
    super.key,
    required this.text,
    this.collapseMaxLines = 4,
    this.style,
    this.linkColor,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final linkColor = widget.linkColor ?? AppColors.primaryOrange;
    final baseStyle =
        widget.style ??
        const TextStyle(
          color: AppColors.grey700,
          fontSize: 16,
          height: 1.45,
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: baseStyle);

        // Measure whether the text would overflow when constrained to
        // [collapseMaxLines]. We render the text in an offstage pass with the
        // same width/fontSize/height so the result is consistent with the
        // visible render.
        final tp = TextPainter(
          text: span,
          textDirection: Directionality.of(context),
          maxLines: widget.collapseMaxLines,
          ellipsis: '…',
        )..layout(maxWidth: constraints.maxWidth);

        final didOverflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Text(
                widget.text,
                style: baseStyle,
                maxLines: _isExpanded || !didOverflow
                    ? null
                    : widget.collapseMaxLines,
                overflow: _isExpanded || !didOverflow
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
            ),
            if (didOverflow) ...[
              const SizedBox(height: 6),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    _isExpanded ? l10n.readLess : l10n.readMore,
                    style: baseStyle.copyWith(
                      color: linkColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
