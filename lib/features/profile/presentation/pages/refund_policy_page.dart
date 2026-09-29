import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';

/// Refund Policy page - displays refund and return policy
class RefundPolicyPage extends StatelessWidget {
  const RefundPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.refundPolicy,
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
                color: AppColors.secondaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.update,
                    size: 18,
                    color: AppColors.secondaryGreen,
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
              title: AppLocalizations.of(context)!.refundCommitmentTitle,
              content: AppLocalizations.of(context)!.refundCommitmentContent,
            ),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.info.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.refundReadPolicy,
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
              title: AppLocalizations.of(context)!.refundEligibilityTitle,
              content: AppLocalizations.of(context)!.refundEligibilityContent,
            ),

            _buildListItems(
              context,
              [
                AppLocalizations.of(context)!.refundEligibilityItem1,
                AppLocalizations.of(context)!.refundEligibilityItem2,
                AppLocalizations.of(context)!.refundEligibilityItem3,
                AppLocalizations.of(context)!.refundEligibilityItem4,
                AppLocalizations.of(context)!.refundEligibilityItem5,
              ],
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.refundNonReturnableTitle,
              content: AppLocalizations.of(context)!.refundNonReturnableContent,
            ),

            _buildListItems(
              context,
              [
                AppLocalizations.of(context)!.refundNonReturnableItem1,
                AppLocalizations.of(context)!.refundNonReturnableItem2,
                AppLocalizations.of(context)!.refundNonReturnableItem3,
                AppLocalizations.of(context)!.refundNonReturnableItem4,
                AppLocalizations.of(context)!.refundNonReturnableItem5,
                AppLocalizations.of(context)!.refundNonReturnableItem6,
              ],
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.refundProcessTitle,
              content: AppLocalizations.of(context)!.refundProcessContent,
            ),

            _buildStepCard(
              context,
              step: '1',
              title: AppLocalizations.of(context)!.refundStep1Title,
              description: AppLocalizations.of(context)!.refundStep1Desc,
              icon: Icons.assignment_return,
              color: AppColors.primaryOrange,
            ),

            _buildStepCard(
              context,
              step: '2',
              title: AppLocalizations.of(context)!.refundStep2Title,
              description: AppLocalizations.of(context)!.refundStep2Desc,
              icon: Icons.check_circle_outline,
              color: AppColors.info,
            ),

            _buildStepCard(
              context,
              step: '3',
              title: AppLocalizations.of(context)!.refundStep3Title,
              description: AppLocalizations.of(context)!.refundStep3Desc,
              icon: Icons.inventory_2_outlined,
              color: AppColors.warning,
            ),

            _buildStepCard(
              context,
              step: '4',
              title: AppLocalizations.of(context)!.refundStep4Title,
              description: AppLocalizations.of(context)!.refundStep4Desc,
              icon: Icons.local_shipping_outlined,
              color: AppColors.secondaryGreen,
            ),

            const SizedBox(height: 8),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.refundTimelineTitle,
              content: AppLocalizations.of(context)!.refundTimelineContent,
            ),

            _buildTimelineItem(
              context,
              day: AppLocalizations.of(context)!.refundTimelineItem1Day,
              description: AppLocalizations.of(context)!.refundTimelineItem1Desc,
            ),

            _buildTimelineItem(
              context,
              day: AppLocalizations.of(context)!.refundTimelineItem2Day,
              description: AppLocalizations.of(context)!.refundTimelineItem2Desc,
            ),

            _buildTimelineItem(
              context,
              day: AppLocalizations.of(context)!.refundTimelineItem3Day,
              description: AppLocalizations.of(context)!.refundTimelineItem3Desc,
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 20),
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
                    Icons.access_time,
                    size: 20,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.refundProcessingNote,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.refundMethodsTitle,
              content: AppLocalizations.of(context)!.refundMethodsContent,
            ),

            _buildRefundMethodCard(
              context,
              icon: Icons.credit_card,
              title: AppLocalizations.of(context)!.refundMethodOriginalTitle,
              description: AppLocalizations.of(context)!.refundMethodOriginalDesc,
              days: AppLocalizations.of(context)!.refundMethodOriginalDays,
            ),

            _buildRefundMethodCard(
              context,
              icon: Icons.account_balance_wallet,
              title: AppLocalizations.of(context)!.refundMethodCreditTitle,
              description: AppLocalizations.of(context)!.refundMethodCreditDesc,
              days: AppLocalizations.of(context)!.refundMethodCreditDays,
            ),

            _buildRefundMethodCard(
              context,
              icon: Icons.account_balance,
              title: AppLocalizations.of(context)!.refundMethodBankTitle,
              description: AppLocalizations.of(context)!.refundMethodBankDesc,
              days: AppLocalizations.of(context)!.refundMethodBankDays,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.refundDamagedTitle,
              content: AppLocalizations.of(context)!.refundDamagedContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.refundWrongTitle,
              content: AppLocalizations.of(context)!.refundWrongContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.refundPartialTitle,
              content: AppLocalizations.of(context)!.refundPartialContent,
            ),

             _buildListItems(
              context,
              [
                AppLocalizations.of(context)!.refundPartialItem1,
                AppLocalizations.of(context)!.refundPartialItem2,
                AppLocalizations.of(context)!.refundPartialItem3,
                AppLocalizations.of(context)!.refundPartialItem4,
              ],
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.refundExchangeTitle,
              content: AppLocalizations.of(context)!.refundExchangeContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.refundCancelTitle,
              content: AppLocalizations.of(context)!.refundCancelContent,
            ),

            _buildSection(
              context,
              title: AppLocalizations.of(context)!.refundContactTitle,
              content: AppLocalizations.of(context)!.refundContactContent,
            ),

            const SizedBox(height: 16),

            // Customer Satisfaction
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange.withOpacity(0.1),
                    AppColors.secondaryGreen.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryOrange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.thumb_up_outlined,
                    color: AppColors.primaryOrange,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.refundSatisfactionTitle,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.refundSatisfactionContent,
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

  Widget _buildStepCard(
    BuildContext context, {
    required String step,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Step $step',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required String day,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOrange,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefundMethodCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String days,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.secondaryGreen, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              days,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.info,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
