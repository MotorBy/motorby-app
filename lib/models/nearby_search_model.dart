import 'dart:convert';

NearbySearchModel gasStationSearchModelFromJson(String str) => NearbySearchModel.fromJson(json.decode(str));

String gasStationSearchModelToJson(NearbySearchModel data) => json.encode(data.toJson());

class NearbySearchModel {
  List<dynamic>? htmlAttributions;
  String? status;
  List<SearchPlaces>? results;

  NearbySearchModel({
    this.htmlAttributions,
    this.status,
    this.results,
  });

  factory NearbySearchModel.fromJson(Map<String, dynamic> json) => NearbySearchModel(
    htmlAttributions: List<dynamic>.from(json["html_attributions"].map((x) => x)),
    status: json["status"],
    results: List<SearchPlaces>.from(json["results"].map((x) => SearchPlaces.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "html_attributions": List<dynamic>.from(htmlAttributions!.map((x) => x)),
    "status": status,
    "results": List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class SearchPlaces {
  String? businessStatus;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  String? placeId;
  PlusCode? plusCode;
  String? reference;
  String? scope;
  List<String>? types;
  String? vicinity;
  double? rating;
  int? userRatingsTotal;
  OpeningHours? openingHours;

  SearchPlaces({
    this.businessStatus,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.placeId,
    this.plusCode,
    this.reference,
    this.scope,
    this.types,
    this.vicinity,
    this.rating,
    this.userRatingsTotal,
    this.openingHours,
  });

  factory SearchPlaces.fromJson(Map<String, dynamic> json) => SearchPlaces(
    businessStatus: json["business_status"],
    geometry: Geometry.fromJson(json["geometry"]),
    icon: json["icon"],
    iconBackgroundColor: json["icon_background_color"],
    iconMaskBaseUri: json["icon_mask_base_uri"],
    name: json["name"],
    placeId: json["place_id"],
    plusCode: PlusCode.fromJson(json["plus_code"]),
    reference: json["reference"],
    scope: json["scope"],
    types: List<String>.from(json["types"].map((x) => x)),
    vicinity: json["vicinity"],
    rating: json["rating"].toDouble(),
    userRatingsTotal: json["user_ratings_total"],
    openingHours: OpeningHours.fromJson(json["opening_hours"]),
  );

  Map<String, dynamic> toJson() => {
    "business_status": businessStatus,
    "geometry": geometry!.toJson(),
    "icon": icon,
    "icon_background_color": iconBackgroundColor,
    "icon_mask_base_uri": iconMaskBaseUri,
    "name": name,
    "place_id": placeId,
    "plus_code": plusCode!.toJson(),
    "reference": reference,
    "scope": scope,
    "types": List<dynamic>.from(types!.map((x) => x)),
    "vicinity": vicinity,
    "rating": rating,
    "user_ratings_total": userRatingsTotal,
    "opening_hours": openingHours!.toJson(),
  };
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({
    this.location,
    this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: Location.fromJson(json["location"]),
    viewport: Viewport.fromJson(json["viewport"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location!.toJson(),
    "viewport": viewport!.toJson(),
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
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    northeast: Location.fromJson(json["northeast"]),
    southwest: Location.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast!.toJson(),
    "southwest": southwest!.toJson(),
  };
}

class OpeningHours {
  bool? openNow;

  OpeningHours({
    this.openNow,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
    openNow: json["open_now"],
  );

  Map<String, dynamic> toJson() => {
    "open_now": openNow,
  };
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
    compoundCode: json["compound_code"],
    globalCode: json["global_code"],
  );

  Map<String, dynamic> toJson() => {
    "compound_code": compoundCode,
    "global_code": globalCode,
  };
}
