class SavedPlaceResponse {
  int? statusCode;
  String? message;
  SavedPlacePayload? payload;

  SavedPlaceResponse({
    this.statusCode,
    this.message,
    this.payload,
  });

  factory SavedPlaceResponse.fromJson(Map<String, dynamic> json) => SavedPlaceResponse(
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? null : SavedPlacePayload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": payload?.toJson(),
  };
}

class SavedPlacePayload {
  String? user;
  String? name;
  String? placeId;
  String? address;
  Location? location;
  String? savedLocationAs;
  String? savedLocationDescription;
  String? type;
  NearbyPlacesData? nearbyPlacesData;
  DirectionDetails? directionDetails;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  SavedPlacePayload({
    this.user,
    this.name,
    this.placeId,
    this.address,
    this.location,
    this.savedLocationAs,
    this.savedLocationDescription,
    this.directionDetails,
    this.type,
    this.nearbyPlacesData,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory SavedPlacePayload.fromJson(Map<String, dynamic> json) => SavedPlacePayload(
    user: json["user"],
    name: json["name"],
    placeId: json["placeId"],
    address: json["address"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    savedLocationAs: json["savedLocationAs"],
    savedLocationDescription: json["savedLocationDescription"],
    directionDetails: json["directionDetails"] == null ? null : DirectionDetails.fromJson(json["directionDetails"]),
    type: json["type"],
    nearbyPlacesData: json["nearbyPlacesData"] == null ? null : NearbyPlacesData.fromJson(json["nearbyPlacesData"]),
    id: json["_id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "name": name,
    "placeId": placeId,
    "address": address,
    "location": location?.toJson(),
    "savedLocationAs": savedLocationAs,
    "savedLocationDescription": savedLocationDescription,
    "directionDetails": directionDetails?.toJson(),
    "type": type,
    "nearbyPlacesData": nearbyPlacesData?.toJson(),
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class DirectionDetails {
  Destination? origin;
  Destination? destination;

  DirectionDetails({
    this.origin,
    this.destination,
  });

  factory DirectionDetails.fromJson(Map<String, dynamic> json) => DirectionDetails(
    origin: json["origin"] == null ? null : Destination.fromJson(json["origin"]),
    destination: json["destination"] == null ? null : Destination.fromJson(json["destination"]),
  );

  Map<String, dynamic> toJson() => {
    "origin": origin?.toJson(),
    "destination": destination?.toJson(),
  };
}

class Destination {
  double? lat;
  double? lng;
  String? address;

  Destination({
    this.lat,
    this.lng,
    this.address,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
    "address": address,
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
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class NearbyPlacesData {
  List<dynamic>? places;

  NearbyPlacesData({
    this.places,
  });

  factory NearbyPlacesData.fromJson(Map<String, dynamic> json) => NearbyPlacesData(
    places: json["places"] == null ? [] : List<dynamic>.from(json["places"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "places": places == null ? [] : List<dynamic>.from(places!.map((x) => x)),
  };
}