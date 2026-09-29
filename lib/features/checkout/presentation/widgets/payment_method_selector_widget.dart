import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/payment_method_selection.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_event.dart';

/// Widget for selecting payment method (COD or Online)
class PaymentMethodSelectorWidget extends StatefulWidget {
  const PaymentMethodSelectorWidget({super.key});

  @override
  State<PaymentMethodSelectorWidget> createState() =>
      _PaymentMethodSelectorWidgetState();
}

class _PaymentMethodSelectorWidgetState
    extends State<PaymentMethodSelectorWidget> {
  PaymentMethodSelection _selectedMethod = PaymentMethodSelection.cod;

  @override
  void initState() {
    super.initState();
    // Set initial selection from bloc
    _selectedMethod = context.read<CheckoutBloc>().selectedPaymentMethod;
  }

  void _selectPaymentMethod(PaymentMethodSelection method) {
    setState(() {
      _selectedMethod = method;
    });
    context.read<CheckoutBloc>().add(SelectPaymentMethodEvent(method));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
        children: [
          // COD Payment Method
          _buildPaymentMethodTile(
            method: PaymentMethodSelection.cod,
            icon: Icons.money_outlined,
            title: PaymentMethodType.cod.displayName,
            subtitle: PaymentMethodSelection.cod.description,
            isSelected: _selectedMethod.type == PaymentMethodType.cod,
            onTap: () => _selectPaymentMethod(PaymentMethodSelection.cod),
          ),
          const Divider(height: 1),
          // Online Payment Method
          _buildPaymentMethodTile(
            method: PaymentMethodSelection.online,
            icon: Icons.payment_outlined,
            title: PaymentMethodType.online.displayName,
            subtitle: PaymentMethodSelection.online.description,
            isSelected: _selectedMethod.type == PaymentMethodType.online,
            onTap: () => _selectPaymentMethod(PaymentMethodSelection.online),
            trailing: _buildPaymentLogos(),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    required PaymentMethodSelection method,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryOrange.withOpacity(0.1)
                    : Theme.of(context).disabledColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color:
                    isSelected ? AppColors.primaryOrange : Theme.of(context).textTheme.bodyMedium?.color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? AppColors.primaryOrange : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(height: 8),
                    trailing,
                  ],
                ],
              ),
            ),
            // Radio button
            Radio<PaymentMethodType>(
              value: method.type,
              groupValue: _selectedMethod.type,
              onChanged: (value) {
                if (value != null) {
                  _selectPaymentMethod(method);
                }
              },
              activeColor: AppColors.primaryOrange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentLogos() {
    return Row(
      children: [
        _buildPaymentLogo('Razorpay', Colors.blue.shade700),
        const SizedBox(width: 8),
        _buildPaymentLogo('Cards', Colors.green.shade700),
        const SizedBox(width: 8),
        _buildPaymentLogo('UPI', Colors.orange.shade700),
        const SizedBox(width: 8),
        _buildPaymentLogo('Wallets', Colors.purple.shade700),
      ],
    );
  }

  Widget _buildPaymentLogo(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
