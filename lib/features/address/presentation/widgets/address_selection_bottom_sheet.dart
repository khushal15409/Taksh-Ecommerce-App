import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_event.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_state.dart';
import 'package:taksh_e_commerce/features/address/presentation/pages/add_address_page.dart';

/// Bottom sheet for selecting delivery address
class AddressSelectionBottomSheet extends StatelessWidget {
  final Address? currentAddress;
  final ValueChanged<Address> onAddressSelected;

  const AddressSelectionBottomSheet({
    super.key,
    this.currentAddress,
    required this.onAddressSelected,
  });

  static Future<Address?> show(
    BuildContext context, {
    Address? currentAddress,
  }) {
    final addressBloc = context.read<AddressBloc>();
    final addressState = addressBloc.state;

    if (addressState is AddressInitial || addressState is AddressError) {
      addressBloc.add(const LoadAddressesEvent());
    }

    return showModalBottomSheet<Address>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: addressBloc,
        child: AddressSelectionBottomSheet(
          currentAddress: currentAddress,
          onAddressSelected: (address) {
            Navigator.of(context).pop(address);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[300]
                      : Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.primaryOrange,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Select Delivery Address',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Address list
              Expanded(
                child: BlocConsumer<AddressBloc, AddressState>(
                  listener: (context, state) {
                    if (state is AddressOperationSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.message,
                            style: const TextStyle(color: AppColors.white),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      context.read<AddressBloc>().add(const LoadAddressesEvent());
                    } else if (state is AddressOperationError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Oops! Something went wrong',
                            style: TextStyle(color: AppColors.white),
                          ),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    } else if (state is AddressError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Oops! Something went wrong',
                            style: TextStyle(color: AppColors.white),
                          ),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    } else if (state is AddressError) {
                      AppErrorToast.show(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is AddressLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is AddressError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load addresses',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<AddressBloc>().add(
                                  const LoadAddressesEvent(),
                                );
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is AddressesLoaded || state is AddressOperationSuccess || state is AddressOperationError) {
                      final List<Address> addresses;
                      if (state is AddressesLoaded) {
                        addresses = state.addresses;
                      } else if (state is AddressOperationSuccess) {
                        addresses = state.addresses;
                      } else {
                        addresses = (state as AddressOperationError).addresses;
                      }

                      if (addresses.isEmpty) {
                        return _buildEmptyState(context);
                      }

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          final address = addresses[index];
                          final isSelected = currentAddress?.id == address.id;

                          return _buildAddressItem(
                            context,
                            address,
                            isSelected,
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              // Add new address button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToAddAddress(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Address'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddressItem(
    BuildContext context,
    Address address,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => onAddressSelected(address),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryOrange.withOpacity(0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryOrange
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address type icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryOrange
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getAddressIcon(address),
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyMedium?.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Address details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.displayLabel,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColors.primaryOrange
                                  : Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                            ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(
                              color: AppColors.secondaryGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.shortAddress,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (address.location.postalCode != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'PIN: ${address.location.postalCode}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryOrange,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'No addresses saved',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first address to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAddressIcon(Address address) {
    switch (address.type.name) {
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      default:
        return Icons.location_on;
    }
  }

  void _navigateToAddAddress(BuildContext context) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddAddressPage()));

    if (result == true && context.mounted) {
      context.read<AddressBloc>().add(const LoadAddressesEvent());
    }
  }
}
