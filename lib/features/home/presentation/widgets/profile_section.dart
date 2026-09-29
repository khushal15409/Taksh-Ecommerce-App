import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';

/// Profile section - user profile and settings
class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: colorScheme.surface,
              elevation: 0,
              title: Text(
                'Profile',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    // TODO: Navigate to settings
                  },
                ),
              ],
            ),

            // Profile Header
            SliverToBoxAdapter(
              child: Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.all(AppSpacing.paddingLG),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    String userName = 'Guest User';
                    String userContact = 'guest@example.com';

                    if (state is Authenticated) {
                      userName = state.user.name ?? 'User';
                      userContact = state.user.mobile.isNotEmpty
                          ? state.user.mobile
                          : (state.user.email ?? 'No contact');
                    }

                    return Column(
                      children: [
                        // Profile Picture
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              userName.isNotEmpty ? userName[0].toUpperCase() : 'G',
                              style: theme.textTheme.displayMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // User Name
                        Text(
                          userName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // User Email/Phone
                        Text(
                          userContact,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Edit Profile Button
                        OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Navigate to edit profile
                          },
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit Profile'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Stats Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.paddingMD),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Orders',
                        value: '12',
                        colorScheme: colorScheme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.favorite_outline,
                        label: 'Favorites',
                        value: '8',
                        colorScheme: colorScheme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.location_on_outlined,
                        label: 'Addresses',
                        value: '3',
                        colorScheme: colorScheme,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Menu Items
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _MenuItem(
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      onTap: () {
                        // TODO: Navigate to personal info
                      },
                      colorScheme: colorScheme,
                    ),
                    _MenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'My Addresses',
                      onTap: () {
                        // TODO: Navigate to addresses
                      },
                      colorScheme: colorScheme,
                    ),
                    _MenuItem(
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      onTap: () {
                        // TODO: Navigate to payment methods
                      },
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Preferences',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {
                        // TODO: Navigate to notifications settings
                      },
                      colorScheme: colorScheme,
                    ),
                    _MenuItem(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: 'English',
                      onTap: () {
                        // TODO: Navigate to language settings
                      },
                      colorScheme: colorScheme,
                    ),
                    _MenuItem(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // TODO: Toggle dark mode
                        },
                      ),
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Support',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _MenuItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {
                        // TODO: Navigate to help
                      },
                      colorScheme: colorScheme,
                    ),
                    _MenuItem(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        // TODO: Navigate to about
                      },
                      colorScheme: colorScheme,
                    ),
                    _MenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        // TODO: Navigate to privacy policy
                      },
                      colorScheme: colorScheme,
                    ),
                    _MenuItem(
                      icon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      onTap: () {
                        // TODO: Navigate to terms
                      },
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 24),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // App Version
                    Center(
                      child: Text(
                        'Version ${AppConstants.appVersion}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingMD),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Menu item widget
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final ColorScheme colorScheme;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: colorScheme.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              )
            : null,
        trailing: trailing ??
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
        onTap: onTap,
      ),
    );
  }
}
