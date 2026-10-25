import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_selector_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav_vmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/directions/directions_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/nearby/nearby_places_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/addresses/past_destinations_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/addresses/saved_addresses_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/search/search_places_view.dart';
import 'package:mobile_auto_drive/utils/api_keys.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:stacked/stacked.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.isFromQuickActions = false});

  final bool isFromQuickActions;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
        viewModelBuilder: () => MapViewModel(),
        onViewModelReady: (model) {
          model.init();
        },
        builder: (context, viewModel, child) {
          print(widget.isFromQuickActions);
          return Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(6.5244, 3.3792), // Default to Lagos coordinates
                    zoom: 14.0,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    viewModel.setMapController(controller);
                  },
                ),
                if(widget.isFromQuickActions == true) ... [
                  Positioned(
                    top: 50,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            )
                          ]
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20)
                      ),
                    ),
                  )
                ],
                Positioned(
                  bottom: 20,
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
                  textColor: XColors.black().withOpacity(0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void _showLocationSearchBottomSheet(BuildContext context, MapViewModel model) {
  modalBottomSheetMenu(
    context: context,
    radius: 20,
    height: 720,
    color: XColors.background(),
    child: ViewModelBuilder<MapViewModel>.reactive(
        viewModelBuilder: () => model,
        disposeViewModel: false,
        onViewModelReady: (model) {
          model.init();
        },
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
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

                // Search place field
                SearchMapPlace(
                  apiKey: APIKey.googleAPIKey,
                  isEnabled: !model.isBusy,
                  location: viewModel.currentPosition == null
                      ? const LatLng(7.3219678, 5.147076)
                      : LatLng(viewModel.currentPosition!.latitude,
                      viewModel.currentPosition!.longitude),
                  radius: 5000,
                  onSelected: (place) async {
                    final geolocation = await place.geolocation;

                    final lat = geolocation!.coordinates.latitude;
                    final lng = geolocation.coordinates.longitude;
                    viewModel.searchedPlaceAddress = place.description;

                    Map<String, dynamic> pickedAddressFromMap = {
                      "lat": lat.toString(),
                      "lng": lng.toString(),
                      "address": viewModel.searchedPlaceAddress
                    };

                    print(pickedAddressFromMap);
                    //Navigator.pop(context, pickedAddressFromMap);

                    viewModel.getRouteDirection(
                        destinationAddress: pickedAddressFromMap['address'],
                        destination: LatLng(
                          double.parse(pickedAddressFromMap['lat']),
                          double.parse(pickedAddressFromMap['lng']),
                        ),
                        onCallBack: () {

                          navigate(context, DirectionsScreen(
                            destination: LatLng(
                              double.parse(pickedAddressFromMap['lat']),
                              double.parse(pickedAddressFromMap['lng']),
                            ),
                            destinationName: "You are going to",
                            viewModel: viewModel,
                            destinationAddress: pickedAddressFromMap['address'],
                          ));

                        },
                        onErrorCallBack: (e) {

                        }
                    );

                  },
                ),

                const YMargin(20),

                CarSelectorView(
                    cars: model.getBudgetData(),
                    currentCar: model.getCurrentCar() != null ? '${model.getCurrentCar()!.carMake} ${model.getCurrentCar()!.carModel} ${model.getCurrentCar()!.carYear}' : null,
                    onCarSelected: ({Budget? budget, int? index}){
                      model.getCurrentCar(index: index);
                      model.notifyListeners();
                    }
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NearbyPlacesScreen(
                                viewModel: viewModel,
                                placeType: 'car_repair',
                                title: 'Nearest Repair Shops',
                              ),
                            ),
                          );
                        },
                        description: 'View nearby repair shops',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNearbyOption(
                        title: 'Gas Station',
                        iconPath: 'assets/images/icons/gas-station.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NearbyPlacesScreen(
                                viewModel: viewModel,
                                placeType: 'gas_station',
                                title: 'Nearest Gas Stations',
                              ),
                            ),
                          );
                        },
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
                _buildSavedLocationItem(
                  'Home',
                  viewModel.homeAddress != null && viewModel.homeAddress!.isNotEmpty
                      ? viewModel.homeAddress!['address'] ?? 'Add home address'
                      : 'Add home address',
                  Icons.home_outlined,
                  () {
                    navigate(context, SavedAddressesScreen(viewModel: viewModel));
                  }
                ),
                const Divider(),
                _buildSavedLocationItem(
                  'Work',
                  viewModel.workAddress != null && viewModel.workAddress!.isNotEmpty
                      ? viewModel.workAddress!['address'] ?? 'Add work address'
                      : 'Add work address',
                  Icons.work_outline,
                  () {
                    navigate(context, SavedAddressesScreen(viewModel: viewModel));
                  }
                ),
                const Divider(),
                _buildSavedLocationItem('Past', 'View past destinations', Icons.history, () {
                  navigate(context, const PastDestinationsScreen());
                }),
              ],
            ),
                    ),
          );
      }
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
                  textColor: XColors.black(),
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 4),
                NormalText(
                  text: subtitle,
                  fontSize: 14,
                  textColor: XColors.black().withOpacity(0.6),
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
