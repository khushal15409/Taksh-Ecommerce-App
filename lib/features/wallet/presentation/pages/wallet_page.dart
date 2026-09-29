import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/bank_account.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/wallet_summary.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/withdrawal_response.dart';
import 'package:taksh_e_commerce/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:taksh_e_commerce/features/wallet/presentation/cubit/wallet_state.dart';

/// Wallet page showing points balance, reward formula, and withdrawal
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'My Wallet',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletError) {
            AppErrorToast.show(context);
          }
          if (state is WalletWithdrawalSuccess) {
            _showWithdrawalSuccessDialog(context, state.withdrawal);
          }
        },
        builder: (context, state) {
          if (state is WalletLoading) {
            return const _WalletLoadingView();
          }
          if (state is WalletLoaded) {
            return _WalletContentView(
              summary: state.summary,
              bankAccounts: state.bankAccounts,
              isWithdrawing: false,
            );
          }
          if (state is WalletWithdrawalInProgress) {
            return _WalletContentView(
              summary: state.summary,
              bankAccounts: state.bankAccounts,
              isWithdrawing: true,
            );
          }
          if (state is WalletWithdrawalSuccess) {
            return _WalletContentView(
              summary: state.summary,
              bankAccounts: state.bankAccounts,
              isWithdrawing: false,
            );
          }
          if (state is WalletError) {
            return _WalletErrorView(
              message: state.message,
              onRetry: () => context.read<WalletCubit>().loadWallet(),
            );
          }
          // WalletInitial — trigger load
          return const _WalletLoadingView();
        },
      ),
    );
  }

  void _showWithdrawalSuccessDialog(
    BuildContext context,
    WithdrawalResponse withdrawal,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon with animated gradient
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.success.withOpacity(0.15),
                      AppColors.secondaryGreen.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 52,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Withdrawal Submitted!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.grey900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your withdrawal of ${withdrawal.points} points '
                '(₹${withdrawal.amountRupees}) has been submitted '
                'successfully.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.amber[800]),
                    const SizedBox(width: 6),
                    Text(
                      'Status: ${withdrawal.status.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),
              if (withdrawal.bankDetail != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To: ${withdrawal.bankDetail!.bankName}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'A/C: ${withdrawal.bankDetail!.accountNumber}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    // Reload wallet to get updated balance
                    context.read<WalletCubit>().loadWallet();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Loading View ────────────────────────────────────────────────────────────

class _WalletLoadingView extends StatelessWidget {
  const _WalletLoadingView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Shimmer balance card
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.grey200,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.grey200,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.grey200,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.grey200,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.grey200,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Error View ──────────────────────────────────────────────────────────────

class _WalletErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _WalletErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.grey900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Main Content View ───────────────────────────────────────────────────────

class _WalletContentView extends StatelessWidget {
  final WalletSummary summary;
  final List<BankAccount> bankAccounts;
  final bool isWithdrawing;

  const _WalletContentView({
    required this.summary,
    required this.bankAccounts,
    required this.isWithdrawing,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<WalletCubit>().loadWallet(),
      color: AppColors.primaryOrange,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Balance Card ──
            _BalanceCard(summary: summary),
            const SizedBox(height: 16),

            // ── Stats Row ──
            _StatsRow(summary: summary),
            const SizedBox(height: 20),

            // ── Reward Info Card ──
            _RewardInfoCard(summary: summary),
            const SizedBox(height: 20),

            // ── Withdraw Button ──
            _WithdrawButton(
              summary: summary,
              bankAccounts: bankAccounts,
              isWithdrawing: isWithdrawing,
            ),
            const SizedBox(height: 16),

            // ── Info Note ──
            _InfoNote(summary: summary),
          ],
        ),
      ),
    );
  }
}

// ─── Balance Card ────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  final WalletSummary summary;

  const _BalanceCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8F5E), Color(0xFFFFA726)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Points badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '1 pt = ₹${summary.rupeesPerPoint}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Points number
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${summary.balancePoints}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'points',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '≈ ₹${summary.balanceRupeesEquivalent}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stats Row ───────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final WalletSummary summary;

  const _StatsRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline_rounded,
            iconColor: AppColors.success,
            bgColor: AppColors.success.withOpacity(0.08),
            label: 'Available',
            value: '${summary.availablePoints}',
            subtitle: '≈ ₹${summary.availableRupeesEquivalent}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.schedule_rounded,
            iconColor: Colors.amber[700]!,
            bgColor: Colors.amber.withOpacity(0.08),
            label: 'Pending',
            value: '${summary.pendingWithdrawalPoints}',
            subtitle: 'In withdrawal',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$value pts',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reward Info Card ────────────────────────────────────────────────────────

class _RewardInfoCard extends StatelessWidget {
  final WalletSummary summary;

