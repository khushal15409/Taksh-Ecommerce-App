import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/core/utils/validators.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/delivery_boy_join_request.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/delivery_boy_bloc.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/delivery_boy_event.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/delivery_boy_state.dart';

/// Page for joining as a delivery boy
class DeliveryBoyJoinPage extends StatefulWidget {
  const DeliveryBoyJoinPage({super.key});

  @override
  State<DeliveryBoyJoinPage> createState() => _DeliveryBoyJoinPageState();
}

class _DeliveryBoyJoinPageState extends State<DeliveryBoyJoinPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() != true) return;

    final request = DeliveryBoyJoinRequest(
      name: _nameController.text.trim(),
      mobile: _mobileController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      pincode: _pincodeController.text.trim().isEmpty
          ? null
          : _pincodeController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    context.read<DeliveryBoyBloc>().add(
      DeliveryBoyJoinRequestSubmitted(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DeliveryBoyBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.joinDeliveryManTitle,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          elevation: 0,
        ),
        body: BlocListener<DeliveryBoyBloc, DeliveryBoyState>(
          listener: (context, state) {
            if (state is DeliveryBoyLoading) {
              setState(() => _isSubmitting = true);
            } else if (state is DeliveryBoyJoinRequestSuccess) {
              setState(() => _isSubmitting = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.secondaryGreen,
                ),
              );
              Navigator.of(context).pop();
            } else if (state is DeliveryBoyError) {
              setState(() => _isSubmitting = false);
              AppErrorToast.show(context);
            }
          },
          child: Builder(
            builder: (context) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Info card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryOrange.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.primaryOrange,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.fillDetailsDelivery,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Name field (required)
                      _buildTextField(
                        label: '${AppLocalizations.of(context)!.nameLabel} *',
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.nameRequired;
                          }
                          return Validators.getNameError(context, value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Mobile field (required)
                      _buildTextField(
                        label: '${AppLocalizations.of(context)!.mobileLabel} *',
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.mobileRequired;
                          }
                          return Validators.getPhoneError(context, value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email field (optional)
                      _buildTextField(
                        label: AppLocalizations.of(context)!.emailLabel,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            return Validators.getEmailError(context, value);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Address field (optional)
                      _buildTextField(
                        label: AppLocalizations.of(context)!.addressLabel,
                        controller: _addressController,
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Pincode field (optional)
                      _buildTextField(
                        label: AppLocalizations.of(context)!.pincodeLabel,
                        controller: _pincodeController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            if (value.length != 6) {
                              return AppLocalizations.of(
                                context,
                              )!.pincodeInvalidLength;
                            }
                            if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return AppLocalizations.of(
                                context,
                              )!.pincodeInvalidFormat;
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description field (optional)
                      _buildTextField(
                        label: AppLocalizations.of(context)!.descriptionLabel,
                        controller: _descriptionController,
                        textInputAction: TextInputAction.done,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 8),

                      // Required fields note
                      Text(
                        AppLocalizations.of(context)!.requiredFieldsNote,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Submit button
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () => _submit(context),
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
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                  ),
                                )
                              : Text(
                                  AppLocalizations.of(context)!.submitRequest,
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
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
    );
  }
}
