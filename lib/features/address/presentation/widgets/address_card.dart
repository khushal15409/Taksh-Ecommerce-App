import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/core/theme/app_tokens.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address_type.dart';

/// A responsive, theme-aware card widget to display address information.
class AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;
  final bool showActions;

  const AddressCard({
    super.key,
    required this.address,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDefault = address.isDefault;
    final typeStyle = _typeStyle(address.type);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPaddingHorizontal,
        vertical: AppSpacing.xxs,
      ),
      child: Material(
        color: colorScheme.surface,
        borderRadius: AppTokens.borderRadiusMD,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppTokens.borderRadiusMD,
            border: Border.all(
              color: isDefault ? colorScheme.primary : colorScheme.outline,
              width: isDefault
                  ? AppTokens.borderWidthMedium
                  : AppTokens.borderWidthThin,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: AppTokens.borderRadiusMD,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Accent strip at the top ──
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: isDefault
                        ? colorScheme.primary
                        : typeStyle.color.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppTokens.radiusMD),
                      topRight: Radius.circular(AppTokens.radiusMD),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.cardPadding,
                    AppSpacing.sm,
                    AppSpacing.cardPadding,
                    AppSpacing.cardPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header: icon + label + badges ──
                      Row(
                        children: [
                          _TypeBadge(
                            icon: typeStyle.icon,
                            color: typeStyle.color,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getTypeLabel(),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (address.recipientName.isNotEmpty)
                                  Text(
                                    address.recipientName,
                                    style:
                                        theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          if (isDefault) ...[
                            const SizedBox(width: AppSpacing.xs),
                            _DefaultChip(colorScheme: colorScheme),
                          ],
                        ],
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // ── Address body ──
                      Text(
                        address.fullAddress,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.75),
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // ── Landmark row ──
                      if (address.landmark != null &&
                          address.landmark!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Icon(
                              Icons.near_me_outlined,
                              size: AppTokens.iconXS,
                              color:
                                  colorScheme.onSurface.withOpacity(0.45),
                            ),
                            const SizedBox(width: AppSpacing.xxs),
                            Expanded(
                              child: Text(
                                'Near ${address.landmark}',
                                style:
                                    theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface
                                      .withOpacity(0.55),
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],

                      // ── Postal code / phone row ──
                      if (address.location.postalCode != null ||
                          address.recipientPhone.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.xxs,
                          children: [
                            if (address.location.postalCode != null)
                              _InfoChip(
                                icon: Icons.pin_drop_outlined,
                                label:
                                    'PIN: ${address.location.postalCode}',
                                colorScheme: colorScheme,
                              ),
                            if (address.recipientPhone.isNotEmpty)
                              _InfoChip(
                                icon: Icons.phone_outlined,
                                label: address.recipientPhone,
                                colorScheme: colorScheme,
                              ),
                          ],
                        ),
                      ],

                      // ── Actions ──
                      if (showActions) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Divider(
                          height: 1,
                          color: colorScheme.outline.withOpacity(0.3),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _ActionRow(
                          address: address,
                          onSetDefault: onSetDefault,
                          onEdit: onEdit,
                          onDelete: onDelete,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTypeLabel() {
    switch (address.type) {
      case AddressType.home:
        return 'Home';
      case AddressType.work:
        return 'Work';
      case AddressType.other:
        return address.customLabel ?? 'Other';
    }
  }

  static _AddressTypeStyle _typeStyle(AddressType type) {
    switch (type) {
      case AddressType.home:
        return const _AddressTypeStyle(
            Icons.home_rounded, AppColors.info);
      case AddressType.work:
        return const _AddressTypeStyle(
            Icons.work_rounded, AppColors.primaryOrange);
      case AddressType.other:
        return const _AddressTypeStyle(
            Icons.location_on_rounded, AppColors.secondaryGreen);
    }
  }
}

// ────────────────────────────────────────────────────────────
//  Private sub-widgets
// ────────────────────────────────────────────────────────────

class _AddressTypeStyle {
  final IconData icon;
  final Color color;
  const _AddressTypeStyle(this.icon, this.color);
}

/// Circular icon badge showing the address type.
class _TypeBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _TypeBadge({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: AppTokens.borderRadiusSM,
      ),
      child: Icon(icon, color: color, size: AppTokens.iconSM),
    );
  }
}

/// Small "Default" chip shown for the default address.
class _DefaultChip extends StatelessWidget {
  final ColorScheme colorScheme;

  const _DefaultChip({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryGreen.withOpacity(0.12),
        borderRadius: AppTokens.borderRadiusXS,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 12,
            color: AppColors.secondaryGreen,
          ),
          SizedBox(width: 3),
          Text(
            'Default',
            style: TextStyle(
              color: AppColors.secondaryGreen,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small info chip for postal code / phone.
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: colorScheme.onSurface.withOpacity(0.45),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.55),
                letterSpacing: 0.2,
              ),
        ),
      ],
    );
  }
}

/// Responsive action row — uses LayoutBuilder to switch between
/// icon-only on narrow widths and icon+text on wider widths.
class _ActionRow extends StatelessWidget {
  final Address address;
  final VoidCallback? onSetDefault;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ActionRow({
    required this.address,
    this.onSetDefault,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use compact mode for narrow widths
        final compact = constraints.maxWidth < 300;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!address.isDefault && onSetDefault != null)
              _ActionButton(
                icon: Icons.check_circle_outline_rounded,
                label: 'Set Default',
                color: Theme.of(context).colorScheme.primary,
                compact: compact,
                onPressed: onSetDefault!,
              ),
            const Spacer(),
            if (onEdit != null)
              _ActionButton(
                icon: Icons.edit_outlined,
                label: 'Edit',
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.7),
                compact: compact,
                onPressed: onEdit!,
              ),
            if (onDelete != null) ...[
              const SizedBox(width: AppSpacing.xxs),
              _ActionButton(
                icon: Icons.delete_outline_rounded,
                label: 'Delete',
                color: AppColors.error,
                compact: compact,
                onPressed: onDelete!,
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Individual action button — shows text on wide, icon-only on narrow.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool compact;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.compact,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: AppTokens.iconSM),
        color: color,
        visualDensity: VisualDensity.compact,
        tooltip: label,
        padding: const EdgeInsets.all(AppSpacing.xxs),
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      );
    }

    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13),
      ),
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
