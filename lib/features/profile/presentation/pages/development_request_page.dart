import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/core/utils/validators.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_request.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/development_bloc.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/development_event.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/development_state.dart';

/// Page for submitting development request (app or web)
class DevelopmentRequestPage extends StatefulWidget {
  final DevelopmentRequestType requestType;

  const DevelopmentRequestPage({super.key, required this.requestType});

  @override
  State<DevelopmentRequestPage> createState() => _DevelopmentRequestPageState();
}

class _DevelopmentRequestPageState extends State<DevelopmentRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill mobile and email from authenticated user
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _mobileController.text = authState.user.mobile;
      _emailController.text = authState.user.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() != true) return;

    final request = DevelopmentRequest(
      name: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
      mobile: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      requestType: widget.requestType.value,
      description: _descriptionController.text.trim(),
    );

    context.read<DevelopmentBloc>().add(
      DevelopmentRequestSubmitted(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DevelopmentBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.requestType.getDisplayName(context),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          elevation: 0,
        ),
        body: BlocListener<DevelopmentBloc, DevelopmentState>(
          listener: (context, state) {
            if (state is DevelopmentLoading) {
              setState(() => _isSubmitting = true);
            } else if (state is DevelopmentRequestSuccess) {
              setState(() => _isSubmitting = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.secondaryGreen,
                ),
              );
              Navigator.of(context).pop();
            } else if (state is DevelopmentError) {
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
                              widget.requestType ==
                                      DevelopmentRequestType.appDevelopment
                                  ? Icons.phone_android
                                  : Icons.web,
                              color: AppColors.primaryOrange,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.fillDetailsRequest(
                                  widget.requestType
                                      .getDisplayName(context)
                                      .toLowerCase(),
                                ),
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

                      // Name field (optional)
                      _buildTextField(
                        label: AppLocalizations.of(context)!.nameLabel,
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            return Validators.getNameError(context, value);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Mobile field (required, read-only)
                      _buildTextField(
                        label: '${AppLocalizations.of(context)!.mobileLabel} *',
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.mobileRequired;
                          }
                          return Validators.getPhoneError(context, value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email field (required, read-only)
                      _buildTextField(
                        label: '${AppLocalizations.of(context)!.emailLabel} *',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.emailRequired;
                          }
                          return Validators.getEmailError(context, value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description field (required)
                      _buildTextField(
                        label:
                            '${AppLocalizations.of(context)!.descriptionLabel} *',
                        controller: _descriptionController,
                        textInputAction: TextInputAction.done,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.descriptionRequired;
                          }
                          return null;
                        },
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
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: readOnly
            ? (Theme.of(context).brightness == Brightness.light
                  ? AppColors.grey100
                  : Theme.of(context).colorScheme.surfaceContainerHighest)
            : Theme.of(context).cardColor,
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
}
