import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/core/theme/app_tokens.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_event.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_state.dart';
import 'package:taksh_e_commerce/features/address/presentation/widgets/address_card.dart';
import 'package:taksh_e_commerce/features/address/presentation/pages/add_address_page.dart';

/// Page to display list of saved addresses.
class AddressListPage extends StatefulWidget {
  final bool isSelectionMode;
  final ValueChanged<Address>? onAddressSelected;

  const AddressListPage({
    super.key,
    this.isSelectionMode = false,
    this.onAddressSelected,
  });

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressState = context.read<AddressBloc>().state;
      if (addressState is AddressInitial || addressState is AddressError) {
        context.read<AddressBloc>().add(const LoadAddressesEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AddressListView(
      isSelectionMode: widget.isSelectionMode,
      onAddressSelected: widget.onAddressSelected,
    );
  }
}

class _AddressListView extends StatelessWidget {
  final bool isSelectionMode;
  final ValueChanged<Address>? onAddressSelected;

  const _AddressListView({
    required this.isSelectionMode,
    this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSelectionMode
              ? AppLocalizations.of(context)!.selectAddress
              : AppLocalizations.of(context)!.myAddresses,
        ),
        elevation: 0,
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.white),
                ),
                backgroundColor: AppColors.success,
              ),
            );
            // Reload addresses after successful operation
            context.read<AddressBloc>().add(const LoadAddressesEvent());
          } else if (state is AddressOperationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.somethingWentWrong,
                  style: const TextStyle(color: AppColors.white),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.somethingWentWrong,
                  style: const TextStyle(color: AppColors.white),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AddressLoading) {
            return _buildLoadingState(colorScheme);
          }

          if (state is AddressError) {
            return _buildErrorState(context, l10n, state.message);
          }

          if (state is AddressesLoaded || state is AddressOperationError) {
            final addresses = state is AddressesLoaded
                ? state.addresses
                : (state as AddressOperationError).addresses;

            if (addresses.isEmpty) {
              return _buildEmptyState(context, l10n);
            }

            return _buildAddressList(context, addresses);
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddAddress(context),
        icon: const Icon(Icons.add_location_alt_rounded),
        label: Text(l10n.addAddress),
      ),
    );
  }

  // ────────────────────────────────────────────────────────
  //  UI States
  // ────────────────────────────────────────────────────────

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Loading addresses...',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    AppLocalizations l10n,
    String errorMessage,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_off_rounded,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.failedToLoadAddresses,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.somethingWentWrong,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.55),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () {
                context.read<AddressBloc>().add(const LoadAddressesEvent());
              },
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(l10n.retry),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_location_alt_outlined,
                size: 48,
                color: colorScheme.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.noAddressesSaved,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.addFirstAddress,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.55),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => _navigateToAddAddress(context),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addAddress),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList(BuildContext context, List<Address> addresses) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () async {
        context.read<AddressBloc>().add(const LoadAddressesEvent());
        // Wait a bit for the state to update
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: 100, // Room for FAB
        ),
        itemCount: addresses.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xxs),
        itemBuilder: (context, index) {
          final address = addresses[index];
          return AddressCard(
            address: address,
            onTap: isSelectionMode
                ? () {
                    onAddressSelected?.call(address);
                    Navigator.of(context).pop(address);
                  }
                : null,
            onEdit: () => _navigateToEditAddress(context, address),
            onDelete: () => _showDeleteConfirmation(context, address),
            onSetDefault: () {
              context.read<AddressBloc>().add(
                SetDefaultAddressEvent(address.id),
              );
            },
            showActions: !isSelectionMode,
          );
        },
      ),
    );
  }

  // ────────────────────────────────────────────────────────
  //  Navigation & Dialogs
  // ────────────────────────────────────────────────────────

  void _navigateToAddAddress(BuildContext context) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddAddressPage()));

    if (result == true && context.mounted) {
      context.read<AddressBloc>().add(LoadAddressesEvent());
    }
  }

  void _navigateToEditAddress(BuildContext context, Address address) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddAddressPage(address: address)),
    );

    if (result == true && context.mounted) {
      context.read<AddressBloc>().add(const LoadAddressesEvent());
    }
  }

  void _showDeleteConfirmation(BuildContext context, Address address) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: AppTokens.borderRadiusLG,
        ),
        icon: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.delete_forever_rounded,
            color: AppColors.error,
            size: 28,
          ),
        ),
        title: Text(
          l10n.deleteAddress,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        content: Text(
          l10n.deleteAddressConfirm,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
            ),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AddressBloc>().add(DeleteAddressEvent(address.id));
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
