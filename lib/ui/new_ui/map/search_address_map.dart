import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_auto_drive/models/PlacesSearchModel/place.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/search_places_view.dart';
import 'package:mobile_auto_drive/utils/api_keys.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class SearchAddressMap extends StatefulWidget {
  const SearchAddressMap({super.key, required this.viewModel});

  final MapViewModel? viewModel;


  @override
  _SearchAddressMapState createState() => _SearchAddressMapState();

}

class _SearchAddressMapState extends State<SearchAddressMap> {

  static Position? currentPosition;
  late BitmapDescriptor sourceLocationIcon;
  String? searchedPlaceAddress;

  Set<Marker> markers = {};

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  Future<void> _setCustomMapPickupLocPin() async {
    sourceLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/location.png');
  }

  @override
  void initState() {
    super.initState();

    _setCustomMapPickupLocPin();

  }

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<MapViewModel>.reactive(
        viewModelBuilder: () => widget.viewModel ?? MapViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) => model.getAddressFromLocation(onCallBack: () {

          model.updateInfoDisplayed(v: true);

          modalBottomSheetMenu(
            isDismissible: false,
            context: context,
            color: Colors.white,
            child: mapActionInfo(model: model, onClick: () {

              Map<String, dynamic> pickedAddressFromMap = {
                "lat": model.SOURCE_LOCATION!.latitude.toString(),
                "lng": model.SOURCE_LOCATION!.longitude.toString(),
                "address": model.sourceAddressName,
              };

              print(pickedAddressFromMap.toString());
              popView(context);
              Navigator.pop(context, pickedAddressFromMap);

            }),
          );

        }),
        builder: (context, model, child) {

          currentPosition = model.currentPosition;
          print(model.sourceAddressName);

          return Scaffold(
          body: Stack(
            fit: StackFit.loose,
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

                  model.setMapController(controller);
                  controller.setMapStyle(MapUtils.mapStyles);
                  markers.add(Marker(markerId: const MarkerId('sourceMarker_id'),
                      position: model.SOURCE_LOCATION!,
                      onTap: (){

                          if(model.infoDisplayed == true) {
                            popView(context);
                            model.updateInfoDisplayed(v: false);
                          }

                          modalBottomSheetMenu(
                            context: context,
                            child: mapActionInfo(model: model, onClick: () {

                              Map<String, dynamic> pickedAddressFromMap = {
                                "lat": model.currentPosition!.latitude.toString(),
                                "lng": model.currentPosition!.longitude.toString(),
                                "address": model.sourceAddressName,
                              };

                              print(pickedAddressFromMap.toString());
                              popView(context);
                              Navigator.pop(context, pickedAddressFromMap);

                            }),
                          );

                      },
                      icon: sourceLocationIcon)
                  );

                },
              ),

              Positioned(
                top: SizeConfig().sh(35) as double?,
                left: SizeConfig().sw(10) as double?,
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded, color: XColors.primaryColor(), size: 32,),
                    onPressed: (){
                      popView(context);
                    }
                ),
              ),

              Positioned(
                top: SizeConfig().sh(95) as double?,
                left: SizeConfig().sw(10) as double?,
                right: SizeConfig().sw(10) as double?,
                child: SearchMapPlace(
                  apiKey: APIKey.googleAPIKey,
                  location: currentPosition == null
                      ? const LatLng(7.3219678, 5.147076)
                      : LatLng(currentPosition!.latitude,
                      currentPosition!.longitude),
                  radius: 5000,
                  onSelected: (place) async {
                    final geolocation = await place.geolocation;

                    final lat = geolocation!.coordinates.latitude;
                    final lng = geolocation.coordinates.longitude;
                    searchedPlaceAddress = place.description;

                    Map<String, dynamic> pickedAddressFromMap = {
                      "lat": lat.toString(),
                      "lng": lng.toString(),
                      "address": searchedPlaceAddress
                    };

                    Navigator.pop(context, pickedAddressFromMap);

                  },
                ),
              ),

            ],
          ),
        );

      }
    );
  }

  Widget mapActionInfo({
    required MapViewModel model,
    Function? onClick}) {

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 19, right: 19),
        child: Column(
          children: [
            const YMargin(15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    popView(context);
                    model.updateInfoDisplayed(v: false);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.close,
                          color: XColors.black(), size: 26),
                    ],
                  ),
                ),
              ],
            ),
            MkText('Your current location',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: XColors.primaryColor(),
                )),
            const YMargin(25),
            Row(
              children: [
                Image.asset(
                  'assets/images/location.png',
                  scale: 1.5,
                ),
                const XMargin(10),
                Container(
                  width: SizeConfig.screenWidthDp! - 90,
                  child: MkText(model.sourceAddressName!,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: XColors.black(),
                      ),
                  ),
                ),
              ],
            ),
            const YMargin(30),
            XButton(
              isLoading: model.isBusy,
              onPressed: () {
                onClick!();
              },
              text: 'Use your current location?',
              height: 56,
              textColor: Colors.white,
              buttonColor: XColors.primaryColor(),
              progressColor: Colors.white,
              radius: 26,
              width: SizeConfig().sw(400) as double?,
            ),
            const YMargin(60),
          ],
        ),
      ),
    );
  }
}
