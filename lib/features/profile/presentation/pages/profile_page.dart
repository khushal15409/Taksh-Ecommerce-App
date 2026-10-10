import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/core/widgets/guest_auth_wall.dart';
import 'package:taksh_e_commerce/core/widgets/user_initials_avatar.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:taksh_e_commerce/features/address/presentation/pages/address_list_page.dart';
import 'package:taksh_e_commerce/features/profile/presentation/pages/terms_conditions_page.dart';
import 'package:taksh_e_commerce/features/profile/presentation/pages/about_us_page.dart';
import 'package:taksh_e_commerce/features/profile/presentation/pages/privacy_policy_page.dart';
import 'package:taksh_e_commerce/features/profile/presentation/pages/refund_policy_page.dart';
import 'package:taksh_e_commerce/features/profile/presentation/pages/update_profile_details_page.dart';
import 'package:taksh_e_commerce/features/profile/presentation/pages/delivery_boy_join_page.dart';
import 'package:taksh_e_commerce/features/profile/presentation/pages/vendor_join_page.dart';
import 'package:taksh_e_commerce/features/profile/presentation/pages/development_request_page.dart';
import 'package:taksh_e_commerce/features/wallet/presentation/pages/wallet_page.dart';
import 'package:taksh_e_commerce/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:taksh_e_commerce/features/profile/presentation/pages/your_accounts.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_request.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/callback_bloc.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/callback_event.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/callback_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_state.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';

