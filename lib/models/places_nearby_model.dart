class PlacesNearby {
  int? statusCode;
  String? message;
  List<NearbyPlace>? nearbyPlaces;

  PlacesNearby({
    this.statusCode,
    this.message,
    this.nearbyPlaces,
  });

  factory PlacesNearby.fromJson(Map<String, dynamic> json) => PlacesNearby(
    statusCode: json["statusCode"],
    message: json["message"]?.toString(),
    nearbyPlaces: json["payload"] == null
        ? []
        : List<NearbyPlace>.from(
            (json["payload"] as List).map((x) => NearbyPlace.fromJson(x as Map<String, dynamic>)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": nearbyPlaces == null ? [] : List<dynamic>.from(nearbyPlaces!.map((x) => x.toJson())),
  };
}

class NearbyPlace {
  Location? location;
  String? name;
  String? placeId;
  String? vicinity;
  BusinessStatus? businessStatus;
  double? rating;
  int? userRatingsTotal;
  List<String>? types;
  String? icon;
  double? distance;
  String? id;

  NearbyPlace({
    this.location,
    this.name,
    this.placeId,
    this.vicinity,
    this.businessStatus,
    this.rating,
    this.userRatingsTotal,
    this.types,
    this.icon,
    this.distance,
    this.id,
  });

  factory NearbyPlace.fromJson(Map<String, dynamic> json) => NearbyPlace(
    location: json["location"] == null ? null : Location.fromJson(json["location"] as Map<String, dynamic>),
    name: json["name"]?.toString(),
    placeId: json["place_id"]?.toString(),
    vicinity: json["vicinity"]?.toString(),
    businessStatus: json["business_status"] != null ? businessStatusValues.map[json["business_status"]] : null,
    rating: (json["rating"] as num?)?.toDouble(),
    userRatingsTotal: (json["user_ratings_total"] as num?)?.toInt(),
    types: json["types"] == null
        ? []
        : List<String>.from((json["types"] as List).map((x) => x.toString())),
    icon: json["icon"]?.toString(),
    distance: (json["distance"] as num?)?.toDouble(),
    id: json["_id"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "name": name,
    "place_id": placeId,
    "vicinity": vicinity,
    "business_status": businessStatusValues.reverse[businessStatus],
    "rating": rating,
    "user_ratings_total": userRatingsTotal,
    "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    "icon": icon,
    "distance": distance,
    "_id": id,
  };
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: (json["lat"] as num?)?.toDouble(),
    lng: (json["lng"] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

enum BusinessStatus {
  EMPTY,
  OPERATIONAL,
  CLOSED_TEMPORARILY,
  CLOSED_PERMANENTLY
}

final businessStatusValues = EnumValues({
  "": BusinessStatus.EMPTY,
  "OPERATIONAL": BusinessStatus.OPERATIONAL,
  "CLOSED_TEMPORARILY": BusinessStatus.CLOSED_TEMPORARILY,
  "CLOSED_PERMANENTLY": BusinessStatus.CLOSED_PERMANENTLY,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