  const _RewardInfoCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final reward = summary.orderReward;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E0FF), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF7C4DFF).withOpacity(0.12),
                      const Color(0xFFB388FF).withOpacity(0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFF7C4DFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'How You Earn Points',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Simple explanation
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.card_giftcard_rounded,
                  size: 18,
                  color: Color(0xFF7C4DFF),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Earn 1 point for every ₹100 you spend on orders',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey800,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Example
          if (reward.example.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.success.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 18,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      reward.example,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Withdraw Button ─────────────────────────────────────────────────────────

class _WithdrawButton extends StatelessWidget {
  final WalletSummary summary;
  final List<BankAccount> bankAccounts;
  final bool isWithdrawing;

  const _WithdrawButton({
    required this.summary,
    required this.bankAccounts,
    required this.isWithdrawing,
  });

  @override
  Widget build(BuildContext context) {
    final canWithdraw = summary.canWithdraw;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isWithdrawing || !canWithdraw
            ? null
            : () => _showWithdrawBottomSheet(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          disabledBackgroundColor: AppColors.grey300,
          foregroundColor: Colors.white,
          disabledForegroundColor: AppColors.grey500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: canWithdraw ? 3 : 0,
          shadowColor: const Color(0xFF2E7D32).withOpacity(0.3),
        ),
        child: isWithdrawing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Processing...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance_rounded, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    canWithdraw
                        ? 'Withdraw to Bank Account'
                        : 'Minimum ${summary.minWithdrawalPoints} pts required',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showWithdrawBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<WalletCubit>(),
        child: _WithdrawBottomSheet(
          summary: summary,
          bankAccounts: bankAccounts,
        ),
      ),
    );
  }
}

// ─── Info Note ───────────────────────────────────────────────────────────────

class _InfoNote extends StatelessWidget {
  final WalletSummary summary;

  const _InfoNote({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD0DCFF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.blue[700], size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Minimum ${summary.minWithdrawalPoints} points required for withdrawal. '
              'Maximum 1000 points per request. '
              'Points are converted at ₹${summary.rupeesPerPoint} per point '
              'and transferred to your bank account.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[900],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Withdraw Bottom Sheet ───────────────────────────────────────────────────

class _WithdrawBottomSheet extends StatefulWidget {
  final WalletSummary summary;
  final List<BankAccount> bankAccounts;

  const _WithdrawBottomSheet({
    required this.summary,
    required this.bankAccounts,
  });

  @override
  State<_WithdrawBottomSheet> createState() => _WithdrawBottomSheetState();
}

class _WithdrawBottomSheetState extends State<_WithdrawBottomSheet> {
  final _pointsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  BankAccount? _selectedAccount;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.bankAccounts.isNotEmpty) {
      _selectedAccount = widget.bankAccounts.first;
    }
  }

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  int get _minPoints => widget.summary.minWithdrawalPoints;
  int get _maxPoints => widget.summary.maxWithdrawalPoints;

  String? _validatePoints(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter points to withdraw';
    }
    final points = int.tryParse(value.trim());
    if (points == null) return 'Enter a valid number';
    if (points < _minPoints) return 'Minimum $_minPoints points required';
    if (points > _maxPoints) {
      if (widget.summary.availablePoints < 1000) {
        return 'You only have ${widget.summary.availablePoints} available points';
      }
      return 'Maximum 1000 points per request';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a bank account'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final points = int.parse(_pointsController.text.trim());

    setState(() => _isSubmitting = true);

    context.read<WalletCubit>().submitWithdrawal(
      points: points,
      bankDetailId: _selectedAccount!.id,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.account_balance_rounded,
                          color: Color(0xFF2E7D32),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Withdraw Points',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.grey900,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, size: 22),
                        color: AppColors.grey500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Available points info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.success.withOpacity(0.06),
                          AppColors.success.withOpacity(0.02),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 18,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Available: ${widget.summary.availablePoints} points '
                          '(≈ ₹${widget.summary.availableRupeesEquivalent})',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Points input
                  const Text(
                    'Points to Withdraw',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _pointsController,
                    keyboardType: TextInputType.number,
                    validator: _validatePoints,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),
                    ],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey900,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter points',
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: AppColors.grey400,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 14, right: 8),
                        child: Icon(
                          Icons.stars_rounded,
                          color: Color(0xFFFF6B35),
                          size: 22,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      helperText:
                          'Min: $_minPoints  •  Max: $_maxPoints points',
                      helperStyle: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey500,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.grey300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.grey300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.error),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bank account selector
                  const Text(
                    'Bank Account',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey800,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (widget.bankAccounts.isEmpty)
                    _NoBankAccountsCard()
                  else
                    _BankAccountDropdown(
                      accounts: widget.bankAccounts,
                      selected: _selectedAccount,
                      onChanged: (account) {
                        setState(() => _selectedAccount = account);
                      },
                    ),

                  const SizedBox(height: 24),

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: widget.bankAccounts.isEmpty || _isSubmitting
                          ? null
                          : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        disabledBackgroundColor: AppColors.grey300,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                        shadowColor: const Color(0xFF2E7D32).withOpacity(0.3),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Confirm Withdrawal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),

                  // Bottom safe area
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── No Bank Accounts Card ──────────────────────────────────────────────────

class _NoBankAccountsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_outlined,
            size: 36,
            color: Colors.amber[800],
          ),
          const SizedBox(height: 12),
          Text(
            'No Bank Accounts Found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.amber[900],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Please add a bank account from your profile to withdraw points.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.amber[800],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Bank Account Dropdown ──────────────────────────────────────────────────

class _BankAccountDropdown extends StatelessWidget {
  final List<BankAccount> accounts;
  final BankAccount? selected;
  final ValueChanged<BankAccount?> onChanged;

  const _BankAccountDropdown({
    required this.accounts,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey300),
        color: const Color(0xFFF9FAFB),
      ),
      child: DropdownButtonFormField<int>(
        initialValue: selected?.id,
        onChanged: (id) {
          final account = accounts.firstWhere((a) => a.id == id);
          onChanged(account);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.grey600,
        ),
        isExpanded: true,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(14),
        items: accounts.map((account) {
          return DropdownMenuItem<int>(
            value: account.id,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    size: 16,
                    color: Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        account.bankName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${account.accountHolderName} • ${account.accountNumber}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.grey500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
