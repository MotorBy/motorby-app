import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_auto_drive/models/places_nearby_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/directions/directions_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class NearbyPlacesScreen extends StatelessWidget {
  final String placeType;
  final String title;
  final MapViewModel? viewModel;

  const NearbyPlacesScreen({
    Key? key,
    required this.placeType,
    required this.title,
    this.viewModel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      viewModelBuilder: () => viewModel ?? MapViewModel(),
      disposeViewModel: false,
      onViewModelReady: (viewModel) => viewModel.fetchNearbyPlaces(type: placeType),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: XColors.background(),
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: title,
          ),
          body: viewModel.isBusy
              ? const Center(child: Loader())
              : viewModel.nearbyPlacesResults!.isEmpty
                  ? const Center(child: Text('No places found nearby'))
                  : ListView.builder(
                      itemCount: viewModel.nearbyPlacesResults!.length,
                      itemBuilder: (context, index) {
                        final place = viewModel.nearbyPlacesResults![index];
                        return _buildPlaceItem(context, place, viewModel);
                      },
          ),
        );
      },
    );
  }

  Widget _buildPlaceItem(BuildContext context, NearbyPlace place, MapViewModel viewModel) {
    // Calculate distance and time (would be provided by the API in a real app)
    final distance = '${(place.location!.lat ?? 0.0).toStringAsFixed(1)}km'; // Placeholder
    final time = '${(place.location!.lng ?? 0.0).toStringAsFixed(0)}mins'; // Placeholder

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: XColors.primaryColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Icon(
                      placeType == 'gas_station' ? Icons.local_gas_station : Icons.car_repair,
                      color: XColors.primaryColor(),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormalText(
                        text: place.name ?? 'Unknown Place',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 4),
                      NormalText(
                        text: place.vicinity ?? 'No address available',
                        fontSize: 14,
                        textColor: Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          NormalText(
                            text: '$time / $distance',
                            fontSize: 12,
                            textColor: XColors.primaryColor(),
                            fontWeight: FontWeight.w500,
                          ),
                          if (place.rating != null) ...[  
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                NormalText(
                                  text: place.rating.toString(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {

              viewModel.getRouteDirection(
                  isNearby: true,
                  destinationAddress: place.name,
                  destination: LatLng(
                    place.location!.lat!,
                    place.location!.lng!,
                  ),
                  onCallBack: () {

                    navigate(context, DirectionsScreen(
                      destination: LatLng(
                        place.location!.lat!,
                        place.location!.lng!,
                      ),
                      destinationName: title,
                      viewModel: viewModel,
                      destinationAddress: place.name!,
                    ));

                  },
                  onErrorCallBack: (e) {

                  }
              );

            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Center(
                child: viewModel.busy('nearby') ? viewModel.destinationAddressName != place.name ? const NormalText(
                  text: 'Get Direction',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.blue,
                ) : const Loader() : const NormalText(
                  text: 'Get Direction',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}