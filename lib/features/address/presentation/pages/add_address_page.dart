import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address_type.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_event.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_state.dart';
import 'package:taksh_e_commerce/features/address/presentation/pages/map_picker_page.dart';
import 'package:taksh_e_commerce/features/address/presentation/widgets/address_type_selector.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';

/// Page for adding or editing an address
class AddAddressPage extends StatefulWidget {
  final Address? address; // If provided, we're editing
  final bool useCurrentLocation; // If true, auto-detect current location

  const AddAddressPage({
    super.key,
    this.address,
    this.useCurrentLocation = false,
  });

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _labelController = TextEditingController();
  final _houseController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  AddressType _selectedType = AddressType.home;
  Location? _selectedLocation;
  String? _selectedAddress;
  bool _isDefault = false;

  late final AddressBloc _addressBloc;

  bool get _isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();
    _addressBloc = getIt<AddressBloc>();
    if (_isEditing) {
      _initializeWithExistingAddress();
    } else if (widget.useCurrentLocation) {
      // Auto-open map picker with current location
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openMapPicker();
      });
    }
  }

  void _initializeWithExistingAddress() {
    final address = widget.address!;
    _selectedType = address.type;
    _selectedLocation = address.location;
    _selectedAddress = address.location.formattedAddress;
    _isDefault = address.isDefault;

    _nameController.text = address.recipientName;
    _labelController.text = address.customLabel ?? '';
    _houseController.text = address.addressLine1;
    _landmarkController.text = address.landmark ?? '';
    _cityController.text = address.location.city ?? '';
    _stateController.text = address.location.state ?? '';
    _pincodeController.text = address.location.postalCode ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _labelController.dispose();
    _houseController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _addressBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _addressBloc,
      child: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is AddressError) {
            AppErrorToast.show(context);
          }
        },
        builder: (context, state) {
          final isLoading = state is AddressLoading;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                _isEditing
                    ? AppLocalizations.of(context)!.editAddress
                    : AppLocalizations.of(context)!.addNewAddress,
              ),
              elevation: 0,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Location picker card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: isLoading ? null : _openMapPicker,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Theme.of(context).primaryColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedLocation != null
                                        ? 'Location Selected'
                                        : 'Select Location on Map',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedAddress ??
                                        AppLocalizations.of(
                                          context,
                                        )!.tapToPickLocation,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.color,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Theme.of(context).disabledColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Address type selector
                  Text(
                    AppLocalizations.of(context)!.addressType,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AddressTypeSelector(
                    selectedType: _selectedType,
                    onTypeSelected: (type) {
                      setState(() {
                        _selectedType = type;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Recipient Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.recipientName,
                      hintText: AppLocalizations.of(
                        context,
                      )!.enterRecipientName,
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.pleaseEnterRecipientName;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Label (for Other type)
                  if (_selectedType == AddressType.other) ...[
                    TextFormField(
                      controller: _labelController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.labelOther,
                        hintText: AppLocalizations.of(context)!.enterLabel,
                        prefixIcon: const Icon(Icons.label_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (_selectedType == AddressType.other &&
                            (value == null || value.isEmpty)) {
                          return AppLocalizations.of(context)!.enterLabel;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // House/Flat number
                  TextFormField(
                    controller: _houseController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.houseFlatNo,
                      hintText: AppLocalizations.of(context)!.enterHouseNo,
                      prefixIcon: const Icon(Icons.home_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.pleaseEnterHouseNo;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Landmark
                  TextFormField(
                    controller: _landmarkController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.landmarkOptional,
                      hintText: AppLocalizations.of(context)!.landmarkHint,
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // City and State in a row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.city,
                            hintText: AppLocalizations.of(context)!.enterCity,
                            prefixIcon: const Icon(Icons.location_city),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _stateController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.state,
                            hintText: AppLocalizations.of(context)!.enterState,
                            prefixIcon: const Icon(Icons.map_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pincode
                  TextFormField(
                    controller: _pincodeController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.pincode,
                      hintText: AppLocalizations.of(context)!.enterPincode,
                      prefixIcon: const Icon(Icons.pin_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterPincode;
                      }
                      if (value.length != 6) {
                        return AppLocalizations.of(context)!.pincodeLengthError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Set as default checkbox
                  CheckboxListTile(
                    value: _isDefault,
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _isDefault = value ?? false;
                            });
                          },
                    title: Text(
                      AppLocalizations.of(context)!.setAsDefaultAddress,
                    ),
                    subtitle: Text(
                      AppLocalizations.of(context)!.setAsDefaultSubtitle,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveAddress,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
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
                          : Text(
                              _isEditing
                                  ? AppLocalizations.of(context)!.updateAddress
                                  : AppLocalizations.of(context)!.saveAddress,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
    );
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapPickerPage(initialLocation: _selectedLocation),
      ),
    );

    if (result != null && result is Map) {
      final location = result['location'] as Location?;
      setState(() {
        _selectedLocation = location;
        _selectedAddress = result['address'] as String?;
        if (location != null) {
          _houseController.text = location.formattedAddress ?? '';
          _cityController.text = location.city ?? '';
          _stateController.text = location.state ?? '';
          _pincodeController.text = location.postalCode ?? '';
        }
      });
    }
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a location on the map',
          ), // Reusing or add new
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Get user's phone number from AuthBloc
    String userPhone = '';
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      userPhone = authState.user.mobile;
    }

    // Update location with form data
    final updatedLocation = Location(
      latitude: _selectedLocation!.latitude,
      longitude: _selectedLocation!.longitude,
      formattedAddress: _selectedAddress ?? _selectedLocation!.formattedAddress,
      city: _cityController.text,
      state: _stateController.text,
      country: _selectedLocation!.country,
      postalCode: _pincodeController.text,
    );

    final address = Address(
      id: _isEditing ? widget.address!.id : '',
      userId: _isEditing ? widget.address!.userId : '',
      location: updatedLocation,
      type: _selectedType,
      customLabel: _selectedType == AddressType.other
          ? _labelController.text
          : null,
      recipientName: _nameController.text,
      recipientPhone: userPhone,
      addressLine1: _houseController.text,
      addressLine2: null,
      landmark: _landmarkController.text.isEmpty
          ? null
          : _landmarkController.text,
      isDefault: _isDefault,
      createdAt: _isEditing ? widget.address!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (_isEditing) {
      _addressBloc.add(UpdateAddressEvent(address));
    } else {
      _addressBloc.add(AddAddressEvent(address));
    }
  }
}
