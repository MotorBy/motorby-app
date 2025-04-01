import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav_vmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:stacked/stacked.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
        viewModelBuilder: () => MapViewModel(),
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
                 backgroundColor: XColors.highlightColor().withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
              title: buildField(
                context,
                viewModel,
                'Try gas station, repair shops',
                viewModel.search,
                () {},
                false,
                const GetSvgImage(
                  image: 'assets/images/search-icon.svg',
                  boxFit: BoxFit.scaleDown,
                ),
              ),
            ),
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(6.5244, 3.3792), // Default to Lagos coordinates
                    zoom: 14.0,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    viewModel.setMapController(controller);
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _showLocationSearchBottomSheet(context, viewModel),
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 16),
                          GetSvgImage(
                            image: 'assets/images/search-icon.svg',
                            boxFit: BoxFit.scaleDown,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: NormalText(
                              text: 'Where to?',
                              fontSize: 16,
                              textColor: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
    );
  }
}

Widget buildField(
    BuildContext context,
    MapViewModel model,
    String label,
    TextEditingController controller,
    Function() function,
    bool isReadOnly,
    Widget? preficIcon,
    [int? maxLine,
    Color? background]) {
  return TextFormField(
    decoration: InputDecoration(
      border: InputBorder.none,   
      hintText: label,
      prefixIcon: preficIcon,
      filled: true,
      fillColor: background ??  XColors.highlightColor().withOpacity(0.1),
    ),
    maxLines: maxLine,
    readOnly: isReadOnly,
    controller: controller,
    onTap: function,
  );
}

Widget _buildNearbyOption({String? title, String? iconPath, VoidCallback? onTap, String? description}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath!,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NormalText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                NormalText(
                  text: description,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void _showLocationSearchBottomSheet(BuildContext context, MapViewModel viewModel) {
  modalBottomSheetMenu(
    context: context,
    radius: 20,
    //height: MediaQuery.of(context).size.height * 0.7,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
          
          // Search field
          Container(
            decoration: BoxDecoration(
              color: XColors.highlightColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: buildField(
              context,
              viewModel,
              'Search for a destination',
              viewModel.search,
              () {},
              false,
              const GetSvgImage(
                image: 'assets/images/search-icon.svg',
                boxFit: BoxFit.scaleDown,
              ),
            ),
          ),
          const YMargin(20),
          
          // Car information section
          Container(
            padding: const EdgeInsets.all(12),
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
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: XColors.highlightColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: GetSvgImage(
                      image: 'assets/images/auto/toyota_se.svg',
                      boxFit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormalText(
                        text: 'Toyota Camry',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 4),
                      NormalText(
                        text: 'ABC-123-XYZ',
                        fontSize: 14,
                        textColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const YMargin(20),
          
          // Nearby locations section
          const NormalText(
            text: 'Nearby',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          const YMargin(12),
          Row(
            children: [
              Expanded(
                child: _buildNearbyOption(
                  title: 'Repair Shop',
                  iconPath: 'assets/images/icons/repairing.png',
                  onTap: () {},
                  description: 'View nearby repair shops',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNearbyOption(
                  title: 'Gas Station',
                  iconPath: 'assets/images/icons/gas-station.png',
                  onTap: () {},
                  description: 'View nearby gas stations',
                ),
              ),
            ],
          ),
          const YMargin(20),
          
          // Saved locations section
          const NormalText(
            text: 'Saved Places',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          const YMargin(12),
          _buildSavedLocationItem('Home', 'Add home address', Icons.home_outlined, () {}),
          const Divider(),
          _buildSavedLocationItem('Work', 'Add work address', Icons.work_outline, () {}),
          const Divider(),
          _buildSavedLocationItem('Past', 'View past destinations', Icons.history, () {}),
        ],
      ),
    ),
  );
}

Widget _buildSavedLocationItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: XColors.highlightColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: XColors.primaryColor()),
          ),
          const SizedBox(width: 16),
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
                  text: subtitle,
                  fontSize: 14,
                  textColor: Colors.grey,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    ),
  );
}
