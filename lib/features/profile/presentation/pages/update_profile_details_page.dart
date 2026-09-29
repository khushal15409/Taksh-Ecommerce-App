import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/core/utils/validators.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';

/// Update profile details page for basic user information
class UpdateProfileDetailsPage extends StatefulWidget {
  const UpdateProfileDetailsPage({super.key});

  @override
  State<UpdateProfileDetailsPage> createState() =>
      _UpdateProfileDetailsPageState();
}

class _UpdateProfileDetailsPageState extends State<UpdateProfileDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  String? _selectedBirthday;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      final nameParts = (state.user.name ?? '').trim().split(' ');
      if (nameParts.isNotEmpty) {
        _firstNameController.text = nameParts.first;
        if (nameParts.length > 1) {
          _lastNameController.text = nameParts.sublist(1).join(' ').trim();
        }
      }
      _emailController.text = state.user.email ?? '';
      _mobileController.text = state.user.mobile;
      _selectedBirthday = state.user.birthday;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final initialDate = _selectedBirthday != null
        ? DateTime.tryParse(_selectedBirthday!) ?? DateTime(now.year - 18)
        : DateTime(now.year - 18);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1924),
      lastDate: DateTime(now.year - 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryOrange,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthday =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isSubmitting = true);
    context.read<AuthBloc>().add(
      AuthUpdateProfileRequested(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        mobile: _mobileController.text.trim(),
        birthday: _selectedBirthday,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.updateProfileTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthProfileUpdateSuccess) {
            if (mounted) {
              setState(() => _isSubmitting = false);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.of(context).pop();
            }
          } else if (state is AuthProfileUpdateFailure) {
            if (mounted) {
              setState(() => _isSubmitting = false);
              AppErrorToast.show(context);
            }
          } else if (state is AuthError) {
            if (mounted) {
              setState(() => _isSubmitting = false);
              AppErrorToast.show(context);
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                _buildTextField(
                  label: AppLocalizations.of(context)!.firstName,
                  controller: _firstNameController,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validators.getNameError(context, value ?? ''),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: AppLocalizations.of(context)!.lastName,
                  controller: _lastNameController,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validators.getNameError(context, value ?? ''),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: AppLocalizations.of(context)!.mobileLabel,
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validators.getPhoneError(context, value ?? ''),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: AppLocalizations.of(context)!.emailLabel,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      Validators.getEmailError(context, value ?? ''),
                ),
                const SizedBox(height: 16),
                // Birthday picker
                InkWell(
                  onTap: _pickBirthday,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Birthday',
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primaryOrange,
                          width: 1.5,
                        ),
                      ),
                      suffixIcon: const Icon(Icons.cake_outlined),
                    ),
                    child: Text(
                      _selectedBirthday ?? 'Select your birthday',
                      style: TextStyle(
                        color: _selectedBirthday != null
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context).hintColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(AppLocalizations.of(context)!.saveDetails),
                  ),
                ),
              ],
            ),
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
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
          borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
        ),
      ),
    );
  }
}
