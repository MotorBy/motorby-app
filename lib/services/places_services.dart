import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:mobile_auto_drive/models/LatLngAddressModel.dart';
import 'package:mobile_auto_drive/models/places_nearby_model.dart';
import 'package:mobile_auto_drive/models/routes_direction_model.dart';
import 'package:mobile_auto_drive/models/saved_place_model.dart';
import 'package:mobile_auto_drive/models/saved_locations_response.dart';
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/api_keys.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

class PlacesService {
  final persistService = serviceLocator<PersistenceService>();
  final apiHelper = APIHelper();
  
  // Store last request details
  double? lastLat;
  double? lastLng;
  LatLngAddressModel? currentLatLngAddressModel;
  SavedLocationsResponse? savedLocationsResponse;
  RouteDirectionsModel? routeDirectionsModel;

  PlacesNearby? nearbyPlaces;
  PlacesNearby? nearbyPlaces2;

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    // Convert latitude and longitude to radians
    final double lat1Rad = lat1 * (3.1415926535897932 / 180);
    final double lon1Rad = lon1 * (3.1415926535897932 / 180);
    final double lat2Rad = lat2 * (3.1415926535897932 / 180);
    final double lon2Rad = lon2 * (3.1415926535897932 / 180);
    
    // Calculate differences
    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;
    
    // Haversine formula
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c; // Distance in kilometers
  }

  bool isSameLocation(double lat, double lng) {
    if (lastLat == null || lastLng == null) return false;
    
    final distance = _calculateDistance(lastLat!, lastLng!, lat, lng);
    return distance < 3; // Return true if distance is less than 3 kilometers
  }

  PlacesNearby? returnNearbyData({String? type}) {
    var placesNearby = type == "gas_station" ? nearbyPlaces : nearbyPlaces2;
    return placesNearby;
  }

  Future<PlacesNearby> getNearbyPlaces({
    required double lat,
    required double lng,
    required String type,
    int radius = 2500,
  }) async {
    try {
      
      final url = Uri.parse('${APIService.root}directions/nearby?type=$type&radius=$radius&location=$lat,$lng');
      final response = await http.get(
        url,
        headers: apiHelper.requestHeadersWithToken(),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        lastLat = lat;
        lastLng = lng;

        if (type == "gas_station") {
          nearbyPlaces = PlacesNearby.fromJson(json);
          return nearbyPlaces!;
        } else {
          nearbyPlaces2 = PlacesNearby.fromJson(json);
          return nearbyPlaces2!;
        }

      } else {
        var error = json["message"] ?? 'Unknown server error';
        throw Exception(error);
      }

    } catch (e) {
      throw Exception('Failed to fetch nearby places: $e');
    }
  }

  Future<SavedPlaceResponse> savePlace({
    required String name,
    required String placeId,
    required String address,
    required String savedLocationAs,
    required String savedLocationDescription,
    required double lat,
    required double lng,
    Map<String, dynamic>? directionDetails,
  }) async {
    try {
      final url = Uri.parse('${APIService.root}directions/place');
      final body = {
        'name': name,
        'placeId': placeId,
        'address': address,
        'savedLocationAs': savedLocationAs,
        'savedLocationDescription': savedLocationDescription,
        'location': {
          'lat': lat,
          'lng': lng,
        },
        if (directionDetails != null) 'directionDetails': directionDetails,
      };

      final response = await http.post(
        url,
        headers: apiHelper.requestHeadersWithToken(),
        body: jsonEncode(body),
      );

      final json = jsonDecode(response.body);

      if(response.statusCode == 200 || response.statusCode == 201) {

        return SavedPlaceResponse.fromJson(json);

      } else {
        var error = json["message"];
        throw Exception(error);
      }

    } catch (e) {
      throw Exception('Failed to save place: $e');
    }
  }

  Future<LatLngAddressModel> getAddressFromLatLng(
      {required String latlng}) async {

    print("${APIService.googleDirections}latlng=$latlng&key=${APIKey.googleAPIKey}&language=en");

    var result = await http.get(Uri.parse("${APIService.googleLatLngAddress}latlng=$latlng&key=${APIKey.googleAPIKey}&language=en"));

    final json = jsonDecode(result.body);
    print(json);

    if (json["status"] == "OK") {

      LatLngAddressModel latLngAddressModelResponse = LatLngAddressModel.fromJson(json);
      currentLatLngAddressModel = latLngAddressModelResponse;
      return latLngAddressModelResponse;

    } else {
      var error = json["status"];
      throw Exception(error);
    }
  }

  Future getDirectionPolyPoints({
    required String origin,
    required String destination,
  }) async {

    var result = await http.get(
      Uri.parse("${APIService.root}/directions/route-details?destination=$destination&origin=$origin"),
      headers: apiHelper.requestHeadersWithToken(),
    );
    final json = jsonDecode(result.body);

    print(json.toString());

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {

      routeDirectionsModel = RouteDirectionsModel.fromJson(json);
      return routeDirectionsModel!;

    } else {
      var error = json["status"];
      throw Exception(error);
    }
  }

  Future<SavedLocationsResponse> getSavedLocations() async {
    try {
      final url = Uri.parse('${APIService.root}directions/saved');
      final response = await http.get(
        url,
        headers: apiHelper.requestHeadersWithToken(),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        savedLocationsResponse = SavedLocationsResponse.fromJson(json);
        return savedLocationsResponse!;
      } else {
        throw Exception(json["message"]);
      }
    } catch (e) {
      throw Exception('Failed to fetch saved locations: $e');
    }
  }

}