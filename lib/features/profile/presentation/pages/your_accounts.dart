import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/bank_detail.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/bank_detail_bloc.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/bank_detail_event.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/bank_detail_state.dart';

class YourAccountsPage extends StatefulWidget {
  const YourAccountsPage({super.key});

  @override
  State<YourAccountsPage> createState() => _YourAccountsPageState();
}

class _YourAccountsPageState extends State<YourAccountsPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountHolderNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _upiIdController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _accountHolderNameController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  String? _validateAccountHolderName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account holder name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }
    if (!RegExp(r'^[0-9]{9,18}$').hasMatch(value.trim())) {
      return 'Enter a valid account number (9-18 digits)';
    }
    return null;
  }

  String? _validateIfscCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IFSC code is required';
    }
    if (!RegExp(
      r'^[A-Z]{4}0[A-Z0-9]{6}$',
    ).hasMatch(value.trim().toUpperCase())) {
      return 'Enter a valid IFSC code (e.g., SBIN0001234)';
    }
    return null;
  }

  String? _validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bank name is required';
    }
    if (value.trim().length < 3) {
      return 'Bank name must be at least 3 characters';
    }
    return null;
  }

  String? _validateBranchName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Branch name is required';
    }
    if (value.trim().length < 3) {
      return 'Branch name must be at least 3 characters';
    }
    return null;
  }

  String? _validateUpiId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // UPI ID is optional
    }
    if (!RegExp(r'^[\w.-]+@[\w.-]+$').hasMatch(value.trim())) {
      return 'Enter a valid UPI ID (e.g., username@bankname)';
    }
    return null;
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Create bank detail params
      final params = BankDetailParams(
        accountHolderName: _accountHolderNameController.text.trim(),
        bankName: _bankNameController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        ifscCode: _ifscCodeController.text.trim().toUpperCase(),
        branchName: _branchNameController.text.trim(),
      );

      // Dispatch save event to BLoC
      context.read<BankDetailBloc>().add(BankDetailSaveRequested(params));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => getIt<BankDetailBloc>(),
      child: BlocConsumer<BankDetailBloc, BankDetailState>(
        listener: (context, state) {
          if (state is BankDetailLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is BankDetailSaveSuccess) {
            // Show success dialog
            _showSuccessDialog(context, state.bankDetail);
          }

          if (state is BankDetailError) {
            // Show error message
            AppErrorToast.show(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Your Account'), elevation: 0),
            body: _buildForm(theme, context),
          );
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, BankDetail bankDetail) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.secondaryGreen,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Successfully Added!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your account details have been successfully saved.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pop(bankDetail);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(ThemeData theme, BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Section
          Text(
            'Bank Account Details',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please provide your bank account details for refunds and payments',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Account Holder Name
          TextFormField(
            controller: _accountHolderNameController,
            decoration: InputDecoration(
              labelText: 'Account Holder Name *',
              hintText: 'Enter full name as per bank account',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.brightness == Brightness.light
                  ? Colors.grey[50]
                  : Colors.grey[900],
            ),
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            validator: _validateAccountHolderName,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
          ),
          const SizedBox(height: 16),

          // Account Number
          TextFormField(
            controller: _accountNumberController,
            decoration: InputDecoration(
              labelText: 'Account Number *',
              hintText: 'Enter your account number',
              prefixIcon: const Icon(Icons.account_balance_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.brightness == Brightness.light
                  ? Colors.grey[50]
                  : Colors.grey[900],
            ),
            keyboardType: TextInputType.number,
            validator: _validateAccountNumber,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(18),
            ],
          ),
          const SizedBox(height: 16),

          // IFSC Code
          TextFormField(
            controller: _ifscCodeController,
            decoration: InputDecoration(
              labelText: 'IFSC Code *',
              hintText: 'Enter IFSC code (e.g., SBIN0001234)',
              prefixIcon: const Icon(Icons.code_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.brightness == Brightness.light
                  ? Colors.grey[50]
                  : Colors.grey[900],
            ),
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.text,
            validator: _validateIfscCode,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              LengthLimitingTextInputFormatter(11),
              TextInputFormatter.withFunction((oldValue, newValue) {
                return newValue.copyWith(text: newValue.text.toUpperCase());
              }),
            ],
          ),
          const SizedBox(height: 16),

          // Bank Name
          TextFormField(
            controller: _bankNameController,
            decoration: InputDecoration(
              labelText: 'Bank Name *',
              hintText: 'Enter your bank name',
              prefixIcon: const Icon(Icons.account_balance),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.brightness == Brightness.light
                  ? Colors.grey[50]
                  : Colors.grey[900],
            ),
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            validator: _validateBankName,
          ),
          const SizedBox(height: 16),

          // Branch Name
          TextFormField(
            controller: _branchNameController,
            decoration: InputDecoration(
              labelText: 'Branch Name *',
              hintText: 'Enter your branch name',
              prefixIcon: const Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.brightness == Brightness.light
                  ? Colors.grey[50]
                  : Colors.grey[900],
            ),
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            validator: _validateBranchName,
          ),
          const SizedBox(height: 24),

          // Divider
          const Divider(height: 32),

          // UPI Section
          Text(
            'UPI Details (Optional)',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can also provide your UPI ID for faster payments',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // UPI ID
          TextFormField(
            controller: _upiIdController,
            decoration: InputDecoration(
              labelText: 'UPI ID',
              hintText: 'username@bankname',
              prefixIcon: const Icon(Icons.payment_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.brightness == Brightness.light
                  ? Colors.grey[50]
                  : Colors.grey[900],
              helperText: 'Example: yourname@paytm, yourname@phonepe',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _validateUpiId,
          ),
          const SizedBox(height: 32),

          // Info Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your account details are secured and will only be used for refunds and payment processing.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => _submitForm(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Save Account Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
