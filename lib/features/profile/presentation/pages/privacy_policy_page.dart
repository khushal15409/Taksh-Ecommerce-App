import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';

/// Privacy Policy page - displays app privacy policy and data handling practices
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.privacyPolicy,
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
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.update,
                    size: 18,
                    color: AppColors.info,
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
              title: AppLocalizations.of(context)!.privacyIntroTitle,
              content: AppLocalizations.of(context)!.privacyIntroContent,
            ),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryOrange.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.privacyAgreeContent,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyCollectTitle,
              content: AppLocalizations.of(context)!.privacyCollectContent,
            ),

            _buildSubSection(
              context,
              title: AppLocalizations.of(context)!.privacyPersonalTitle,
              content: AppLocalizations.of(context)!.privacyPersonalContent,
            ),

            _buildSubSection(
              context,
              title: AppLocalizations.of(context)!.privacyUsageTitle,
              content: AppLocalizations.of(context)!.privacyUsageContent,
            ),

            _buildSubSection(
              context,
              title: AppLocalizations.of(context)!.privacyTransactionTitle,
              content: AppLocalizations.of(context)!.privacyTransactionContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyUseTitle,
              content: AppLocalizations.of(context)!.privacyUseContent,
            ),

            _buildListItems(
              context,
              [
                AppLocalizations.of(context)!.privacyUseItem1,
                AppLocalizations.of(context)!.privacyUseItem2,
                AppLocalizations.of(context)!.privacyUseItem3,
                AppLocalizations.of(context)!.privacyUseItem4,
                AppLocalizations.of(context)!.privacyUseItem5,
                AppLocalizations.of(context)!.privacyUseItem6,
                AppLocalizations.of(context)!.privacyUseItem7,
                AppLocalizations.of(context)!.privacyUseItem8,
                AppLocalizations.of(context)!.privacyUseItem9,
              ],
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacySharingTitle,
              content: AppLocalizations.of(context)!.privacySharingContent,
            ),

            _buildSubSection(
              context,
              title: AppLocalizations.of(context)!.privacyProvidersTitle,
              content: AppLocalizations.of(context)!.privacyProvidersContent,
            ),

            _buildSubSection(
              context,
              title: AppLocalizations.of(context)!.privacyPartnersTitle,
              content: AppLocalizations.of(context)!.privacyPartnersContent,
            ),

            _buildSubSection(
              context,
              title: AppLocalizations.of(context)!.privacyLegalTitle,
              content: AppLocalizations.of(context)!.privacyLegalContent,
            ),

            _buildSubSection(
              context,
              title: AppLocalizations.of(context)!.privacyTransferTitle,
              content: AppLocalizations.of(context)!.privacyTransferContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacySecurityTitle,
              content: AppLocalizations.of(context)!.privacySecurityContent,
            ),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.security,
                    size: 20,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.privacySecurityNote,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyRightsTitle,
              content: AppLocalizations.of(context)!.privacyRightsContent,
            ),

            _buildListItems(
              context,
              [
                AppLocalizations.of(context)!.privacyRightsItem1,
                AppLocalizations.of(context)!.privacyRightsItem2,
                AppLocalizations.of(context)!.privacyRightsItem3,
                AppLocalizations.of(context)!.privacyRightsItem4,
                AppLocalizations.of(context)!.privacyRightsItem5,
                AppLocalizations.of(context)!.privacyRightsItem6,
                AppLocalizations.of(context)!.privacyRightsItem7,
              ],
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyCookiesTitle,
              content: AppLocalizations.of(context)!.privacyCookiesContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyLinksTitle,
              content: AppLocalizations.of(context)!.privacyLinksContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyChildrenTitle,
              content: AppLocalizations.of(context)!.privacyChildrenContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyRetentionTitle,
              content: AppLocalizations.of(context)!.privacyRetentionContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyInternationalTitle,
              content: AppLocalizations.of(context)!.privacyInternationalContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyChangesTitle,
              content: AppLocalizations.of(context)!.privacyChangesContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyContactTitle,
              content: AppLocalizations.of(context)!.privacyContactContent,
            ),

            const SizedBox(height: 16),

            // Commitment
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
                    Icons.shield_outlined,
                    color: AppColors.secondaryGreen,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.privacyMattersTitle,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.privacyMattersContent,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            height: 1.4,
                          ),
                        ),
                      ],
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
      padding: const EdgeInsets.only(bottom: 20),
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

  Widget _buildSubSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 6),
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

  Widget _buildListItems(BuildContext context, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 7),
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
