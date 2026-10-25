import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/addresses/address_form_sheet.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/directions/directions_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
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
          backgroundColor: XColors.background(),
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: 'Saved Addresses',
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
                  () => showAddressFormSheet(context, viewModel, 'home'),
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
                  () => showAddressFormSheet(context, viewModel, 'work'),
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
    
    return ContainerWidget(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
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
}
