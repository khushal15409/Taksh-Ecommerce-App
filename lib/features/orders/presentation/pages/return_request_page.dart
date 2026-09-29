import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_item.dart';
import 'package:taksh_e_commerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:taksh_e_commerce/features/orders/presentation/cubit/orders_state.dart';

/// Full page for creating return requests and uploading media.
class ReturnRequestPage extends StatefulWidget {
  final int orderId;
  final List<OrderItem> items;
  final OrderItem? initialSelectedItem;

  const ReturnRequestPage({
    super.key,
    required this.orderId,
    required this.items,
    this.initialSelectedItem,
  });

  @override
  State<ReturnRequestPage> createState() => _ReturnRequestPageState();
}

class _ReturnRequestPageState extends State<ReturnRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _resolutionController = TextEditingController();
  final _picker = ImagePicker();
  final List<XFile> _selectedImages = [];

  bool _isSubmitting = false;
  String? _selectedReason;
  OrderItem? _selectedItem;

  final List<String> _reasons = const [
    'Size fit issue',
    'Quility issue',
    'accessories missing',
    'Quantity missing',
    'Complete missing product',
    'Complete damage product received',
    'Received product with minor damage',
    'Diffrent color received',
    'Completely Diffrent product received',
  ];

  @override
  void initState() {
    super.initState();
    _selectedItem =
        widget.initialSelectedItem ??
        (widget.items.isNotEmpty ? widget.items.first : null);
  }

  @override
  void dispose() {
    _resolutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is RequestingReturn || state is UploadingReturnMedia) {
          setState(() => _isSubmitting = true);
          return;
        }

        if (state is ReturnCompleted || state is ReturnRequested) {
          setState(() => _isSubmitting = false);
          final message = state is ReturnCompleted
              ? state.message
              : (state as ReturnRequested).message;

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.secondaryGreen,
            ),
          );

          Navigator.of(context).pop(true);
          return;
        }

        if (state is OrdersError) {
          setState(() => _isSubmitting = false);
          AppErrorToast.show(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Return Request'),
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? AppColors.primaryOrange
              : Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Theme.of(context).appBarTheme.foregroundColor,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildItemSelector(),
              const SizedBox(height: 16),
              _buildReasons(),
              const SizedBox(height: 16),
              _buildOptionalResolutionField(),
              const SizedBox(height: 16),
              _buildImageSection(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemSelector() {
    final isLockedToSingleItem = widget.initialSelectedItem != null;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Item',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (_selectedItem != null) _buildItemTile(_selectedItem!),
            if (!isLockedToSingleItem && widget.items.length > 1) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _selectedItem?.id,
                decoration: const InputDecoration(
                  labelText: 'Choose order item',
                  border: OutlineInputBorder(),
                ),
                items: widget.items
                    .map(
                      (item) => DropdownMenuItem<int>(
                        value: item.id,
                        child: Text(_displayName(item)),
                      ),
                    )
                    .toList(),
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedItem = widget.items.firstWhere(
                            (item) => item.id == value,
                          );
                        });
                      },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemTile(OrderItem item) {
    final sku = item.productVariant?.sku ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _displayName(item),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          if (sku.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'SKU: $sku',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReasons() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Return Reason',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _reasons.map((reason) {
                final isSelected = _selectedReason == reason;
                return ChoiceChip(
                  label: Text(reason),
                  selected: isSelected,
                  onSelected: _isSubmitting
                      ? null
                      : (selected) {
                          setState(() {
                            _selectedReason = selected ? reason : null;
                          });
                        },
                  selectedColor: AppColors.primaryOrange.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primaryOrange
                        : Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primaryOrange
                        : AppColors.grey300,
                  ),
                );
              }).toList(),
            ),
            if (_selectedReason == null)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Please select one reason',
                  style: TextStyle(color: AppColors.error, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalResolutionField() {
    return TextFormField(
      controller: _resolutionController,
      enabled: !_isSubmitting,
      decoration: InputDecoration(
        labelText: 'Additional Note (Optional)',
        hintText: 'Add extra details if needed',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      maxLines: 3,
    );
  }

  Widget _buildImageSection() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upload Images',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                TextButton.icon(
                  onPressed: _isSubmitting ? null : _showImageSourceDialog,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_selectedImages.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('No images selected'),
              )
            else
              GridView.builder(
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
                        child: GestureDetector(
                          onTap: _isSubmitting
                              ? null
                              : () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),
                            padding: const EdgeInsets.all(4),
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
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Submit Return Request',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
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
        final images = await _picker.pickMultiImage();
        if (images.isEmpty) return;

        setState(() {
          _selectedImages.addAll(images);
          if (_selectedImages.length > 5) {
            _selectedImages.removeRange(5, _selectedImages.length);
          }
        });

        if (_selectedImages.length == 5 && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum 5 images allowed')),
          );
        }
        return;
      }

      final image = await _picker.pickImage(source: source);
      if (image == null) return;

      if (_selectedImages.length >= 5) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 5 images allowed')),
        );
        return;
      }

      setState(() {
        _selectedImages.add(image);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No order item selected for return')),
      );
      return;
    }

    if (_selectedReason == null) {
      setState(() {});
      return;
    }

    context.read<OrdersCubit>().completeReturnRequest(
      orderId: widget.orderId,
      orderItemId: _selectedItem!.id,
      reason: _selectedReason!,
      resolution: _resolutionController.text.trim().isEmpty
          ? null
          : _resolutionController.text.trim(),
      imagePaths: _selectedImages.map((image) => image.path).toList(),
    );
  }

  String _displayName(OrderItem item) {
    return item.productVariant?.product?.name ?? 'Product #${item.id}';
  }
}
