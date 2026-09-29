import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/theme.dart';

/// Example widget demonstrating design system usage
/// This serves as a reference for developers
class DesignSystemExample extends StatelessWidget {
  const DesignSystemExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Typography Section =====
            _buildSection(
              title: 'Typography',
              children: [
                Text('Display Large', style: AppTypography.displayLarge),
                const SizedBox(height: AppSpacing.gapXS),
                Text('Headline Large', style: AppTypography.headlineLarge),
                const SizedBox(height: AppSpacing.gapXS),
                Text('Title Large', style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.gapXS),
                Text('Body Large', style: AppTypography.bodyLarge),
                const SizedBox(height: AppSpacing.gapXS),
                Text('Body Medium', style: AppTypography.bodyMedium),
                const SizedBox(height: AppSpacing.gapXS),
                Text('Label Small', style: AppTypography.labelSmall),
                const SizedBox(height: AppSpacing.gapXS),
                Text(
                  'Product Title',
                  style: AppTypography.productTitle,
                ),
                const SizedBox(height: AppSpacing.gapXS),
                Text(
                  '₹1,999',
                  style: AppTypography.productPrice.copyWith(
                    color: AppColors.price,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.gapXL),

            // ===== Colors Section =====
            _buildSection(
              title: 'Colors',
              children: [
                Wrap(
                  spacing: AppSpacing.gapSM,
                  runSpacing: AppSpacing.gapSM,
                  children: [
                    _buildColorBox('Primary', AppColors.primaryOrange),
                    _buildColorBox('Secondary', AppColors.secondaryGreen),
                    _buildColorBox('Success', AppColors.success),
                    _buildColorBox('Error', AppColors.error),
                    _buildColorBox('Warning', AppColors.warning),
                    _buildColorBox('Info', AppColors.info),
                    _buildColorBox('Discount', AppColors.discount),
                    _buildColorBox('Rating', AppColors.rating),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.gapXL),

            // ===== Buttons Section =====
            _buildSection(
              title: 'Buttons',
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated Button'),
                ),
                const SizedBox(height: AppSpacing.gapMD),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined Button'),
                ),
                const SizedBox(height: AppSpacing.gapMD),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text Button'),
                ),
                const SizedBox(height: AppSpacing.gapMD),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add to Cart'),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.gapXL),

            // ===== Cards Section =====
            _buildSection(
              title: 'Cards',
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Title',
                          style: AppTypography.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.gapSM),
                        Text(
                          'This is a card with proper spacing and styling from the design system.',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.gapMD),
                _buildProductCard(),
              ],
            ),

            const SizedBox(height: AppSpacing.gapXL),

            // ===== Form Inputs Section =====
            _buildSection(
              title: 'Form Inputs',
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: AppSpacing.formFieldGap),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.visibility),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: AppSpacing.formFieldGap),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Disabled',
                    hintText: 'Disabled field',
                  ),
                  enabled: false,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.gapXL),

            // ===== Icons Section =====
            _buildSection(
              title: 'Icons',
              children: [
                const Row(
                  children: [
                    Icon(Icons.home, size: AppTokens.iconXS),
                    SizedBox(width: AppSpacing.gapSM),
                    Icon(Icons.search, size: AppTokens.iconSM),
                    SizedBox(width: AppSpacing.gapSM),
                    Icon(Icons.shopping_cart, size: AppTokens.iconMD),
                    SizedBox(width: AppSpacing.gapSM),
                    Icon(Icons.favorite, size: AppTokens.iconLG),
                    SizedBox(width: AppSpacing.gapSM),
                    Icon(Icons.person, size: AppTokens.iconXL),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.gapXL),

            // ===== Chips Section =====
            _buildSection(
              title: 'Chips',
              children: [
                Wrap(
                  spacing: AppSpacing.gapSM,
                  runSpacing: AppSpacing.gapSM,
                  children: [
                    const Chip(
                      label: Text('Electronics'),
                      avatar: Icon(Icons.phone_android, size: 16),
                    ),
                    const Chip(
                      label: Text('Fashion'),
                      avatar: Icon(Icons.checkroom, size: 16),
                    ),
                    const Chip(
                      label: Text('Home'),
                      avatar: Icon(Icons.home, size: 16),
                    ),
                    ActionChip(
                      label: const Text('Filter'),
                      onPressed: () {},
                      avatar: const Icon(Icons.filter_list, size: 16),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.gapXL),

            // ===== Status Messages Section =====
            _buildSection(
              title: 'Status Messages',
              children: [
                _buildStatusMessage(
                  'Success! Your order has been placed.',
                  AppColors.success,
                  Icons.check_circle,
                ),
                const SizedBox(height: AppSpacing.gapMD),
                _buildStatusMessage(
                  'Error! Something went wrong.',
                  AppColors.error,
                  Icons.error,
                ),
                const SizedBox(height: AppSpacing.gapMD),
                _buildStatusMessage(
                  'Warning! Low stock available.',
                  AppColors.warning,
                  Icons.warning,
                ),
                const SizedBox(height: AppSpacing.gapMD),
                _buildStatusMessage(
                  'Info: Free shipping on orders above ₹500.',
                  AppColors.info,
                  Icons.info,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.screenPaddingBottom),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: AppTypography.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.gapMD),
        ...children,
      ],
    );
  }

  Widget _buildColorBox(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppTokens.borderRadiusSM,
            boxShadow: AppTokens.shadowSM,
          ),
        ),
        const SizedBox(height: AppSpacing.gapXS),
        Text(
          label,
          style: AppTypography.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProductCard() {
    return Container(
      width: AppTokens.productCardWidth,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppTokens.cardRadius,
        boxShadow: AppTokens.cardShadow,
        border: Border.all(
          color: AppColors.borderLight,
          width: AppTokens.borderWidthThin,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.productCardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image placeholder
          Container(
            height: AppTokens.productImageHeight,
            decoration: const BoxDecoration(
              color: AppColors.grey200,
              borderRadius: AppTokens.imageRadius,
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                size: AppTokens.iconXXL,
                color: AppColors.grey400,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.productCardContentGap),

          // Product title
          Text(
            'Sample Product Name',
            style: AppTypography.productTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.productCardContentGap),

          // Rating
          Row(
            children: [
              const Icon(
                Icons.star,
                size: AppTokens.iconSM,
                color: AppColors.rating,
              ),
              const SizedBox(width: AppSpacing.xxxs),
              Text(
                '4.5',
                style: AppTypography.labelSmall,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '(120)',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.productCardContentGap),

          // Price
          Row(
            children: [
              Text(
                '₹999',
                style: AppTypography.productPrice.copyWith(
                  color: AppColors.price,
                ),
              ),
              const SizedBox(width: AppSpacing.gapXS),
              Text(
                '₹1,999',
                style: AppTypography.bodySmall.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxxs),

          // Discount badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingXS,
              vertical: AppSpacing.xxxs,
            ),
            decoration: const BoxDecoration(
              color: AppColors.discount,
              borderRadius: AppTokens.borderRadiusXS,
            ),
            child: Text(
              '50% OFF',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMessage(String message, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingMD),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppTokens.borderRadiusSM,
        border: Border.all(
          color: color,
          width: AppTokens.borderWidthThin,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppTokens.iconMD),
          const SizedBox(width: AppSpacing.gapSM),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
