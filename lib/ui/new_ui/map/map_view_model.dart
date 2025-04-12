import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_auto_drive/models/places_nearby_model.dart';
import 'package:mobile_auto_drive/models/routes_direction_model.dart' as route_direction;
import 'package:mobile_auto_drive/models/saved_locations_response.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/places_services.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class MapViewModel extends BaseViewModel {
  final _placesService = serviceLocator<PlacesService>();

  final search = TextEditingController();
  GoogleMapController? _mapController;
  Position? currentPosition;
  
  // For nearby places
  List<NearbyPlace>? nearbyPlacesResults = [];
  bool isLoadingNearbyPlaces = false;
  
  // For directions
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  List<String> directions = [];
  List<String> stepManeuver = [];

  LatLng? SOURCE_LOCATION;

  String? sourceAddressName;
  String? destinationAddressName;
  bool infoDisplayed = false;

  route_direction.RouteDirectionsModel? routeDirectionsModel;

  String? searchedPlaceAddress;

  List<Map<String, dynamic>> _recentDestinations = [];
  List<Map<String, dynamic>> _filteredDestinations = [];

  Map<String, dynamic>? homeAddress = {};
  Map<String, dynamic>? workAddress = {};

  List<Map<String, dynamic>> get recentDestinations => _filteredDestinations.isEmpty ? _recentDestinations : _filteredDestinations;

  Future<void> init() async {
    await loadSavedAddresses();
  }

  Future<void> getAddressFromLocation({Function? onCallBack}) async {

    await _placesService.getAddressFromLatLng(
    latlng: "${currentPosition!.latitude},${currentPosition!.longitude}").then((value) async {

      updateSourceAddress(value.results![0].formatted_address);
      setBusy(false);

      if(onCallBack != null) {
        onCallBack();
      }

    });

  }

  Future<void> fetchNearbyPlaces({required String type, int radius = 2500}) async {
    try {

      if (currentPosition == null) {
        await getCurrentLocation();
      }

      Future.microtask((){
        setBusy(true);
      });

      if (_placesService.returnNearbyData(type: type) != null && _placesService.returnNearbyData(type: type)!.nearbyPlaces!.isNotEmpty) {

        final isSameLocation = _placesService.isSameLocation(
          currentPosition!.latitude,
          currentPosition!.longitude
        );
        
        if (isSameLocation) {
          nearbyPlacesResults = _placesService.returnNearbyData(type: type)!.nearbyPlaces;
          Future.microtask((){
            setBusy(false);
          });
          return;
        }
      }

      if (currentPosition != null) {
        await _placesService.getNearbyPlaces(
          lat: currentPosition!.latitude,
          lng: currentPosition!.longitude,
          type: type,
          radius: radius,
        );
        nearbyPlacesResults = _placesService.returnNearbyData(type: type)!.nearbyPlaces;
      }
    } catch (e, stackTrace) {
      print(stackTrace);
      Future.microtask((){
        setBusy(false);
      });
      debugPrint('Error fetching nearby places: $e');
    } finally {
      Future.microtask((){
        setBusy(false);
      });
    }
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    getCurrentLocation();
  }

  GoogleMapController getMapController() {
    return _mapController!;
  }

  void updateSourceAddress(String? v) {
    sourceAddressName = v;
    print(v);
    notifyListeners();
  }

  void updateInfoDisplayed ({bool? v}) {
    infoDisplayed = v!;
    notifyListeners();
  }

  // Save a destination to recent list
  Future<void> saveDestination(Map<String, dynamic> destination) async {
    try {
      // Remove if already exists to avoid duplicates
      _recentDestinations.removeWhere((d) =>
          d['latitude'] == destination['latitude'] &&
          d['longitude'] == destination['longitude']);
      
      // Add to beginning of list
      _recentDestinations.insert(0, {
        ...destination,
        'date': DateTime.now().toIso8601String(),
      });
      
      // Keep only last 10 destinations
      if (_recentDestinations.length > 10) {
        _recentDestinations = _recentDestinations.sublist(0, 10);
      }
      
      // Save to storage
      //await PersistenceService.saveList(RECENT_DESTINATIONS_KEY, _recentDestinations);
      notifyListeners();
    } catch (e) {
      print('Error saving destination: $e');
    }
  }

  // Search destinations
  void searchDestinations(String query) {
    if (query.isEmpty) {
      _filteredDestinations = [];
    } else {
      _filteredDestinations = [
        ..._recentDestinations.where((d) =>
            (d['name']?.toString().toLowerCase() ?? '').contains(query.toLowerCase()) ||
            (d['address']?.toString().toLowerCase() ?? '').contains(query.toLowerCase())),
        if (homeAddress != null &&
            (homeAddress!['address'].toString().toLowerCase().contains(query.toLowerCase()) ||
             'home'.contains(query.toLowerCase())))
          {...homeAddress!, 'name': 'Home'},
        if (workAddress != null &&
            (workAddress!['address'].toString().toLowerCase().contains(query.toLowerCase()) ||
             'work'.contains(query.toLowerCase())))
          {...workAddress!, 'name': 'Work'},
      ];
    }
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      currentPosition = await Geolocator.getCurrentPosition();
      if (currentPosition != null && _mapController != null) {

        _placesService.lastLat = currentPosition!.latitude;
        _placesService.lastLng = currentPosition!.longitude;

        SOURCE_LOCATION = LatLng(currentPosition!.latitude, currentPosition!.longitude);

        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(currentPosition!.latitude, currentPosition!.longitude),
          ),
        );
      }

    } catch (e) {
      print('Error getting location: $e');
    }
  }
  
  // Decode a polyline string into a list of LatLng points
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  // Calculate bounds for a list of LatLng points
  LatLngBounds boundsFromLatLngList(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;

    for (final point in points) {
      if (minLat == null || point.latitude < minLat) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  // Get directions to a destination
  Future<void> plotDirections(LatLng destination) async {

    try {

      if (currentPosition == null) {
        await getCurrentLocation();
      }
      
      if (currentPosition == null) {
        throw Exception('Could not get current location');
      }

      polylines.clear();
      markers.clear();
      directions.clear();

      markers.add(
        Marker(
          markerId: const MarkerId('source'),
          position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      List<LatLng> allPoints = [];
      List<String> stepInstructions = [];

      for (var step in routeDirectionsModel!.payload!.routes![0].steps!) { // Decode polyline for each step

        final List<LatLng> stepPoints = decodePolyline(step.polyline!.encodedPolyline!);
        allPoints.addAll(stepPoints);

        stepInstructions.add(step.navigationInstruction!.instructions!);
        stepManeuver.add(step.navigationInstruction!.maneuver!);
      }

      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: allPoints,
          color: XColors.primaryColor(),
          width: 9,
        ),
      );

      // Set directions for turn-by-turn navigation
      directions = stepInstructions;

      // Fit the map bounds to show the entire route
      if (_mapController != null && allPoints.isNotEmpty) {
        final bounds = boundsFromLatLngList(allPoints);
        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
        );
      }

    } catch (e) {
      debugPrint('Error getting directions: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> getRouteDirection({String? destinationAddress, LatLng? destination, Function? onCallBack, Function? onErrorCallBack, bool? isNearby = false}) async {
    try {

      destinationAddressName = destinationAddress;

      if(isNearby == false) {
        setBusy(true);
      } else {
        setBusyForObject('nearby', true);
      }

      final response = await _placesService.getDirectionPolyPoints(
          origin: "${currentPosition?.latitude},${currentPosition?.longitude}",
          destination: "${destination!.latitude},${destination.longitude}"
      );

      routeDirectionsModel = response;

      if(isNearby == false) {
        setBusy(false);
      } else {
        setBusyForObject('nearby', false);
      }

      onCallBack?.call();

    } catch (e, stacktrace) {
      print(stacktrace);

      if(isNearby == false) {
        setBusy(false);
      } else {
        setBusyForObject('nearby', false);
      }

      setBusyForObject('nearby', false);
      onErrorCallBack?.call(e);

    }
  }

  Future<void> saveDirection(String name, String destinationName, String destinationAddress, LatLng destination) async {
    try {
      // Create direction details
      final Map<String, dynamic> directionDetails = {
        'origin': {
          'lat': currentPosition?.latitude,
          'lng': currentPosition?.longitude,
        },
        'destination': {
          'lat': destination.latitude,
          'lng': destination.longitude,
        },
        'directions': directions,
      };

      // Save using the places service
      final response = await _placesService.savePlace(
        name: name,
        placeId: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a unique ID
        address: destinationAddress,
        savedLocationAs: 'direction',
        savedLocationDescription: 'Saved direction to $destinationName',
        lat: destination.latitude,
        lng: destination.longitude,
        directionDetails: directionDetails,
      );

      print('Direction saved successfully: ${response.message}');
    } catch (e) {
      print('Error saving direction: $e');
    }
  }

  Future<void> loadSavedAddresses() async {
    try {

      SavedLocationsResponse? savedLocationsResponse;

      if(_placesService.savedLocationsResponse != null) {
        savedLocationsResponse = _placesService.savedLocationsResponse!;
      } else {
        savedLocationsResponse = await _placesService.getSavedLocations();
      }

      final locations = savedLocationsResponse.payload;

      // Clear existing destinations
      _recentDestinations = [];

      for (var location in locations!) {
        final addressData = {
          'address': location.address,
          'nickname': location.savedLocationDescription,
          'latitude': location.location!.lat,
          'longitude': location.location!.lng,
          'savedAt': location.createdAt,
          'address_id': location.id,
        };

        if (location.savedLocationAs == 'home') {

          homeAddress = addressData;

        } else if (location.savedLocationAs == 'work') {

          workAddress = addressData;

        } else {

          _recentDestinations.add({
            'name': location.name,
            'address': location.address,
            'latitude': location.location!.lat,
            'longitude': location.location!.lng,
            'date': location.createdAt,
            'directions': location.directionDetails,
            'address_id': location.id,
          });

        }
      }

      _recentDestinations.sort((a, b) => 
        DateTime.parse(b['date'].toString())
            .compareTo(DateTime.parse(a['date'].toString())));

      if (_recentDestinations.length > 10) {
        _recentDestinations = _recentDestinations.sublist(0, 10);
      }

    } catch (e, stacktrace) {
      print(stacktrace.toString());
      print('Error loading saved addresses: $e');
    }
  }

  Future<void> savePlace({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    String description = '',
  }) async {
    try {
      final response = await _placesService.savePlace(
        name: name,
        placeId: DateTime.now().millisecondsSinceEpoch.toString(),
        address: address,
        savedLocationAs: 'place',
        savedLocationDescription: description,
        lat: latitude,
        lng: longitude,
      );

      print('Place saved successfully: ${response.message}');
    } catch (e) {
      print('Error saving place: $e');
    }
  }

  Future<void> saveAddress(
    String addressType,
    String address,
    String description,
    double latitude,
    double longitude, {Function? onCallBack, Function(String? e)? onErrorCallBack}
  ) async {
    try {

      setBusy(true);

      await _placesService.savePlace(
        name: "Saved address for $addressType",
        placeId: DateTime.now().millisecondsSinceEpoch.toString(),
        address: address,
        savedLocationAs: addressType, // 'home' or 'work'
        savedLocationDescription: description,
        lat: latitude,
        lng: longitude,
      ).then((value) {

        // Update local cache
        final addressData = {
          'address': address,
          'nickname': description,
          'latitude': latitude,
          'longitude': longitude,
          'savedAt': DateTime.now().toIso8601String(),
        };

        if (addressType == 'home') {
          homeAddress = addressData;
        } else {
          workAddress = addressData;
        }

        setBusy(false);

        if(onCallBack != null) {
          onCallBack();
        }

      }).onError((error, stackTrace) {

        setBusy(false);

        if(onErrorCallBack != null) {
          onErrorCallBack(error.toString());
        }

      });

    } catch (e) {
      print('Error saving $addressType address: $e');
    }
  }

}