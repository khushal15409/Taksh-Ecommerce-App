import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';

/// About Us page - displays company information and mission
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.aboutUs,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: IndiaGradients.cardAccentGradient,
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      size: 60,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Taksh E-Commerce', // Brand name usually remains same or localized separately if needed
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your Trusted Shopping Partner',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Our Story
                  _buildSection(
                    context,
                    title: AppLocalizations.of(context)!.ourStory,
                    content: AppLocalizations.of(context)!.ourStoryContent,
                  ),

                  _buildSection(
                    context,
                    title: AppLocalizations.of(context)!.ourMission,
                    content: AppLocalizations.of(context)!.ourMissionContent,
                  ),

                  _buildSection(
                    context,
                    title: AppLocalizations.of(context)!.ourVision,
                    content: AppLocalizations.of(context)!.ourVisionContent,
                  ),

                  // Core Values
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.ourCoreValues,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildValueCard(
                    context,
                    icon: Icons.verified_user,
                    title: AppLocalizations.of(context)!.trustTransparency,
                    description:
                        AppLocalizations.of(context)!.trustTransparencyDesc,
                    color: AppColors.primaryOrange,
                  ),

                  _buildValueCard(
                    context,
                    icon: Icons.stars,
                    title: AppLocalizations.of(context)!.qualityFirst,
                    description: AppLocalizations.of(context)!.qualityFirstDesc,
                    color: AppColors.secondaryGreen,
                  ),

                  _buildValueCard(
                    context,
                    icon: Icons.people,
                    title: AppLocalizations.of(context)!.customerCentricity,
                    description:
                        AppLocalizations.of(context)!.customerCentricityDesc,
                    color: AppColors.info,
                  ),

                  _buildValueCard(
                    context,
                    icon: Icons.eco,
                    title: AppLocalizations.of(context)!.sustainability,
                    description:
                        AppLocalizations.of(context)!.sustainabilityDesc,
                    color: AppColors.secondaryGreen,
                  ),

                  _buildValueCard(
                    context,
                    icon: Icons.rocket_launch,
                    title: AppLocalizations.of(context)!.innovation,
                    description: AppLocalizations.of(context)!.innovationDesc,
                    color: AppColors.primaryOrange,
                  ),

                  const SizedBox(height: 8),

                  // What We Offer
                  _buildSection(
                    context,
                    title: AppLocalizations.of(context)!.whatWeOffer,
                    content: AppLocalizations.of(context)!.whatWeOfferContent,
                  ),

                  // Statistics
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryOrange.withOpacity(0.1),
                          AppColors.secondaryGreen.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.ourImpact,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStat(context, '50K+',
                                  AppLocalizations.of(context)!.happyCustomers),
                            ),
                            Expanded(
                              child: _buildStat(context, '20K+',
                                  AppLocalizations.of(context)!.products),
                            ),
                            Expanded(
                              child: _buildStat(context, '100+',
                                  AppLocalizations.of(context)!.brands),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStat(context, '40+',
                                  AppLocalizations.of(context)!.cities),
                            ),
                            Expanded(
                              child: _buildStat(context, '4.5★',
                                  AppLocalizations.of(context)!.rating),
                            ),
                            Expanded(
                              child: _buildStat(context, '24/7',
                                  AppLocalizations.of(context)!.support),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Contact Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.getInTouch,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildContactItem(
                          context,
                          Icons.email,
                          AppLocalizations.of(context)!.emailLabel,
                          'info@takshllinone.in',
                        ),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          context,
                          Icons.location_on,
                          AppLocalizations.of(context)!.addressLabel,
                          AppLocalizations.of(context)!.addressValue,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tricolor stripe
                  Center(
                    child: Container(
                      width: 100,
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: IndiaGradients.tricolorHorizontal,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
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
              fontSize: 18,
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

  Widget _buildValueCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryOrange,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContactItem(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryOrange),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
