import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/directions_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/search_address_map.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SavedAddressesScreen extends StatelessWidget {

  final MapViewModel? viewModel;

  const SavedAddressesScreen({Key? key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      viewModelBuilder: () => viewModel ?? MapViewModel(),
      disposeViewModel: false,
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Saved Addresses"),
            titleTextStyle: TextStyle(
              color: XColors.textColor(),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: XColors.highlightColor().withOpacity(0.1),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Home address section
                _buildAddressSection(
                  context,
                  viewModel,
                  'Home Address',
                  'Add your home address for quick navigation',
                  Icons.home_outlined,
                  () => _showAddressForm(context, viewModel, 'home'),
                  viewModel.homeAddress,
                ),
                const YMargin(24),
                
                // Work address section
                _buildAddressSection(
                  context,
                  viewModel,
                  'Work Address',
                  'Add your work address for quick navigation',
                  Icons.work_outline,
                  () => _showAddressForm(context, viewModel, 'work'),
                  viewModel.workAddress,
                ),
                
                const Spacer(),
                // Info text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: XColors.highlightColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: XColors.primaryColor()),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: NormalText(
                          text: 'Saved addresses allow you to quickly navigate to your frequent destinations.',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressSection(
    BuildContext context,
    MapViewModel viewModel,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    Map<String, dynamic>? addressData,
  ) {
    final bool hasAddress = addressData != null && addressData.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: XColors.primaryColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: XColors.primaryColor()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      text: title,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    NormalText(
                      text: hasAddress ? addressData['address'] : subtitle,
                      fontSize: 14,
                      textColor: hasAddress ? Colors.black87 : Colors.grey,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  hasAddress ? Icons.edit : Icons.add_circle_outline,
                  color: XColors.primaryColor(),
                ),
                onPressed: onTap,
              ),
            ],
          ),
          if (hasAddress) ...[  
            const YMargin(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                XButton(
                  onPressed: () {

                    viewModel.getRouteDirection(
                        destinationAddress: addressData['address'],
                        destination: LatLng(
                          addressData['latitude'],
                          addressData['longitude'],
                        ),
                      onCallBack: () {

                        navigate(context, DirectionsScreen(
                          destination: LatLng(
                            addressData['latitude'],
                            addressData['longitude'],
                          ),
                          destinationName: title,
                          viewModel: viewModel,
                          destinationAddress: addressData['address'],
                        ));

                      },
                      onErrorCallBack: (e) {

                      }
                    );

                  },
                  text: 'Navigate',
                  textColor: XColors.primaryColor(),
                  buttonColor: Colors.white,
                  isOutline: true,
                  isLoading: viewModel.destinationAddressName == addressData['address'] ? viewModel.isBusy : false,
                  width: 100,
                  height: 46,
                ),

                // TextButton.icon(
                //   onPressed: () {
                //     // Delete this address
                //     _showDeleteConfirmation(context, viewModel, title.toLowerCase().split(' ')[0]);
                //   },
                //   icon: const Icon(Icons.delete_outline, color: Colors.red),
                //   label: const NormalText(
                //     text: 'Delete',
                //     fontSize: 14,
                //     textColor: Colors.red,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showAddressForm(BuildContext context, MapViewModel viewModel, String addressType) {
    final TextEditingController describeAddressController = TextEditingController();

    Map<String, dynamic>? existingAddress = addressType == 'home' ? viewModel.homeAddress : viewModel.workAddress;
    Map<String, dynamic>? addressFromMap = {};
    
    if (existingAddress != null) {
      describeAddressController.text = existingAddress['nickname'] ?? '';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ViewModelBuilder<MapViewModel>.reactive(
          viewModelBuilder: () => viewModel,
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
                // Handle bar at top
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
                  text: existingAddress != null ? 'Edit ${addressType.capitalize()} Address' : 'Add ${addressType.capitalize()} Address',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const YMargin(16),

                // Selected address display
                GestureDetector(
                  onTap: () async {

                    final result = await Navigator.push<Map<String, dynamic>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchAddressMap(viewModel: viewModel,),
                      ),
                    );

                    if(result != null) {
                      addressFromMap =  result;
                      viewModel.notifyListeners();
                    }

                  },
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
                            addressFromMap!['address'] ?? 'Selected location',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const YMargin(16),

                // Nickname field
                TextField(
                  controller: describeAddressController,
                  decoration: InputDecoration(
                    labelText: 'Describe address (Optional)',
                    hintText: 'E.g. My ${addressType}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.label_outline),
                  ),
                ),

                const YMargin(24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: XButton(
                    onPressed: () {

                      // Save the address with selected location
                      viewModel.saveAddress(
                        addressType,
                        addressFromMap!['address'],
                        describeAddressController.text,
                        double.parse(addressFromMap!['lat']),
                      double.parse(addressFromMap!['lng']),
                        onCallBack: (){

                          popView(context);

                          FloatingSnackBar.show(
                              context,
                              'Address saved successfully',
                              isError: false
                          );

                        },
                        onErrorCallBack: (e) {

                          FloatingSnackBar.show(
                              context,
                              e!,
                              isError: true
                          );

                        }
                      );

                    },
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
        }
      ),
    );}
  }

  void _showDeleteConfirmation(BuildContext context, MapViewModel viewModel, String addressType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${addressType.capitalize()} Address'),
          content: Text('Are you sure you want to delete your ${addressType} address?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {

              },
              child: const NormalText(
                text: 'Delete',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

// Helper extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