/// Profile page - displays user profile and settings
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isAppearanceExpanded = false;
  bool _isLanguageExpanded = false;

  @override
  void initState() {
    super.initState();
    // Fetch latest profile data from server when page opens
    context.read<AuthBloc>().add(const AuthFetchProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return TakshSoftBackground(
      art: TakshArt.home,
      artHeight: 260,
      child: Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return _buildProfileContent(context, state);
          }
          if (state is Unauthenticated) {
            return const GuestAuthWall(
              redirectToRoute: AppRoutes.profile,
              contentLabel: 'your profile',
              icon: Icons.person_outline,
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryOrange,
            ),
          );
        },
      ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, Authenticated state) {
    return CustomScrollView(
      slivers: [
        // App Bar with gradient background
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    // Profile Avatar with initials
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: UserInitialsAvatar(
                        name: state.user.name,
                        imageUrl: state.user.profileImage,
                        size: AvatarSize.xl,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // User Name replaced with "Your account"
                    Column(
                      children: [
                        Text(
                          state.user.name?.isNotEmpty == true
                              ? state.user.name!
                              : 'Your account',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          state.user.email?.isNotEmpty == true
                              ? state.user.email!
                              : 'Your account',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryGreen,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                const SizedBox(height: 24),

                // _buildStatsSection(context), // Removed as per design
                _buildQuickActions(context, state),

                const SizedBox(height: 16),

                _buildAppearanceSection(context),

                const SizedBox(height: 16),

                _buildLanguageSection(context),

                const SizedBox(height: 16),

                _buildSectionCard(
                  context,
                  title: AppLocalizations.of(context)!.general,
                  items: [
                    _MenuItemData(
                      icon: Icons.location_on_outlined,
                      title: AppLocalizations.of(context)!.myAddress,
                      iconColor: AppColors.black,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddressListPage(),
                          ),
                        );
                      },
                    ),
                    _MenuItemData(
                      icon: Icons.card_giftcard_outlined,
                      title: AppLocalizations.of(context)!.coupons,
                      iconColor: AppColors.black,
                      onTap: () {
                        // Coupons logic
                      },
                    ),
                    _MenuItemData(
                      icon: Icons.favorite_outline_rounded,
                      title: AppLocalizations.of(context)!.wishlist,
                      iconColor: AppColors.black,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: getIt<WishlistCubit>(),
                              child: const WishlistPage(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Preferences Section
                _buildSectionCard(
                  context,
                  title: AppLocalizations.of(context)!.earnings,
                  items: [
                    _MenuItemData(
                      icon: Icons.delivery_dining,
                      title: AppLocalizations.of(context)!.joinAsDeliveryMan,
                      iconColor: AppColors.black,
                      onTap: () {
                        // Navigate to delivery boy join form
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DeliveryBoyJoinPage(),
                          ),
                        );
                      },
                    ),
                    _MenuItemData(
                      icon: Icons.store_outlined,
                      title: AppLocalizations.of(context)!.openVendor,
                      iconColor: AppColors.black,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VendorJoinPage(),
                          ),
                        );
                      },
                    ),
                    _MenuItemData(
                      icon: Icons.phone_android_outlined,
                      title: AppLocalizations.of(context)!.createApplication,
                      iconColor: AppColors.black,
                      onTap: () {
                        // Navigate to app development request form
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DevelopmentRequestPage(
                              requestType:
                                  DevelopmentRequestType.appDevelopment,
                            ),
                          ),
                        );
                      },
                    ),
                    _MenuItemData(
                      icon: Icons.web_outlined,
                      title: AppLocalizations.of(context)!.createWebsite,
                      iconColor: AppColors.black,
                      onTap: () {
                        // Navigate to web development request form
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DevelopmentRequestPage(
                              requestType:
                                  DevelopmentRequestType.webDevelopment,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Support Section
                _buildSectionCard(
                  context,
                  title: AppLocalizations.of(context)!.helpSupport,
                  items: [
                    _MenuItemData(
                      icon: Icons.help_outline,
                      title: AppLocalizations.of(context)!.helpAndSupport,
                      iconColor: AppColors.black,
                      onTap: () {
                        // Show support options (callback + email)
                        _showSupportOptionsDialog(context);
                      },
                    ),
                    _MenuItemData(
                      icon: Icons.chat_rounded,
                      title: AppLocalizations.of(context)!.liveChat,
                      iconColor: AppColors.black,
                      onTap: () async {
                        const phoneNumber =
                            '919518365510'; // India country code + number
                        final whatsappUrl = Uri.parse(
                          'https://wa.me/$phoneNumber',
                        );

                        if (await canLaunchUrl(whatsappUrl)) {
                          await launchUrl(
                            whatsappUrl,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!.whatsappError,
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    _MenuItemData(
                      icon: Icons.business_outlined,
                      title: AppLocalizations.of(context)!.aboutUs,
                      iconColor: AppColors.black,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutUsPage(),
                          ),
                        );
                      },
                    ),
                    _MenuItemData(
                      icon: Icons.description_outlined,
                      title: AppLocalizations.of(context)!.termsAndConditions,
                      iconColor: AppColors.black,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsConditionsPage(),
                          ),
                        );
                      },
                    ),
                    _MenuItemData(
                      icon: Icons.shield_outlined,
                      title: AppLocalizations.of(context)!.privacyPolicy,
                      iconColor: AppColors.black,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyPage(),
                          ),
                        );
                      },
                    ),
                    _MenuItemData(
                      icon: Icons.currency_exchange_outlined,
                      title: AppLocalizations.of(context)!.refundPolicy,
                      iconColor: AppColors.black,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RefundPolicyPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: Text(
                        AppLocalizations.of(context)!.logout,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.red.shade200),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  AppLocalizations.of(context)!.version('1.0.0'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey500,
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    final splashState = context.watch<SplashCubit>().state;
    ThemeMode currentThemeMode = ThemeMode.system;

    if (splashState is SplashCompleted) {
      currentThemeMode = splashState.themeMode;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Appearance Header
                ListTile(
                  onTap: () {
                    setState(() {
                      _isAppearanceExpanded = !_isAppearanceExpanded;
                    });
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.palette_outlined,
                      color: AppColors.black,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.appearance,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  trailing: Icon(
                    _isAppearanceExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: AppColors.grey400,
                    size: 24,
                  ),
                ),
                // Dropdown Options
                if (_isAppearanceExpanded)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        const Divider(
                          height: 1,
                          color: AppColors.grey200,
                        ),
                        const SizedBox(height: 8),
                        _buildThemeOption(
                          context,
                          AppLocalizations.of(context)!.light,
                          ThemeMode.light,
                          currentThemeMode == ThemeMode.light,
                        ),
                        const SizedBox(height: 4),
                        _buildThemeOption(
                          context,
                          AppLocalizations.of(context)!.dark,
                          ThemeMode.dark,
                          currentThemeMode == ThemeMode.dark,
                        ),
                        const SizedBox(height: 4),
                        _buildThemeOption(
                          context,
                          AppLocalizations.of(context)!.system,
                          ThemeMode.system,
                          currentThemeMode == ThemeMode.system,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String label,
    ThemeMode mode,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        context.read<SplashCubit>().updateTheme(mode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.themeChanged(label)),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryOrange.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              mode == ThemeMode.light
                  ? Icons.light_mode
                  : (mode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.brightness_auto),
              color: isSelected ? AppColors.primaryOrange : AppColors.grey600,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppColors.primaryOrange
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryOrange,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    final splashState = context.watch<SplashCubit>().state;
    String currentLangCode = 'en';

    if (splashState is SplashCompleted) {
      currentLangCode = splashState.locale.languageCode;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.preferences,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Language Header
                ListTile(
                  onTap: () {
                    setState(() {
                      _isLanguageExpanded = !_isLanguageExpanded;
                    });
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.language_outlined,
                      color: AppColors.black,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.language,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  trailing: Icon(
                    _isLanguageExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.grey400,
                    size: 24,
                  ),
                ),
                // Dropdown Options
                if (_isLanguageExpanded)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        const Divider(
                          height: 1,
                          color: AppColors.grey200,
                        ),
                        const SizedBox(height: 8),
                        _buildLanguageOption(
                          context,
                          AppLocalizations.of(context)!.english,
                          'en',
                          currentLangCode == 'en',
                        ),
                        const SizedBox(height: 4),
                        _buildLanguageOption(
                          context,
                          AppLocalizations.of(context)!.hindi,
                          'hi',
                          currentLangCode == 'hi',
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String label,
    String langCode,
    bool isSelected,
  ) {
    IconData flagIcon;
    if (langCode == 'en') {
      flagIcon = Icons.language;
    } else {
      flagIcon = Icons.translate;
    }

    return InkWell(
      onTap: () {
        // Update app locale via SplashCubit
        context.read<SplashCubit>().updateLocale(Locale(langCode));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.languageChanged(label)),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryGreen.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.secondaryGreen : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              flagIcon,
              color: isSelected ? AppColors.secondaryGreen : AppColors.grey600,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppColors.secondaryGreen
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.secondaryGreen,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Authenticated state) {
    final hasBirthday = state.user.birthday?.isNotEmpty == true;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Birthday Banner
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateProfileDetailsPage(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6), // Light yellow background
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasBirthday ? 'Your birthday' : 'Add your birthday',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasBirthday
                              ? state.user.birthday!
                              : 'Enter details >',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.cake,
                    size: 40,
                    color: Color(0xFFFFA340), // Orange cake icon
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Orders and Wallet
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: Icons.shopping_basket_outlined,
                  title: 'Your Accounts',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YourAccountsPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Gift Cards',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              getIt<WalletCubit>()..loadWallet(),
                          child: const WalletPage(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.black, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required List<_MenuItemData> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: List.generate(
                items.length,
                (index) => Column(
                  children: [
                    _buildMenuItem(context, item: items[index]),
                    if (index < items.length - 1)
                      Divider(
                        height: 1,
                        indent: 68,
                        endIndent: 16,
                        color: Theme.of(context).dividerColor.withOpacity(0.1),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required _MenuItemData item}) {
    return ListTile(
      onTap: item.onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: item.iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(item.icon, color: item.iconColor, size: 24),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).disabledColor,
        size: 24,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  /// Show callback request confirmation dialog
  void _showSupportOptionsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                l10n.helpAndSupport,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.chooseHowToReachUs,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: 20),
              // Request Callback option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.phone_callback,
                    color: AppColors.secondaryGreen,
                  ),
                ),
                title: Text(
                  l10n.requestCallback,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  l10n.requestCallbackDescription,
                  style: const TextStyle(
                    color: AppColors.grey600,
                    fontSize: 13,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(bottomSheetContext).pop();
                  _showCallbackConfirmationDialog(context);
                },
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              // Email Support option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.email_outlined,
                    color: AppColors.primaryOrange,
                  ),
                ),
                title: Text(
                  l10n.emailSupport,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  l10n.emailSupportDescription,
                  style: const TextStyle(
                    color: AppColors.grey600,
                    fontSize: 13,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  Navigator.of(bottomSheetContext).pop();
                  final emailUri = Uri(
                    scheme: 'mailto',
                    path: 'customersupport@takshallinone.in',
                    queryParameters: {'subject': 'Support Request'},
                  );
                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.emailAppError)),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showCallbackConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (context) => getIt<CallbackBloc>(),
        child: BlocConsumer<CallbackBloc, CallbackState>(
          listener: (context, state) {
            if (state is CallbackRequestSuccess) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.secondaryGreen,
                ),
              );
            } else if (state is CallbackError) {
              Navigator.of(dialogContext).pop();
              AppErrorToast.show(context);
            }
          },
          builder: (context, state) {
            final isLoading = state is CallbackLoading;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(
                    Icons.phone_callback,
                    color: AppColors.secondaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Request Callback',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Do you need a callback from our support team? We will get in touch with you shortly.',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<CallbackBloc>().add(
                            const CallbackRequested(),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Yes, Call Me'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final Color iconColor;
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.onTap,
  });
}
