import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class DirectionsScreen extends StatelessWidget {
  final LatLng destination;
  final String destinationName;
  final String destinationAddress;
  final MapViewModel? viewModel;

  const DirectionsScreen({
    Key? key,
    required this.destination,
    required this.destinationName,
    required this.destinationAddress,
    this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      viewModelBuilder: () => viewModel ?? MapViewModel(),
      disposeViewModel: false,
      onViewModelReady: (viewModel) => viewModel.plotDirections(destination),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Directions'),
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
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                tooltip: 'Save Direction',
                onPressed: () => _showSaveDirectionDialog(context, viewModel),
              ),
            ],
          ),
          body: Column(
            children: [
              // Destination info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                          child: Icon(
                            Icons.location_on,
                            color: XColors.primaryColor(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NormalText(
                                text: destinationName,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 4),
                              NormalText(
                                text: destinationAddress,
                                fontSize: 14,
                                textColor: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const YMargin(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem(
                          Icons.access_time,
                          viewModel.routeDirectionsModel?.payload?.routes?.first.duration?.text ?? 'N/A',
                          'Estimated Time'
                        ),
                        _buildInfoItem(
                          Icons.speed,
                          viewModel.routeDirectionsModel?.payload?.routes?.first.distance?.text ?? 'N/A',
                          'Distance'
                        ),
                        _buildInfoItem(
                          Icons.directions_car,
                          _calculateArrivalTime(viewModel.routeDirectionsModel?.payload?.routes?.first.duration?.value ?? 0),
                          'Arrival Time'
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Map with route
              Expanded(
                flex: 2,
                child: viewModel.isBusy
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: destination,
                          zoom: 14.0,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        mapType: MapType.normal,
                        polylines: viewModel.polylines,
                        markers: viewModel.markers,
                        onMapCreated: (GoogleMapController controller) {
                          viewModel.setMapController(controller);
                        },
                      ),
              ),

            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              modalBottomSheetMenu(
                  context: context,
                  radius: 20,
                  color: Colors.white,
                  child: Container(
                    height: 450,
                    child: ListView.builder(
                      itemCount: viewModel.directions.length,
                      itemBuilder: (context, index) {
                        final step = viewModel.directions[index];
                        return _buildDirectionStep(step, index, context: context);
                      },
                    ),
                  ),
              );
            },
            backgroundColor: XColors.primaryColor(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            label: const Text(
              'Start Navigation',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            icon: const Icon(Icons.navigation, color: Colors.white,),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: XColors.primaryColor()),
        const SizedBox(height: 4),
        NormalText(
          text: value,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 2),
        NormalText(
          text: label,
          fontSize: 12,
          textColor: Colors.grey,
        ),
      ],
    );
  }

  String _calculateArrivalTime(int durationInSeconds) {
    if (durationInSeconds == 0) return 'N/A';
    final now = DateTime.now();
    final arrivalTime = now.add(Duration(seconds: durationInSeconds));
    return '${arrivalTime.hour.toString().padLeft(2, '0')}:${arrivalTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildDirectionStep(String instruction, int index, {BuildContext? context}) {

    IconData getManeuverIcon(String maneuver) {
      switch (maneuver.toUpperCase()) {
        case 'TURN_RIGHT':
          return Icons.turn_right;
        case 'TURN_LEFT':
          return Icons.turn_left;
        case 'TURN_SLIGHT_RIGHT':
          return Icons.turn_slight_right;
        case 'TURN_SLIGHT_LEFT':
          return Icons.turn_slight_left;
        case 'TURN_SHARP_RIGHT':
          return Icons.turn_sharp_right;
        case 'TURN_SHARP_LEFT':
          return Icons.turn_sharp_left;
        case 'MERGE':
          return Icons.merge;
        case 'ROUNDABOUT_RIGHT':
        case 'ROUNDABOUT_LEFT':
          return Icons.roundabout_left;
        case 'DEPART':
          return Icons.departure_board;
        case 'ARRIVE':
          return Icons.location_on;
        case 'KEEP_RIGHT':
        case 'KEEP_LEFT':
          return Icons.fork_right;
        case 'UTURN_RIGHT':
        case 'UTURN_LEFT':
          return Icons.u_turn_left;
        default:
          return Icons.straight;
      }
    }

    return InkWell(
      onTap: () {
        if (viewModel!.routeDirectionsModel?.payload?.routes?.isNotEmpty ?? false) {
          final step = viewModel!.routeDirectionsModel!.payload!.routes![0].steps![index];
          final points = viewModel!.decodePolyline(step.polyline!.encodedPolyline!);
          if (points.isNotEmpty) {
            // Calculate the center point of the step's path
            final bounds = viewModel!.boundsFromLatLngList(points);
            final center = LatLng(
              (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
              (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
            );
            
            // Animate camera to center on this step
            viewModel!.getMapController().animateCamera(
              CameraUpdate.newLatLngZoom(center, 16),
            );
            popView(context!);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: XColors.highlightColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                getManeuverIcon(viewModel!.stepManeuver[index]),
                color: XColors.primaryColor(),
                size: 23,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NormalText(
                text: instruction,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Show dialog to save the current direction
  void _showSaveDirectionDialog(BuildContext context, MapViewModel viewModel) {
    final TextEditingController nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Direction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Save this route for future reference'),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'e.g. Home to Work',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  viewModel.saveDirection(
                    nameController.text,
                    destinationName,
                    destinationAddress,
                    destination,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Direction saved successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a name for this direction')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}