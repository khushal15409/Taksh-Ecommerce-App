import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/home_service.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/cubit/home_service_cubit.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/cubit/home_service_state.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/pages/courier_booking_page.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/pages/general_service_page.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Content widget shown in the home tab when home services are selected.
class HomeServiceContent extends StatelessWidget {
  const HomeServiceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeServiceCubit>()..fetchServices(),
      child: const _HomeServiceContentBody(),
    );
  }
}

class _HomeServiceContentBody extends StatelessWidget {
  const _HomeServiceContentBody();

  static const _serviceStyles = <String, _ServiceStyle>{
    'courier-booking': _ServiceStyle(
      icon: Icons.local_shipping_rounded,
      gradient: [Color(0xFFFF6B35), Color(0xFFFF9A62)],
      borderColor: Color(0xFFFFD7C2),
      surfaceColor: Color(0xFFFFF8F3),
    ),
    'electrician': _ServiceStyle(
      icon: Icons.electrical_services_rounded,
      gradient: [Color(0xFF1976D2), Color(0xFF4FC3F7)],
      borderColor: Color(0xFFD1E7FB),
      surfaceColor: Color(0xFFF6FBFF),
    ),
    'plumber': _ServiceStyle(
      icon: Icons.plumbing_rounded,
      gradient: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
      borderColor: Color(0xFFD7ECD7),
      surfaceColor: Color(0xFFF7FCF7),
    ),
    'salon-parlor': _ServiceStyle(
      icon: Icons.content_cut_rounded,
      gradient: [Color(0xFFC2185B), Color(0xFFF06292)],
      borderColor: Color(0xFFF6D4E1),
      surfaceColor: Color(0xFFFFF8FB),
    ),
  };

  static const _defaultStyle = _ServiceStyle(
    icon: Icons.home_repair_service_rounded,
    gradient: [Color(0xFF6A1B9A), Color(0xFF9575CD)],
    borderColor: Color(0xFFE3D8F2),
    surfaceColor: Color(0xFFFAF8FF),
  );

  _ServiceStyle _styleForSlug(String slug) {
    return _serviceStyles[slug] ?? _defaultStyle;
  }

  void _openService(BuildContext context, HomeService service) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => service.isCourier
            ? CourierBookingPage(service: service)
            : GeneralServicePage(service: service),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeServiceCubit, HomeServiceState>(
      builder: (context, state) {
        if (state is HomeServiceLoading) {
          return const _LoadingView();
        }

        if (state is HomeServiceError) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<HomeServiceCubit>().fetchServices(),
          );
        }

        if (state is HomeServiceLoaded) {
          return _ServicesView(
            services: state.services,
            styleForSlug: _styleForSlug,
            onServiceTap: (service) => _openService(context, service),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ServiceStyle {
  final IconData icon;
  final List<Color> gradient;
  final Color borderColor;
  final Color surfaceColor;

  const _ServiceStyle({
    required this.icon,
    required this.gradient,
    required this.borderColor,
    required this.surfaceColor,
  });
}

class _ServicesView extends StatefulWidget {
  final List<HomeService> services;
  final _ServiceStyle Function(String slug) styleForSlug;
  final void Function(HomeService service) onServiceTap;

  const _ServicesView({
    required this.services,
    required this.styleForSlug,
    required this.onServiceTap,
  });

  @override
  State<_ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<_ServicesView> {
  String _query = '';

  List<HomeService> get _filtered {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.services;
    return widget.services.where((service) {
      return service.name.toLowerCase().contains(query) ||
          service.displayDescription.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final services = _filtered;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 640
            ? 3
            : 2;

        final mainAxisExtent = constraints.maxWidth >= 640 ? 230.0 : 210.0;

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPaddingHorizontal,
            AppSpacing.md,
            AppSpacing.screenPaddingHorizontal,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.homeServices,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.black,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.homeServicesSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[700], height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  SvgPicture.asset(
                    'assets/illustrations/home_garden.svg',
                    height: 104,
                  ),
                ],
              ),
              if (widget.services.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                _buildSearchField(),
              ],
              const SizedBox(height: AppSpacing.md),
              if (widget.services.isEmpty)
                _EmptyView(subtitle: l10n.homeServicesSubtitle)
              else if (services.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(child: Text('No services found')),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisExtent: mainAxisExtent,
                  ),
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return _ServiceCard(
                      service: service,
                      style: widget.styleForSlug(service.slug),
                      onTap: () => widget.onServiceTap(service),
                    );
                  },
                ),
              if (widget.services.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                const _WhyChooseSection(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: takshSoftShadow,
      ),
      child: TextField(
        onChanged: (value) => setState(() => _query = value),
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: 'Search for services...',
          hintStyle: TextStyle(color: AppColors.grey500, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.grey700),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _WhyChooseSection extends StatelessWidget {
  const _WhyChooseSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Why Choose Taksh Services?',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _TrustItem(
              icon: Icons.verified_rounded,
              color: AppColors.secondaryGreen,
              label: 'Verified\nProfessionals',
            ),
            _TrustItem(
              icon: Icons.schedule_rounded,
              color: AppColors.primaryOrange,
              label: 'On-Time\nService',
            ),
            _TrustItem(
              icon: Icons.shield_rounded,
              color: Color(0xFF1976D2),
              label: 'Safe & Secure\nPayments',
            ),
          ],
        ),
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _TrustItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final HomeService service;
  final _ServiceStyle style;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final description = service.displayDescription;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: style.borderColor),
            boxShadow: takshSoftShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ServiceVisual(service: service, style: style),
                  const Spacer(),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: style.gradient.first.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: style.gradient.first,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                service.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  description.isNotEmpty ? description : service.category.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'From ₹${_formatPrice(service.basePrice)}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: style.gradient.first,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceVisual extends StatelessWidget {
  final HomeService service;
  final _ServiceStyle style;

  const _ServiceVisual({required this.service, required this.style});

  @override
  Widget build(BuildContext context) {
    final imageUrl = service.primaryImageUrl;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: style.surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => _ServiceIcon(style: style),
                errorWidget: (context, url, error) =>
                    _ServiceIcon(style: style),
              )
            : _ServiceIcon(style: style),
      ),
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  final _ServiceStyle style;

  const _ServiceIcon({required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: style.gradient),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(style.icon, color: Colors.white, size: 28),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String subtitle;

  const _EmptyView({required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE7D7)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4EB),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.design_services_rounded,
              color: AppColors.primaryOrange,
              size: 34,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingHorizontal,
        AppSpacing.md,
        AppSpacing.screenPaddingHorizontal,
        AppSpacing.lg,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          mainAxisExtent: 210,
        ),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 96,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 120,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 70,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 36,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.couldNotLoadServices,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(l10n.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatPrice(double value) {
  final roundedValue = value.truncateToDouble();
  if (value == roundedValue) {
    return value.toStringAsFixed(0);
  }

  return value.toStringAsFixed(2);
}
