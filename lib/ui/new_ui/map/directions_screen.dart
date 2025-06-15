import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/direction_icon.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'dart:async';

class DirectionsScreen extends StatefulWidget {
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
  State<DirectionsScreen> createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends State<DirectionsScreen> with SingleTickerProviderStateMixin {

  Timer? _locationTimer;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      viewModelBuilder: () => widget.viewModel ?? MapViewModel(),
      disposeViewModel: false,
      onViewModelReady: (viewModel) {
        viewModel.plotDirections(widget.destination);

        // _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
        //   viewModel.getCurrentLocation();
        // });

      },
      onDispose: (viewModel) {
        //_locationTimer?.cancel();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: appBarHeader(
            hasOnBack: true,
            onCloseAction: (){
              popView(context);
            },
            context: context,
            appBarTitle: 'Directions',
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
              
              // Destination info container
              ContainerWidget(
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
                                text: widget.destinationName,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 4),
                              NormalText(
                                text: widget.destinationAddress,
                                fontSize: 14,
                                textColor: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            viewModel.setOpenDirectionMetricView();
                            if (viewModel.openDirectionMetricView!) {
                              _controller.forward();
                            } else {
                              _controller.reverse();
                            }
                          },
                          child: Container(
                            child: RotationTransition(
                              turns: Tween(begin: 0.0, end: 0.5).animate(_animation),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: XColors.primaryColor(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizeTransition(
                      sizeFactor: _animation,
                      child: Column(
                        children: [
                          const YMargin(16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoItem(
                                  Icons.access_time,
                                  viewModel.routeDirectionsModel?.payload?.routes?.first.duration?.text ?? 'N/A',
                                  'Estimated Time'),
                              _buildInfoItem(
                                  Icons.speed,
                                  viewModel.routeDirectionsModel?.payload?.routes?.first.distance?.text ?? 'N/A',
                                  'Distance'),
                              _buildInfoItem(
                                  Icons.directions_car,
                                  _calculateArrivalTime(viewModel.routeDirectionsModel?.payload?.routes?.first.duration?.value ?? 0),
                                  'Arrival Time'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              ///TODO: to be revisited
              // Current location info
              if(viewModel.openCurrentDirectionView!) ... [
                ContainerWidget(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: XColors.primaryColor().withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          getManeuverIcon(viewModel.stepManeuver[viewModel.currentDirectionStepIndex ?? 0]),
                          color: XColors.primaryColor(),
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NormalText(
                              text: 'current direction',
                              fontSize: 14,
                              textColor: Colors.grey[700],
                            ),
                            const SizedBox(height: 8),
                            NormalText(
                              text: viewModel.currentDirection!,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              textColor: XColors.primaryColor(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          viewModel.setOpenCurrentDirectionsView(shouldOpen: false);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: XColors.primaryColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              Expanded(
                flex: 2,
                child: viewModel.isBusy
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: widget.destination,
                          zoom: 14.0,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
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

                      // Get current direction step based on location
                      //final currentStepIndex = viewModel.getCurrentDirectionStepIndex(currentStep: index);
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
              'View Directions',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 17
              ),
            ),
            icon: Transform.rotate(
              angle: 45 * 3.14 / 180,
              child: const Icon(
                Icons.navigation,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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

    return InkWell(
      onTap: () {
        if (widget.viewModel!.routeDirectionsModel?.payload?.routes?.isNotEmpty ?? false) {

          final step = widget.viewModel!.routeDirectionsModel!.payload!.routes![0].steps![index];
          final points = widget.viewModel!.decodePolyline(step.polyline!.encodedPolyline!);

          if (points.isNotEmpty) {
            // Calculate the center point of the step's path
            final bounds = widget.viewModel!.boundsFromLatLngList(points);
            final center = LatLng(
              (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
              (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
            );

            // Animate camera to center on this step
            widget.viewModel!.getMapController().animateCamera(CameraUpdate.newLatLngZoom(center, 16));

            // Set all current needed directions data to viewmodel
            widget.viewModel!.setOpenCurrentDirectionsView(shouldOpen: true);
            widget.viewModel!.setCurrentDirection(currentDir: instruction);
            widget.viewModel!.getCurrentDirectionStepIndex(currentStep: index);
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
                getManeuverIcon(widget.viewModel!.stepManeuver[index]),
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

    modalBottomSheetMenu(
      context: context,
      radius: 20,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const NormalText(
                  text: 'Save Direction',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const YMargin(16),
            NormalText(
              text: 'Save this route for future reference',
              fontSize: 16,
              textColor: Colors.grey[600],
            ),
            const YMargin(20),
            MainInputField(
              controller: nameController,
              label: 'Name',
              hint: 'e.g. Home to Work',
              isEnabled: true,
              onChanged: (s) {

              },
            ),
            const YMargin(44),
            XButton(
              text: 'Save Direction',
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  viewModel.saveDirection(
                    nameController.text,
                    widget.destinationName,
                    widget.destinationAddress,
                    widget.destination,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Direction saved successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Please enter a name for this direction')),
                  );
                }
              },
              height: 56,
              textColor: Colors.white,
              buttonColor: XColors.primaryColor(),
              progressColor: Colors.white,
              isLoading: viewModel.isBusy,
              radius: 26,
              width: SizeConfig().sw(400) as double?,
            ),
            const YMargin(16),
          ],
        ),
      ),
    );
  }
}
