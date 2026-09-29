import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/utils/validators.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';
import 'package:taksh_e_commerce/features/address/presentation/pages/map_picker_page.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/vendor_join_request.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/vendor_bloc.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/vendor_event.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/vendor_state.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Page for joining as a vendor
class VendorJoinPage extends StatelessWidget {
  const VendorJoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VendorBloc>(),
      child: const _VendorJoinView(),
    );
  }
}

class _VendorJoinView extends StatefulWidget {
  const _VendorJoinView();

  @override
  State<_VendorJoinView> createState() => _VendorJoinViewState();
}

class _VendorJoinViewState extends State<_VendorJoinView> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // Owner Details
  final _ownerNameController = TextEditingController();
  final _ownerAddressController = TextEditingController();
  final _ownerPincodeController = TextEditingController();
  final _ownerMobileController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  Location? _ownerLocation;
  XFile? _ownerImage;

  // Shop Details
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _shopPincodeController = TextEditingController();
  Location? _shopLocation;
  final List<XFile> _shopImages = [];

  /// Backend expects numeric state/city IDs (no picker API yet).
  /// Same placeholder approach as address registration.
  static const int _defaultStateId = 1;
  static const int _defaultCityId = 1;

  // Documents — saved from bottom sheets
  String? _aadharNumber;
  XFile? _aadharDocument;
  String? _panNumber;
  XFile? _panDocument;
  String? _bankAccountNumber;
  String? _bankIfscCode;
  String? _bankName;
  XFile? _bankDocument;
  String? _gstNumber;
  XFile? _gstDocument;
  XFile? _nonGstCertificate;
  XFile? _msmeCertificate;
  XFile? _fssaiCertificate;
  XFile? _shopAgreement;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _ownerNameController.dispose();
    _ownerAddressController.dispose();
    _ownerPincodeController.dispose();
    _ownerMobileController.dispose();
    _ownerEmailController.dispose();
    _shopNameController.dispose();
    _shopAddressController.dispose();
    _shopPincodeController.dispose();
    super.dispose();
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  Future<void> _pickImage(List<XFile> list, {required int maxCount}) async {
    if (list.length >= maxCount) return;
    final source = await _showImageSourceDialog();
    if (source == null) return;
    final file = await _picker.pickImage(source: source, imageQuality: 80);
    if (file != null) setState(() => list.add(file));
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<XFile?> _pickDocument() async {
    final source = await _showImageSourceDialog();
    if (source == null) return null;
    return _picker.pickImage(source: source, imageQuality: 85);
  }

  Future<void> _pickLocation({
    required Location? current,
    required void Function(Location) onPicked,
  }) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MapPickerPage(initialLocation: current),
      ),
    );
    if (result != null && result is Map) {
      final location = result['location'] as Location?;
      if (location != null) {
        setState(() => onPicked(location));
      }
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final l10n = AppLocalizations.of(context)!;

    if (_ownerLocation == null) {
      _showError(l10n.vendorOwnerLocationRequired);
      return;
    }
    if (_ownerImage == null) {
      _showError(l10n.vendorOwnerImageRequired);
      return;
    }
    if (_shopLocation == null) {
      _showError(l10n.vendorShopLocationRequired);
      return;
    }
    if (_shopImages.isEmpty) {
      _showError(l10n.vendorShopImagesRequired);
      return;
    }
    if (_aadharNumber == null ||
        _aadharNumber!.isEmpty ||
        _aadharDocument == null) {
      _showError(l10n.vendorAadhaarFileRequired);
      return;
    }
    if (_panNumber == null || _panNumber!.isEmpty || _panDocument == null) {
      _showError(l10n.vendorPanFileRequired);
      return;
    }
    if (_bankAccountNumber == null ||
        _bankIfscCode == null ||
        _bankName == null ||
        _bankDocument == null) {
      _showError(l10n.vendorBankFileRequired);
      return;
    }
    // API: gst_file required when non_gst_file missing, and vice versa.
    if (_gstDocument == null && _nonGstCertificate == null) {
      _showError(l10n.vendorGstOrNonGstRequired);
      return;
    }
    if (_fssaiCertificate == null) {
      _showError(l10n.vendorFssaiFileRequired);
      return;
    }

    final shopName = _shopNameController.text.trim();
    final shopAddress = _shopAddressController.text.trim();
    final shopPincode = _shopPincodeController.text.trim();
    final ownerName = _ownerNameController.text.trim();
    final ownerAddress = _ownerAddressController.text.trim();
    final ownerPincode = _ownerPincodeController.text.trim();

    // vendor_name / address / pincode map from shop (matches Postman payload).
    final request = VendorJoinRequest(
      vendorName: shopName,
      address: shopAddress,
      pincode: shopPincode,
      stateId: _defaultStateId,
      cityId: _defaultCityId,
      shopName: shopName,
      shopAddress: shopAddress,
      shopPincode: shopPincode,
      shopLatitude: _shopLocation?.latitude,
      shopLongitude: _shopLocation?.longitude,
      shopImagePaths: _shopImages.map((f) => f.path).toList(),
      ownerName: ownerName,
      ownerAddress: ownerAddress,
      ownerPincode: ownerPincode,
      ownerLatitude: _ownerLocation?.latitude,
      ownerLongitude: _ownerLocation?.longitude,
      mobileNumber: _ownerMobileController.text.trim(),
      email: _ownerEmailController.text.trim(),
      ownerImagePath: _ownerImage?.path,
      aadhaarNumber: _aadharNumber!,
      aadhaarFilePath: _aadharDocument?.path,
      panNumber: _panNumber,
      panFilePath: _panDocument?.path,
      bankAccountNumber: _bankAccountNumber,
      ifscCode: _bankIfscCode,
      bankName: _bankName,
      bankFilePath: _bankDocument?.path,
      gstNumber: _gstNumber,
      gstFilePath: _gstDocument?.path,
      nonGstFilePath: _nonGstCertificate?.path,
      msmeFilePath: _msmeCertificate?.path,
      fssaiFilePath: _fssaiCertificate?.path,
      shopAgreementFilePath: _shopAgreement?.path,
    );

    context.read<VendorBloc>().add(
      VendorJoinRequestSubmitted(request: request),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  // ── document status helpers ───────────────────────────────────────────────

  bool get _aadharSaved => _aadharNumber != null && _aadharDocument != null;
  bool get _panSaved => _panNumber != null && _panDocument != null;
  bool get _bankSaved =>
      _bankAccountNumber != null &&
      _bankIfscCode != null &&
      _bankName != null &&
      _bankDocument != null;
  bool get _gstSaved =>
      (_gstNumber != null &&
          _gstNumber!.isNotEmpty &&
          _gstDocument != null) ||
      _nonGstCertificate != null;

  // ══ BUILD ══════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<VendorBloc, VendorState>(
      listener: (context, state) {
        if (state is VendorLoading) {
          setState(() => _isSubmitting = true);
        } else if (state is VendorJoinRequestSuccess) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.vendorJoinSuccess),
              backgroundColor: AppColors.secondaryGreen,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is VendorError) {
          setState(() => _isSubmitting = false);
          _showError(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.joinAsVendorTitle,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info card
                _buildInfoCard(l10n),
                const SizedBox(height: 24),

                // ── Owner Details ────────────────────────────────────────────
                _buildSectionHeader(
                  title: '${l10n.vendorOwnerDetails} *',
                  subtitle: l10n.vendorOwnerDetailsSubtitle,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: l10n.vendorOwnerName,
                  hint: l10n.vendorOwnerNameHint,
                  controller: _ownerNameController,
                  isRequired: true,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.vendorOwnerNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: l10n.vendorOwnerAddress,
                  hint: l10n.vendorOwnerAddressHint,
                  controller: _ownerAddressController,
                  isRequired: true,
                  maxLines: 3,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.vendorOwnerAddressRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: l10n.vendorOwnerPincode,
                  hint: l10n.vendorOwnerPincodeHint,
                  controller: _ownerPincodeController,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.vendorOwnerPincodeRequired;
                    }
                    if (!RegExp(r'^\d{6}$').hasMatch(v.trim())) {
                      return AppLocalizations.of(context)!.pincodeInvalidLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Owner Location picker
                _buildLocationRow(
                  label: l10n.vendorOwnerLocation,
                  location: _ownerLocation,
                  onTap: () => _pickLocation(
                    current: _ownerLocation,
                    onPicked: (loc) => _ownerLocation = loc,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: l10n.vendorMobileNumber,
                  hint: l10n.vendorMobileNumberHint,
                  controller: _ownerMobileController,
                  isRequired: true,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.vendorMobileNumberRequired;
                    }
                    return Validators.getPhoneError(context, v.trim());
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: l10n.vendorEmailId,
                  hint: l10n.vendorEmailIdHint,
                  controller: _ownerEmailController,
                  isRequired: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.vendorEmailRequired;
                    }
                    return Validators.getEmailError(context, v.trim());
                  },
                ),
                const SizedBox(height: 16),

                // Owner Image (single)
                _buildFileUploadSection(
                  label: l10n.vendorOwnerImage,
                  subtitle: l10n.vendorOwnerImageSubtitle,
                  file: _ownerImage,
                  onTap: () async {
                    final file = await _pickDocument();
                    if (file != null) setState(() => _ownerImage = file);
                  },
                  onRemove: () => setState(() => _ownerImage = null),
                  uploadLabel: l10n.vendorUploadDocument,
                  uploadHint: l10n.vendorUploadDocumentHint,
                ),
                const SizedBox(height: 32),

                // ── Shop Details ────────────────────────────────────────────
                _buildSectionHeader(
                  title: '${l10n.vendorShopDetails} *',
                  subtitle: l10n.vendorShopDetailsSubtitle,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: l10n.vendorShopName,
                  hint: l10n.vendorShopNameHint,
                  controller: _shopNameController,
                  isRequired: true,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.vendorShopNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: l10n.vendorShopAddress,
                  hint: l10n.vendorShopAddressHint,
                  controller: _shopAddressController,
                  isRequired: true,
                  maxLines: 3,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.vendorShopAddressRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: l10n.vendorShopPincode,
                  hint: l10n.vendorShopPincodeHint,
                  controller: _shopPincodeController,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.vendorShopPincodeRequired;
                    }
                    if (!RegExp(r'^\d{6}$').hasMatch(v.trim())) {
                      return AppLocalizations.of(context)!.pincodeInvalidLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Shop Location picker
                _buildLocationRow(
                  label: l10n.vendorShopLocation,
                  location: _shopLocation,
                  onTap: () => _pickLocation(
                    current: _shopLocation,
                    onPicked: (loc) => _shopLocation = loc,
                  ),
                ),
                const SizedBox(height: 16),

                // Shop Images
                _buildImageSection(
                  label: l10n.vendorShopImages,
                  subtitle: l10n.vendorShopImagesSubtitle,
                  images: _shopImages,
                  maxCount: 5,
                  addLabel: l10n.vendorAddImage,
                  onAdd: () => _pickImage(_shopImages, maxCount: 5),
                  onRemove: (i) => setState(() => _shopImages.removeAt(i)),
                ),
                const SizedBox(height: 32),

                // ── Documents ────────────────────────────────────────────────
                _buildSectionHeader(
                  title: '${l10n.vendorDocuments} *',
                  subtitle: l10n.vendorDocumentsSubtitle,
                ),
                const SizedBox(height: 16),

                // Document rows
                _buildDocumentRow(
                  icon: Icons.badge_outlined,
                  title: l10n.vendorAadharCard,
                  isSaved: _aadharSaved,
                  onTap: () => _showAadharSheet(l10n),
                ),
                const SizedBox(height: 12),
                _buildDocumentRow(
                  icon: Icons.credit_card_outlined,
                  title: l10n.vendorPanCard,
                  isSaved: _panSaved,
                  onTap: () => _showPanSheet(l10n),
                ),
                const SizedBox(height: 12),
                _buildDocumentRow(
                  icon: Icons.account_balance_outlined,
                  title: l10n.vendorBankAccount,
                  isSaved: _bankSaved,
                  onTap: () => _showBankSheet(l10n),
                ),
                const SizedBox(height: 12),
                _buildDocumentRow(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.vendorGstNumber,
                  isSaved: _gstSaved,
                  onTap: () => _showGstSheet(l10n),
                ),
                const SizedBox(height: 24),

                // Non-GST Certificate
                _buildFileUploadSection(
                  label: l10n.vendorNonGstCertificate,
                  subtitle: l10n.vendorNonGstCertificateSubtitle,
                  file: _nonGstCertificate,
                  onTap: () async {
                    final file = await _pickDocument();
                    if (file != null) setState(() => _nonGstCertificate = file);
                  },
                  onRemove: () => setState(() => _nonGstCertificate = null),
                  uploadLabel: l10n.vendorUploadDocument,
                  uploadHint: l10n.vendorUploadDocumentHint,
                ),
                const SizedBox(height: 16),

                // MSME Certificate
                _buildFileUploadSection(
                  label: l10n.vendorMsmeCertificate,
                  subtitle: l10n.vendorMsmeCertificateSubtitle,
                  file: _msmeCertificate,
                  onTap: () async {
                    final file = await _pickDocument();
                    if (file != null) setState(() => _msmeCertificate = file);
                  },
                  onRemove: () => setState(() => _msmeCertificate = null),
                  uploadLabel: l10n.vendorUploadDocument,
                  uploadHint: l10n.vendorUploadDocumentHint,
                ),
                const SizedBox(height: 16),

                // FSSAI Certificate
                _buildFileUploadSection(
                  label: l10n.vendorFssaiCertificate,
                  subtitle: l10n.vendorFssaiCertificateSubtitle,
                  file: _fssaiCertificate,
                  onTap: () async {
                    final file = await _pickDocument();
                    if (file != null) setState(() => _fssaiCertificate = file);
                  },
                  onRemove: () => setState(() => _fssaiCertificate = null),
                  uploadLabel: l10n.vendorUploadDocument,
                  uploadHint: l10n.vendorUploadDocumentHint,
                ),
                const SizedBox(height: 16),

                // Shop Agreement
                _buildFileUploadSection(
                  label: l10n.vendorShopAgreement,
                  subtitle: l10n.vendorShopAgreementSubtitle,
                  file: _shopAgreement,
                  onTap: () async {
                    final file = await _pickDocument();
                    if (file != null) setState(() => _shopAgreement = file);
                  },
                  onRemove: () => setState(() => _shopAgreement = null),
                  uploadLabel: l10n.vendorUploadDocument,
                  uploadHint: l10n.vendorUploadDocumentHint,
                ),
                const SizedBox(height: 32),

                // Submit button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.primaryOrange
                          .withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            l10n.vendorSubmitApplication,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══ BOTTOM SHEETS ══════════════════════════════════════════════════════════

  void _showAadharSheet(AppLocalizations l10n) {
    final numberCtrl = TextEditingController(text: _aadharNumber ?? '');
    XFile? docFile = _aadharDocument;
    final sheetFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: sheetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSheetHeader(
                  icon: Icons.badge_outlined,
                  title: l10n.vendorAadharDetails,
                ),
                const SizedBox(height: 20),
                _buildSheetTextField(
                  label: l10n.vendorAadharNumber,
                  hint: l10n.vendorAadharNumberHint,
                  controller: numberCtrl,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Aadhar number is required';
                    if (!RegExp(r'^\d{12}$').hasMatch(v.trim())) {
                      return 'Enter a valid 12-digit Aadhar number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.vendorAadharDocument,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSheetFileUpload(
                  file: docFile,
                  uploadLabel: l10n.vendorUploadDocument,
                  uploadHint: l10n.vendorUploadDocumentHint,
                  onTap: () async {
                    final f = await _pickDocument();
                    if (f != null) setSheet(() => docFile = f);
                  },
                  onRemove: () => setSheet(() => docFile = null),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (sheetFormKey.currentState?.validate() != true) return;
                      if (docFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.vendorAadhaarFileRequired),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }
                      setState(() {
                        _aadharNumber = numberCtrl.text.trim();
                        _aadharDocument = docFile;
                      });
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.vendorSaveAndVerify,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPanSheet(AppLocalizations l10n) {
    final numberCtrl = TextEditingController(text: _panNumber ?? '');
    XFile? docFile = _panDocument;
    final sheetFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: sheetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSheetHeader(
                  icon: Icons.credit_card_outlined,
                  title: l10n.vendorPanDetails,
                ),
                const SizedBox(height: 20),
                _buildSheetTextField(
                  label: l10n.vendorPanCardNumber,
                  hint: l10n.vendorPanCardNumberHint,
                  controller: numberCtrl,
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'PAN number is required';
                    if (!RegExp(
                      r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                    ).hasMatch(v.trim().toUpperCase())) {
                      return 'Enter a valid PAN card number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.vendorPanDocument,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSheetFileUpload(
                  file: docFile,
                  uploadLabel: l10n.vendorUploadDocument,
                  uploadHint: l10n.vendorUploadDocumentHint,
                  onTap: () async {
                    final f = await _pickDocument();
                    if (f != null) setSheet(() => docFile = f);
                  },
                  onRemove: () => setSheet(() => docFile = null),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (sheetFormKey.currentState?.validate() != true) return;
                      if (docFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.vendorPanFileRequired),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }
                      setState(() {
                        _panNumber = numberCtrl.text.trim().toUpperCase();
                        _panDocument = docFile;
                      });
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.vendorSaveAndVerify,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBankSheet(AppLocalizations l10n) {
    final accountCtrl = TextEditingController(text: _bankAccountNumber ?? '');
    final ifscCtrl = TextEditingController(text: _bankIfscCode ?? '');
    final bankNameCtrl = TextEditingController(text: _bankName ?? '');
    XFile? docFile = _bankDocument;
    final sheetFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: sheetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSheetHeader(
                  icon: Icons.account_balance_outlined,
                  title: l10n.vendorBankDetails,
                ),
                const SizedBox(height: 20),
                _buildSheetTextField(
                  label: l10n.vendorAccountNumber,
                  hint: l10n.vendorAccountNumberHint,
                  controller: accountCtrl,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Account number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _buildSheetTextField(
                  label: l10n.vendorIfscCode,
                  hint: l10n.vendorIfscCodeHint,
                  controller: ifscCtrl,
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'IFSC code is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _buildSheetTextField(
                  label: l10n.vendorBankName,
                  hint: l10n.vendorBankNameHint,
                  controller: bankNameCtrl,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Bank name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.vendorUploadBankProof,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  l10n.vendorUploadBankProofSubtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.vendorBankDocument,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSheetFileUpload(
                  file: docFile,
                  uploadLabel: l10n.vendorUploadDocument,
                  uploadHint: l10n.vendorUploadDocumentHint,
                  onTap: () async {
                    final f = await _pickDocument();
                    if (f != null) setSheet(() => docFile = f);
                  },
                  onRemove: () => setSheet(() => docFile = null),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (sheetFormKey.currentState?.validate() != true) return;
                      if (docFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.vendorBankFileRequired),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }
                      setState(() {
                        _bankAccountNumber = accountCtrl.text.trim();
                        _bankIfscCode = ifscCtrl.text.trim().toUpperCase();
                        _bankName = bankNameCtrl.text.trim();
                        _bankDocument = docFile;
                      });
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.vendorSaveAndVerify,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGstSheet(AppLocalizations l10n) {
    final numberCtrl = TextEditingController(text: _gstNumber ?? '');
    XFile? docFile = _gstDocument;
    final sheetFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: sheetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSheetHeader(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.vendorGstDetails,
                ),
                const SizedBox(height: 20),
                _buildSheetTextField(
                  label: l10n.vendorGstNumberLabel,
                  hint: l10n.vendorGstNumberHint,
                  controller: numberCtrl,
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'GST number is required';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.vendorGstDocument,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSheetFileUpload(
                  file: docFile,
                  uploadLabel: l10n.vendorUploadDocument,
                  uploadHint: l10n.vendorUploadDocumentHint,
                  onTap: () async {
                    final f = await _pickDocument();
                    if (f != null) setSheet(() => docFile = f);
                  },
                  onRemove: () => setSheet(() => docFile = null),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (sheetFormKey.currentState?.validate() != true) return;
                      if (docFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.vendorGstFileRequired),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }
                      setState(() {
                        _gstNumber = numberCtrl.text.trim().toUpperCase();
                        _gstDocument = docFile;
                      });
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.vendorSaveAndVerify,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══ WIDGET BUILDERS ════════════════════════════════════════════════════════

  Widget _buildInfoCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryOrange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primaryOrange, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.vendorFillDetails,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryOrange.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool isRequired = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '$label *' : label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction ?? TextInputAction.next,
          validator: validator,
          maxLines: maxLines,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primaryOrange,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow({
    required String label,
    required Location? location,
    required VoidCallback onTap,
  }) {
    final hasLocation = location != null;
    final displayText = hasLocation
        ? (location.formattedAddress ??
              '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}')
        : AppLocalizations.of(context)!.vendorPickLocation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasLocation
                    ? AppColors.primaryOrange.withOpacity(0.5)
                    : Theme.of(context).dividerColor,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: hasLocation
                      ? AppColors.primaryOrange
                      : Theme.of(context).iconTheme.color,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 14,
                      color: hasLocation
                          ? Theme.of(context).textTheme.bodyMedium?.color
                          : Theme.of(context).hintColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).iconTheme.color,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection({
    required String label,
    required String subtitle,
    required List<XFile> images,
    required int maxCount,
    required String addLabel,
    required VoidCallback onAdd,
    required void Function(int) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // Existing images
            ...images.asMap().entries.map((entry) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(entry.value.path),
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: GestureDetector(
                      onTap: () => onRemove(entry.key),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            // Add button
            if (images.length < maxCount)
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primaryOrange.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: AppColors.primaryOrange,
                        size: 26,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        addLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentRow({
    required IconData icon,
    required String title,
    required bool isSaved,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSaved
                ? AppColors.secondaryGreen.withOpacity(0.5)
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primaryOrange, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSaved)
              Icon(
                Icons.check_circle,
                color: AppColors.secondaryGreen,
                size: 20,
              )
            else
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).iconTheme.color,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileUploadSection({
    required String label,
    required String subtitle,
    required XFile? file,
    required VoidCallback onTap,
    required VoidCallback onRemove,
    required String uploadLabel,
    required String uploadHint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 8),
        _buildSheetFileUpload(
          file: file,
          uploadLabel: uploadLabel,
          uploadHint: uploadHint,
          onTap: onTap,
          onRemove: onRemove,
        ),
      ],
    );
  }

  // ── Sheet helpers ─────────────────────────────────────────────────────────

  Widget _buildSheetHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryOrange, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildSheetTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      validator: validator,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSheetFileUpload({
    required XFile? file,
    required String uploadLabel,
    required String uploadHint,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    if (file != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.secondaryGreen.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondaryGreen.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.secondaryGreen, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                file.name,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.close, color: AppColors.error, size: 20),
            ),
          ],
        ),
      );
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.cloud_upload_outlined,
              color: AppColors.primaryOrange,
              size: 28,
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  uploadLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryOrange,
                  ),
                ),
                Text(
                  uploadHint,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
