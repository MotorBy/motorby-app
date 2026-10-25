import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/search/search_address_map.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

/// Opens the add/edit sheet for the user's [addressType] ('home' or 'work').
void showAddressFormSheet(BuildContext context, MapViewModel viewModel, String addressType) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => AddressFormSheet(viewModel: viewModel, addressType: addressType),
  );
}

class AddressFormSheet extends StatefulWidget {
  final MapViewModel viewModel;
  final String addressType;

  const AddressFormSheet({super.key, required this.viewModel, required this.addressType});

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet> {
  final describeAddressController = TextEditingController();
  Map<String, dynamic>? existingAddress;
  Map<String, dynamic> selectedAddress = {};

  bool get isEditing => existingAddress != null;

  @override
  void initState() {
    super.initState();
    final saved = widget.addressType == 'home' ? widget.viewModel.homeAddress : widget.viewModel.workAddress;
    if (saved != null && saved.isNotEmpty) {
      existingAddress = saved;
      describeAddressController.text = saved['nickname'] ?? '';
      // Same shape SearchAddressMap returns, so saving without re-picking keeps the old location.
      selectedAddress = {
        'address': saved['address'],
        'lat': saved['latitude']?.toString(),
        'lng': saved['longitude']?.toString(),
      };
    }
  }

  @override
  void dispose() {
    describeAddressController.dispose();
    super.dispose();
  }

  Future<void> _pickAddress() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => SearchAddressMap(viewModel: widget.viewModel)),
    );
    if (result != null) setState(() => selectedAddress = result);
  }

  void _save(MapViewModel viewModel) {
    final lat = double.tryParse(selectedAddress['lat']?.toString() ?? '');
    final lng = double.tryParse(selectedAddress['lng']?.toString() ?? '');
    if (selectedAddress['address'] == null || lat == null || lng == null) {
      FloatingSnackBar.show(context, 'Pick a location first', isError: true);
      return;
    }

    viewModel.saveAddress(
      widget.addressType,
      selectedAddress['address'],
      describeAddressController.text,
      lat,
      lng,
      onCallBack: () {
        popView(context);
        FloatingSnackBar.show(context, 'Address saved successfully', isError: false);
      },
      onErrorCallBack: (e) {
        FloatingSnackBar.show(context, e!, isError: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.addressType.capitalize();

    return ViewModelBuilder<MapViewModel>.reactive(
      viewModelBuilder: () => widget.viewModel,
      disposeViewModel: false,
      builder: (context, viewModel, child) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const YMargin(20),

              NormalText(
                text: isEditing ? 'Edit $type Address' : 'Add $type Address',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              const YMargin(16),

              GestureDetector(
                onTap: _pickAddress,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: XColors.highlightColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: XColors.primaryColor()),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selectedAddress['address'] ?? 'Selected location',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const YMargin(16),

              MainInputField(
                controller: describeAddressController,
                label: 'Describe address (Optional)',
                keyboard: TextInputType.text,
                hint: 'E.g. My ${widget.addressType}',
                isEnabled: true,
              ),

              const YMargin(24),

              SizedBox(
                width: double.infinity,
                child: XButton(
                  onPressed: () => _save(viewModel),
                  text: "Save Address",
                  isLoading: viewModel.isBusy,
                  buttonColor: XColors.primaryColor(),
                  width: 120,
                ),
              ),
              const YMargin(26),
            ],
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
