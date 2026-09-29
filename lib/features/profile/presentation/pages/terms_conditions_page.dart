import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';

/// Terms & Conditions page - displays app terms and conditions
class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.termsAndConditions,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Updated
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.update,
                    size: 18,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.lastUpdated('January 22, 2026'),
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Introduction
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsIntroTitle,
              content: AppLocalizations.of(context)!.termsIntroContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsAccountTitle,
              content: AppLocalizations.of(context)!.termsAccountContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsUserRespTitle,
              content: AppLocalizations.of(context)!.termsUserRespContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsProductsTitle,
              content: AppLocalizations.of(context)!.termsProductsContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsOrdersTitle,
              content: AppLocalizations.of(context)!.termsOrdersContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsShippingTitle,
              content: AppLocalizations.of(context)!.termsShippingContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsReturnsTitle,
              content: AppLocalizations.of(context)!.termsReturnsContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsIpTitle,
              content: AppLocalizations.of(context)!.termsIpContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsPrivacyTitle,
              content: AppLocalizations.of(context)!.termsPrivacyContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsLiabilityTitle,
              content: AppLocalizations.of(context)!.termsLiabilityContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsIndemnifyTitle,
              content: AppLocalizations.of(context)!.termsIndemnifyContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsModTitle,
              content: AppLocalizations.of(context)!.termsModContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsTerminationTitle,
              content: AppLocalizations.of(context)!.termsTerminationContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsLawTitle,
              content: AppLocalizations.of(context)!.termsLawContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsContactTitle,
              content: AppLocalizations.of(context)!.termsContactContent,
            ),

            const SizedBox(height: 16),

            // Acceptance
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.secondaryGreen.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.secondaryGreen,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.termsAck,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
