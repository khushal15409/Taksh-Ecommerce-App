import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_item.dart';
import 'package:taksh_e_commerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:taksh_e_commerce/features/orders/presentation/cubit/orders_state.dart';

/// Bottom sheet for requesting item return with camera integration
class ReturnRequestBottomSheet extends StatefulWidget {
  final int orderId;
  final OrderItem orderItem;
  final VoidCallback? onSuccess;

  const ReturnRequestBottomSheet({
    super.key,
    required this.orderId,
    required this.orderItem,
    this.onSuccess,
  });

  /// Show the return request bottom sheet
  static Future<void> show(
    BuildContext context, {
    required int orderId,
    required OrderItem orderItem,
    VoidCallback? onSuccess,
  }) {
    // Get the cubit from the original context before showing the bottom sheet
    final ordersCubit = context.read<OrdersCubit>();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: ordersCubit,
        child: ReturnRequestBottomSheet(
          orderId: orderId,
          orderItem: orderItem,
          onSuccess: onSuccess,
        ),
      ),
    );
  }

  @override
  State<ReturnRequestBottomSheet> createState() =>
      _ReturnRequestBottomSheetState();
}

class _ReturnRequestBottomSheetState extends State<ReturnRequestBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _picker = ImagePicker();
  final List<XFile> _selectedImages = [];
  bool _isSubmitting = false;

  // Common return reasons
  final List<String> _commonReasons = [
    'Product damaged during delivery',
    'Wrong item received',
    'Product quality is not as expected',
    'Product does not match description',
    'Changed my mind',
    'Other',
  ];
  String? _selectedReason;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is ReturnCompleted || state is ReturnRequested) {
          setState(() => _isSubmitting = false);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state is ReturnCompleted
                    ? state.message
                    : (state as ReturnRequested).message,
              ),
              backgroundColor: AppColors.secondaryGreen,
            ),
          );
          widget.onSuccess?.call();
        } else if (state is OrdersError) {
          setState(() => _isSubmitting = false);
          AppErrorToast.show(context);
        } else if (state is RequestingReturn || state is UploadingReturnMedia) {
          setState(() => _isSubmitting = true);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildItemInfo(),
                  const SizedBox(height: 20),
                  _buildReasonSelector(),
                  const SizedBox(height: 16),
                  _buildReasonTextField(),
                  const SizedBox(height: 20),
                  _buildImageSection(),
                  const SizedBox(height: 24),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Return Item',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildItemInfo() {
    final productName =
        widget.orderItem.productVariant?.product?.name ?? 'Product';
    final sku = widget.orderItem.productVariant?.sku ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag_outlined, color: AppColors.grey600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (sku.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'SKU: $sku',
                    style: const TextStyle(color: AppColors.grey600, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Reason',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _commonReasons.map((reason) {
            final isSelected = _selectedReason == reason;
            return ChoiceChip(
              label: Text(reason),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedReason = selected ? reason : null;
                  if (reason != 'Other') {
                    _reasonController.text = reason;
                  } else {
                    _reasonController.clear();
                  }
                });
              },
              selectedColor: AppColors.primaryOrange.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primaryOrange : AppColors.grey700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primaryOrange : AppColors.grey300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReasonTextField() {
    return TextFormField(
      controller: _reasonController,
      decoration: InputDecoration(
        labelText: 'Detailed Reason',
        hintText: 'Please describe the issue in detail',
        prefixIcon: const Icon(Icons.description_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please provide a reason for return';
        }
        if (value.trim().length < 10) {
          return 'Please provide more details (at least 10 characters)';
        }
        return null;
      },
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Add Photos (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            TextButton.icon(
              onPressed: _isSubmitting ? null : _showImageSourceDialog,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 20),
              label: const Text('Add'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_selectedImages.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(Icons.image_outlined, size: 48, color: AppColors.grey400),
                SizedBox(height: 8),
                Text(
                  'Add photos to support your return request',
                  style: TextStyle(color: AppColors.grey600, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          _buildImageGrid(),
      ],
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _selectedImages.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_selectedImages[index].path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedImages.removeAt(index);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitReturnRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Submit Return Request',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        // Allow multiple selection from gallery
        final images = await _picker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            _selectedImages.addAll(images);
            // Limit to 5 images
            if (_selectedImages.length > 5) {
              _selectedImages.removeRange(5, _selectedImages.length);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Maximum 5 images allowed'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          });
        }
      } else {
        // Single image from camera
        final image = await _picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            if (_selectedImages.length < 5) {
              _selectedImages.add(image);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Maximum 5 images allowed'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitReturnRequest() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final reason = _reasonController.text.trim();
    final imagePaths = _selectedImages.map((img) => img.path).toList();

    // Call the cubit method to complete return request
    context.read<OrdersCubit>().completeReturnRequest(
      orderId: widget.orderId,
      orderItemId: widget.orderItem.id,
      reason: reason,
      imagePaths: imagePaths,
    );
  }
}
