import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_quote.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/home_service.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/create_courier_booking.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/get_courier_quote.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/cubit/home_service_cubit.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/cubit/home_service_state.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/pages/courier_history_page.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Courier booking form page with vibrant, responsive UI.
class CourierBookingPage extends StatelessWidget {
  final HomeService service;

  const CourierBookingPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeServiceCubit>(),
      child: _CourierBookingForm(service: service),
    );
  }
}

class _CourierBookingForm extends StatefulWidget {
  final HomeService service;

  const _CourierBookingForm({required this.service});

  @override
  State<_CourierBookingForm> createState() => _CourierBookingFormState();
}

class _CourierBookingFormState extends State<_CourierBookingForm> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // Customer details
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  // Address
  final _pickupAddressController = TextEditingController();
  final _pickupPincodeController = TextEditingController();
  final _deliveryNameController = TextEditingController();
  final _deliveryMobileController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _deliveryPincodeController = TextEditingController();
  final _productDetailsController = TextEditingController();
  final _packagingDetailsController = TextEditingController();

  // Parcel
  final _weightController = TextEditingController(); // in grams
  final _lengthController = TextEditingController();
  final _heightController = TextEditingController();
  final _widthController = TextEditingController();
  final _notesController = TextEditingController();

  String _dimensionUnit = 'cm';
  XFile? _productImage;

  // Delivery partner selection
  bool _showDeliveryPartners = false;
  int? _selectedPartnerId;
  double _comparedPrice = 0;
  CourierQuote? _quote;
  bool _loadingQuote = false;
  String? _quoteError;

  CourierQuoteOption? get _selectedPartner {
    final quote = _quote;
    if (quote == null) {
      return null;
    }

    for (final partner in quote.quotes) {
      if (partner.courierDeliveryPartnerId == _selectedPartnerId) {
        return partner;
      }
    }

    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _pickupAddressController.dispose();
    _pickupPincodeController.dispose();
    _deliveryNameController.dispose();
    _deliveryMobileController.dispose();
    _deliveryAddressController.dispose();
    _deliveryPincodeController.dispose();
    _productDetailsController.dispose();
    _packagingDetailsController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _heightController.dispose();
    _widthController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _checkAndComparePrice() {
    if (!_validateQuoteInputs()) return;

    final actualWeightGrams = double.parse(_weightController.text.trim());
    final dimensionLength = double.parse(_lengthController.text.trim());
    final dimensionHeight = double.parse(_heightController.text.trim());
    final dimensionWidth = double.parse(_widthController.text.trim());

    setState(() {
      _showDeliveryPartners = true;
      _selectedPartnerId = null;
      _comparedPrice = 0;
      _quote = null;
      _quoteError = null;
    });

    context.read<HomeServiceCubit>().fetchCourierQuote(
      GetCourierQuoteParams(
        weightGrams: actualWeightGrams,
        dimensionLength: dimensionLength,
        dimensionHeight: dimensionHeight,
        dimensionWidth: dimensionWidth,
        dimensionUnit: _dimensionUnit,
      ),
    );
  }

  bool _validateQuoteInputs() {
    final errors = <String?>[
      _validateRequiredNumber(label: 'Weight', value: _weightController.text),
      _validateRequiredNumber(label: 'Length', value: _lengthController.text),
      _validateRequiredNumber(label: 'Height', value: _heightController.text),
      _validateRequiredNumber(label: 'Width', value: _widthController.text),
    ];

    final errorMessage = errors.whereType<String>().cast<String?>().firstWhere(
      (message) => message != null,
      orElse: () => null,
    );

    if (errorMessage == null) {
      return true;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
    return false;
  }

  String? _validateRequiredNumber({
    required String label,
    required String value,
  }) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      return '$label is required to calculate a quote';
    }
    if (double.tryParse(normalizedValue) == null) {
      return 'Enter a valid number for $label';
    }

    return null;
  }

  void _selectPartner(CourierQuoteOption partner) {
    setState(() {
      _selectedPartnerId = partner.courierDeliveryPartnerId;
      _comparedPrice = partner.totalAmount;
    });
  }

  void _submit() {
    final selectedPartner = _selectedPartner;
    if (selectedPartner == null) return;
    if (!_formKey.currentState!.validate()) return;

    final actualWeightGrams = double.parse(_weightController.text.trim());

    final params = CreateCourierBookingParams(
      customerName: _nameController.text.trim(),
      customerMobile: _mobileController.text.trim(),
      pickupAddress: _pickupAddressController.text.trim(),
      pickupPincode: _pickupPincodeController.text.trim(),
      deliveryName: _deliveryNameController.text.trim(),
      deliveryMobile: _deliveryMobileController.text.trim(),
      deliveryAddress: _deliveryAddressController.text.trim(),
      deliveryPincode: _deliveryPincodeController.text.trim(),
      productDetails: _productDetailsController.text.trim(),
      packagingDetails: _packagingDetailsController.text.trim(),
      weightGrams: actualWeightGrams,
      dimensionLength: double.parse(_lengthController.text.trim()),
      dimensionHeight: double.parse(_heightController.text.trim()),
      dimensionWidth: double.parse(_widthController.text.trim()),
      dimensionUnit: _dimensionUnit,
      courierDeliveryPartnerId: selectedPartner.courierDeliveryPartnerId,
      customerNotes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      itemPhotoPath: _productImage?.path,
    );

    context.read<HomeServiceCubit>().submitCourierBooking(params);
  }

  String _formatAmount(double amount) {
    final roundedAmount = amount.truncateToDouble();
    if (amount == roundedAmount) {
      return amount.toStringAsFixed(0);
    }

    return amount.toStringAsFixed(2);
  }

  Widget _buildDeliveryPartnerSelector() {
    final quote = _quote;

    if (_loadingQuote) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Calculating quotes...',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_quoteError != null) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF1B5B5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Could not calculate quote',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _quoteError!,
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: _checkAndComparePrice,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (quote == null || quote.quotes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          'No quotes are available right now.',
          style: TextStyle(color: Colors.grey[700]),
        ),
      );
    }

    final partners = [...quote.quotes]
      ..sort(
        (firstPartner, secondPartner) =>
            firstPartner.totalAmount.compareTo(secondPartner.totalAmount),
      );

    return Column(
      children: [
        for (final partner in partners)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _selectPartner(partner),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _selectedPartnerId == partner.courierDeliveryPartnerId
                          ? const Color(0xFF2E7D32)
                          : Colors.grey[300]!,
                      width:
                          _selectedPartnerId == partner.courierDeliveryPartnerId
                          ? 1.5
                          : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                _selectedPartnerId ==
                                    partner.courierDeliveryPartnerId
                                ? const Color(0xFF2E7D32)
                                : Colors.grey[400]!,
                            width: 2,
                          ),
                          color:
                              _selectedPartnerId ==
                                  partner.courierDeliveryPartnerId
                              ? const Color(0xFF2E7D32)
                              : Colors.transparent,
                        ),
                        child:
                            _selectedPartnerId ==
                                partner.courierDeliveryPartnerId
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              partner.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color:
                                    _selectedPartnerId ==
                                        partner.courierDeliveryPartnerId
                                    ? const Color(0xFF2E7D32)
                                    : Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              partner.slug,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '₹${_formatAmount(partner.totalAmount)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color:
                              _selectedPartnerId ==
                                  partner.courierDeliveryPartnerId
                              ? const Color(0xFF2E7D32)
                              : AppColors.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Select Image Source',
                style: Theme.of(
                  ctx,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImageSourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    color: const Color(0xFF1976D2),
                    onTap: () => Navigator.pop(ctx, ImageSource.camera),
                  ),
                  _ImageSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    color: const Color(0xFF7B1FA2),
                    onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;
    final image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      setState(() => _productImage = image);
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
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
        borderSide: const BorderSide(
          color: AppColors.primaryOrange,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.service.name),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    CourierHistoryPage(serviceId: widget.service.id),
              ),
            ),
            icon: const Icon(Icons.history_rounded, size: 20),
            label: const Text('History'),
          ),
        ],
      ),
      body: BlocListener<HomeServiceCubit, HomeServiceState>(
        listener: (context, state) {
          if (state is HomeServiceCourierQuoteLoading) {
            setState(() {
              _loadingQuote = true;
              _quoteError = null;
            });
          } else if (state is HomeServiceCourierQuoteLoaded) {
            setState(() {
              _loadingQuote = false;
              _quoteError = null;
              _quote = state.quote;
              _selectedPartnerId = null;
              _comparedPrice = 0;
            });
          } else if (state is HomeServiceCourierQuoteError) {
            setState(() {
              _loadingQuote = false;
              _quoteError = state.message;
              _quote = null;
              _selectedPartnerId = null;
              _comparedPrice = 0;
            });
          } else if (state is HomeServiceCourierBookingSuccess) {
            _showSuccessDialog(context, state);
          } else if (state is HomeServiceCourierBookingError) {
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
              // ── Customer & Pickup Details ──
              _FormSection(
                title: l10n.customerAndPickupDetails,
                icon: Icons.assignment_ind_rounded,
                gradient: const [Color(0xFF5E35B1), Color(0xFFFF8F5E)],
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(
                      label: 'Customer Name',
                      hint: 'Enter full name',
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
                        return 'Enter valid 10-digit number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),
                  TextFormField(
                    controller: _pickupAddressController,
                    decoration: _inputDecoration(
                      label: l10n.pickupAddress,
                      hint: l10n.enterPickupAddress,
                      prefixIcon: Icons.home_outlined,
                    ),
                    maxLines: 2,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),
                  TextFormField(
                    controller: _pickupPincodeController,
                    decoration: _inputDecoration(
                      label: l10n.pickupPincode,
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

              // ── Delivery Section ──
              _FormSection(
                title: l10n.deliveryDetails,
                icon: Icons.local_shipping_rounded,
                gradient: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                children: [
                  TextFormField(
                    controller: _deliveryNameController,
                    decoration: _inputDecoration(
                      label: 'Delivery Contact Name',
                      hint: 'Enter receiver name',
                      prefixIcon: Icons.person_outline,
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),
                  TextFormField(
                    controller: _deliveryMobileController,
                    decoration: _inputDecoration(
                      label: 'Delivery Mobile Number',
                      hint: '10-digit mobile number',
                      prefixIcon: Icons.phone_outlined,
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (v.trim().length != 10) {
                        return 'Enter valid 10-digit number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),
                  TextFormField(
                    controller: _deliveryAddressController,
                    decoration: _inputDecoration(
                      label: 'Delivery Address',
                      hint: 'Enter full delivery address',
                      prefixIcon: Icons.flag_outlined,
                    ),
                    maxLines: 2,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),
                  TextFormField(
                    controller: _deliveryPincodeController,
                    decoration: _inputDecoration(
                      label: 'Delivery Pincode',
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

              // ── Product Details ──
              _FormSection(
                title: l10n.productDetails,
                icon: Icons.inventory_rounded,
                gradient: const [Color(0xFF00897B), Color(0xFF26A69A)],
                children: [
                  TextFormField(
                    controller: _productDetailsController,
                    decoration: _inputDecoration(
                      label: l10n.productDetails,
                      hint: l10n.enterProductDetails,
                      prefixIcon: Icons.description_outlined,
                    ),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),
                  TextFormField(
                    controller: _packagingDetailsController,
                    decoration: _inputDecoration(
                      label: l10n.packagingDetails,
                      hint: l10n.enterPackagingDetails,
                      prefixIcon: Icons.inventory_2_outlined,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Parcel Details ──
              _FormSection(
                title: l10n.parcelDetails,
                icon: Icons.inventory_2_rounded,
                gradient: const [Color(0xFF1976D2), Color(0xFF42A5F5)],
                children: [
                  TextFormField(
                    controller: _weightController,
                    decoration: _inputDecoration(
                      label: 'Weight (grams)',
                      hint: 'e.g. 500',
                      prefixIcon: Icons.scale_outlined,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (double.tryParse(v.trim()) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),

                  // Dimension unit toggle
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD0DCFF)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.straighten_rounded,
                          size: 18,
                          color: Color(0xFF1976D2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Dimensions:',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Row(
                            children: [
                              _UnitChip(
                                label: 'cm',
                                selected: _dimensionUnit == 'cm',
                                onTap: () =>
                                    setState(() => _dimensionUnit = 'cm'),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              _UnitChip(
                                label: 'inch',
                                selected: _dimensionUnit == 'inch',
                                onTap: () =>
                                    setState(() => _dimensionUnit = 'inch'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),

                  // L × H × W
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _lengthController,
                          decoration: _inputDecoration(
                            label: 'L ($_dimensionUnit)',
                            hint: 'Length',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _numberValidator,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '×',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          decoration: _inputDecoration(
                            label: 'H ($_dimensionUnit)',
                            hint: 'Height',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _numberValidator,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '×',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _widthController,
                          decoration: _inputDecoration(
                            label: 'W ($_dimensionUnit)',
                            hint: 'Width',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _numberValidator,
                        ),
                      ),
                    ],
                  ),

                  // ── Volumetric info hint ──
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Color(0xFFE65100),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _dimensionUnit == 'inch'
                                ? 'Inches will be converted to cm for volumetric calculation'
                                : 'Volumetric weight = (L×W×H) / 5000 kg → grams',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFE65100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Additional Info ──
              _FormSection(
                title: l10n.additionalInfo,
                icon: Icons.note_alt_rounded,
                gradient: const [Color(0xFFC2185B), Color(0xFFEC407A)],
                children: [
                  TextFormField(
                    controller: _notesController,
                    decoration: _inputDecoration(
                      label: 'Customer Notes (optional)',
                      hint: 'e.g. Handle with care',
                      prefixIcon: Icons.notes_outlined,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.formFieldGap),
                  _ImagePickerCard(
                    image: _productImage,
                    onTap: _pickImage,
                    onRemove: () => setState(() => _productImage = null),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Check and Compare Price Button ──
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFFA726)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _checkAndComparePrice,
                  icon: const Icon(Icons.compare_arrows_rounded, size: 22),
                  label: const Text(
                    'Compare Delivery Partners',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              // ── Weight Comparison (shown after check) ──
              if (_showDeliveryPartners) ...[
                const SizedBox(height: AppSpacing.md),
                _buildWeightComparison(),
                const SizedBox(height: AppSpacing.md),

                // ── Delivery Partners ──
                _FormSection(
                  title: 'Select Delivery Partner',
                  icon: Icons.local_shipping_rounded,
                  gradient: const [Color(0xFF00695C), Color(0xFF26A69A)],
                  children: [_buildDeliveryPartnerSelector()],
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Pay Button ──
                if (_selectedPartner != null)
                  BlocBuilder<HomeServiceCubit, HomeServiceState>(
                    builder: (context, state) {
                      final loading =
                          state is HomeServiceCourierBookingSubmitting;
                      return Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF2E7D32,
                              ).withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: loading ? null : _submit,
                          icon: loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.inventory_rounded, size: 22),
                          label: Text(
                            loading
                                ? 'Processing...'
                                : 'Create Booking • ₹${_formatAmount(_comparedPrice)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightComparison() {
    final quote = _quote;
    if (quote == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0DCFF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_rounded,
                size: 18,
                color: Color(0xFF1976D2),
              ),
              const SizedBox(width: 8),
              Text(
                'Weight Comparison',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _WeightRow(
            label: 'Actual Weight',
            value: '${quote.actualWeightGrams} g',
            isHigher: !quote.isVolumetricChargeableWeight,
          ),
          const SizedBox(height: 6),
          _WeightRow(
            label: 'Volumetric Weight',
            value: '${quote.volumetricWeightGrams} g',
            isHigher: quote.isVolumetricChargeableWeight,
          ),
          const Divider(height: 16),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: Color(0xFF2E7D32),
              ),
              const SizedBox(width: 6),
              Text(
                'Chargeable: ${quote.chargeableWeightGrams} g',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const Spacer(),
              Text(
                quote.isVolumetricChargeableWeight
                    ? '(Volumetric)'
                    : '(Actual)',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _numberValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (double.tryParse(v.trim()) == null) return 'Invalid';
    return null;
  }

  void _showSuccessDialog(
    BuildContext context,
    HomeServiceCourierBookingSuccess state,
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
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
                'Courier Booking Created',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Booking ${booking.bookingNumber} has been created successfully.',
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
                      AppColors.primaryOrange.withValues(alpha: 0.08),
                      AppColors.primaryOrange.withValues(alpha: 0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryOrange.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BookingInfoRow(
                      label: 'Booking Number',
                      value: booking.bookingNumber,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _BookingInfoRow(
                      label: 'Delivery Partner',
                      value: booking.partnerName,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _BookingInfoRow(
                      label: 'Chargeable Weight',
                      value:
                          '${booking.chargeableWeightGrams} g (${booking.isVolumetricChargeableWeight ? 'Volumetric' : 'Actual'})',
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _BookingInfoRow(
                      label: 'Amount',
                      value: '₹${_formatAmount(booking.totalAmount)}',
                      highlightValue: true,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _StatusChip(
                          label: booking.status.toUpperCase(),
                          backgroundColor: const Color(0xFFFFF8E1),
                          textColor: const Color(0xFFF57F17),
                        ),
                        _StatusChip(
                          label:
                              'PAYMENT ${booking.paymentStatus.toUpperCase()}',
                          backgroundColor: const Color(0xFFE8F5E9),
                          textColor: const Color(0xFF2E7D32),
                        ),
                      ],
                    ),
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
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFFFA726)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CourierHistoryPage(
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
          // ── Section header with gradient accent ──
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
          // ── Form fields ──
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// ─── Unit Chip ─────────────────────────────────────────────────────────────
class _UnitChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _UnitChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                )
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: selected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[700],
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ─── Image Picker Card ─────────────────────────────────────────────────────
class _ImagePickerCard extends StatelessWidget {
  final XFile? image;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _ImagePickerCard({
    this.image,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Image.file(
              File(image!.path),
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            // Gradient overlay at top-right for remove button
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.black45, Colors.transparent],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  bottom: 16,
                  top: 6,
                  right: 6,
                ),
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            // "Change" label
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Tap to change image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            // Tap to change
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FD),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 24,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Add Item Photo (optional)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Image Source Option (for bottom sheet) ─────────────────────────────────
class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ImageSourceOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlightValue;

  const _BookingInfoRow({
    required this.label,
    required this.value,
    this.highlightValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: highlightValue ? AppColors.primaryOrange : AppColors.black,
              fontSize: highlightValue ? 16 : 14,
              fontWeight: highlightValue ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _StatusChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

// ─── Weight Row ────────────────────────────────────────────────────────────
class _WeightRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHigher;

  const _WeightRow({
    required this.label,
    required this.value,
    required this.isHigher,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isHigher ? const Color(0xFFE8F5E9) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: isHigher ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
              color: isHigher ? const Color(0xFF2E7D32) : Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
