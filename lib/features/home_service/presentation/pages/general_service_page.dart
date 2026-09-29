import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/home_service.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/create_general_service_booking.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/cubit/home_service_cubit.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/cubit/home_service_state.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/pages/service_history_page.dart';

/// Booking form for general home services (Electrician, Plumber, Salon)
/// with vibrant, wallet-inspired UI.
class GeneralServicePage extends StatelessWidget {
  final HomeService service;

  const GeneralServicePage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeServiceCubit>(),
      child: _GeneralServiceForm(service: service),
    );
  }
}

// ─── Per-service visual theming ────────────────────────────────────────────
class _ServiceTheme {
  final IconData icon;
  final List<Color> gradient;
  final Color bgLight;
  final Color borderColor;

  const _ServiceTheme({
    required this.icon,
    required this.gradient,
    required this.bgLight,
    required this.borderColor,
  });
}

const _serviceThemes = <String, _ServiceTheme>{
  'electrician': _ServiceTheme(
    icon: Icons.electrical_services_rounded,
    gradient: [Color(0xFF1976D2), Color(0xFF42A5F5)],
    bgLight: Color(0xFFE8F4FD),
    borderColor: Color(0xFFB3D9F7),
  ),
  'plumber': _ServiceTheme(
    icon: Icons.plumbing_rounded,
    gradient: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    bgLight: Color(0xFFE8F5E9),
    borderColor: Color(0xFFB9DFB9),
  ),
  'salon-parlor': _ServiceTheme(
    icon: Icons.content_cut_rounded,
    gradient: [Color(0xFFC2185B), Color(0xFFEC407A)],
    bgLight: Color(0xFFFCE4EC),
    borderColor: Color(0xFFF8BBD0),
  ),
};

const _defaultTheme = _ServiceTheme(
  icon: Icons.home_repair_service_rounded,
  gradient: [Color(0xFFFF6B35), Color(0xFFFF8F5E)],
  bgLight: Color(0xFFFFF3ED),
  borderColor: Color(0xFFFFD4BC),
);

class _GeneralServiceForm extends StatefulWidget {
  final HomeService service;

  const _GeneralServiceForm({required this.service});

  @override
  State<_GeneralServiceForm> createState() => _GeneralServiceFormState();
}

class _GeneralServiceFormState extends State<_GeneralServiceForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  late final _ServiceTheme _theme;

  @override
  void initState() {
    super.initState();
    _theme = _serviceThemes[widget.service.slug] ?? _defaultTheme;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final params = CreateGeneralServiceBookingParams(
      serviceSlug: widget.service.slug,
      customerName: _nameController.text.trim(),
      customerMobile: _mobileController.text.trim(),
      fullAddress: _addressController.text.trim(),
      pincode: _pincodeController.text.trim(),
      serviceDescription: _descriptionController.text.trim(),
      customerNotes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
    );

    context.read<HomeServiceCubit>().submitGeneralServiceBooking(params);
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    IconData? prefixIcon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
      alignLabelWithHint: alignLabelWithHint,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _theme.gradient.first, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.service.name),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    ServiceHistoryPage(serviceId: widget.service.id),
              ),
            ),
            icon: const Icon(Icons.history_rounded, size: 20),
            label: const Text('History'),
          ),
        ],
      ),
      body: BlocListener<HomeServiceCubit, HomeServiceState>(
        listener: (context, state) {
          if (state is HomeServiceGeneralBookingSuccess) {
            _showSuccessDialog(context, state);
          } else if (state is HomeServiceGeneralBookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
            children: [
              // ── Customer Details Section ──
              _FormSection(
                title: 'Customer Details',
                icon: Icons.person_rounded,
                gradient: _theme.gradient,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(
                      label: 'Customer Name',
                      hint: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),
                  TextFormField(
                    controller: _mobileController,
                    decoration: _inputDecoration(
                      label: 'Mobile Number',
                      hint: '10-digit mobile number',
                      prefixIcon: Icons.phone_outlined,
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (v.trim().length != 10) {
                        return 'Enter a valid 10-digit mobile number';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Address Section ──
              _FormSection(
                title: 'Your Address',
                icon: Icons.location_on_rounded,
                gradient: _theme.gradient,
                children: [
                  TextFormField(
                    controller: _addressController,
                    decoration: _inputDecoration(
                      label: 'Full Address',
                      hint: 'Enter your complete address',
                      prefixIcon: Icons.home_outlined,
                    ),
                    maxLines: 3,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),
                  TextFormField(
                    controller: _pincodeController,
                    decoration: _inputDecoration(
                      label: 'Pincode',
                      hint: '6-digit pincode',
                      prefixIcon: Icons.pin_drop_outlined,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (v.trim().length != 6) {
                        return 'Enter a valid 6-digit pincode';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Service Description Section ──
              _FormSection(
                title: 'Service Description',
                icon: Icons.description_rounded,
                gradient: _theme.gradient,
                children: [
                  TextFormField(
                    controller: _descriptionController,
                    decoration: _inputDecoration(
                      label: 'Describe the service you need',
                      hint: 'e.g. Need to fix a leaking pipe in the kitchen',
                      prefixIcon: Icons.notes_outlined,
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),
                  TextFormField(
                    controller: _notesController,
                    decoration: _inputDecoration(
                      label: 'Additional Notes (Optional)',
                      hint: 'Any extra instructions for the service provider',
                      prefixIcon: Icons.sticky_note_2_outlined,
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Submit Button ──
              BlocBuilder<HomeServiceCubit, HomeServiceState>(
                builder: (context, state) {
                  final loading = state is HomeServiceGeneralBookingSubmitting;
                  return Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _theme.gradient),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _theme.gradient.first.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_rounded, size: 22),
                                SizedBox(width: 8),
                                Text(
                                  'Book Service',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(
    BuildContext context,
    HomeServiceGeneralBookingSuccess state,
  ) {
    final booking = state.booking;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Success icon ──
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: _theme.gradient),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _theme.gradient.first.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Booking Submitted',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                booking.message,
                style: TextStyle(color: Colors.grey[600], height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Booking summary card ──
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _theme.gradient.first.withValues(alpha: 0.08),
                      _theme.gradient.first.withValues(alpha: 0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _theme.gradient.first.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Number',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.bookingNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: _theme.gradient.first,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFFE082)),
                          ),
                          child: Text(
                            booking.status.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF57F17),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_notesController.text.trim().isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Notes',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _notesController.text.trim(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Action buttons ──
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: _theme.gradient),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ServiceHistoryPage(
                                serviceId: widget.service.id,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'View History',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Form Section Card ─────────────────────────────────────────────────────
class _FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final List<Widget> children;

  const _FormSection({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gradient-accented header ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradient.first.withValues(alpha: 0.08),
                  gradient.last.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              border: Border(
                bottom: BorderSide(
                  color: gradient.first.withValues(alpha: 0.12),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.first.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
