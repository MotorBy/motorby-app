class RouteDirectionsModel {
  int? statusCode;
  String? message;
  Payload? payload;

  RouteDirectionsModel({
    this.statusCode,
    this.message,
    this.payload,
  });

  factory RouteDirectionsModel.fromJson(Map<String, dynamic> json) => RouteDirectionsModel(
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": payload?.toJson(),
  };
}

class Payload {
  List<Route>? routes;
  String? status;

  Payload({
    this.routes,
    this.status,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    routes: json["routes"] == null ? [] : List<Route>.from(json["routes"]!.map((x) => Route.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "routes": routes == null ? [] : List<dynamic>.from(routes!.map((x) => x.toJson())),
    "status": status,
  };
}

class Route {
  DurationClass? distance;
  DurationClass? duration;
  TrafficInfo? trafficInfo;
  List<Step>? steps;

  Route({
    this.distance,
    this.duration,
    this.trafficInfo,
    this.steps,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    distance: json["distance"] == null ? null : DurationClass.fromJson(json["distance"]),
    duration: json["duration"] == null ? null : DurationClass.fromJson(json["duration"]),
    trafficInfo: json["traffic_info"] == null ? null : TrafficInfo.fromJson(json["traffic_info"]),
    steps: json["steps"] == null ? [] : List<Step>.from(json["steps"]!.map((x) => Step.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "distance": distance?.toJson(),
    "duration": duration?.toJson(),
    "traffic_info": trafficInfo?.toJson(),
    "steps": steps == null ? [] : List<dynamic>.from(steps!.map((x) => x.toJson())),
  };
}

class DurationClass {
  String? text;
  int? value;

  DurationClass({
    this.text,
    this.value,
  });

  factory DurationClass.fromJson(Map<String, dynamic> json) => DurationClass(
    text: json["text"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "value": value,
  };
}

class Step {
  int? distanceMeters;
  String? staticDuration;
  Polyline? polyline;
  Location? startLocation;
  Location? endLocation;
  NavigationInstruction? navigationInstruction;
  LocalizedValues? localizedValues;
  TravelMode? travelMode;

  Step({
    this.distanceMeters,
    this.staticDuration,
    this.polyline,
    this.startLocation,
    this.endLocation,
    this.navigationInstruction,
    this.localizedValues,
    this.travelMode,
  });

  factory Step.fromJson(Map<String, dynamic> json) => Step(
    distanceMeters: json["distanceMeters"],
    staticDuration: json["staticDuration"],
    polyline: json["polyline"] == null ? null : Polyline.fromJson(json["polyline"]),
    startLocation: json["startLocation"] == null ? null : Location.fromJson(json["startLocation"]),
    endLocation: json["endLocation"] == null ? null : Location.fromJson(json["endLocation"]),
    navigationInstruction: json["navigationInstruction"] == null ? null : NavigationInstruction.fromJson(json["navigationInstruction"]),
    localizedValues: json["localizedValues"] == null ? null : LocalizedValues.fromJson(json["localizedValues"]),
    travelMode: travelModeValues.map[json["travelMode"]]!,
  );

  Map<String, dynamic> toJson() => {
    "distanceMeters": distanceMeters,
    "staticDuration": staticDuration,
    "polyline": polyline?.toJson(),
    "startLocation": startLocation?.toJson(),
    "endLocation": endLocation?.toJson(),
    "navigationInstruction": navigationInstruction?.toJson(),
    "localizedValues": localizedValues?.toJson(),
    "travelMode": travelModeValues.reverse[travelMode],
  };
}

class Location {
  LatLng? latLng;

  Location({
    this.latLng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latLng: json["latLng"] == null ? null : LatLng.fromJson(json["latLng"]),
  );

  Map<String, dynamic> toJson() => {
    "latLng": latLng?.toJson(),
  };
}

class LatLng {
  double? latitude;
  double? longitude;

  LatLng({
    this.latitude,
    this.longitude,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => LatLng(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class LocalizedValues {
  StaticDurationClass? distance;
  StaticDurationClass? staticDuration;

  LocalizedValues({
    this.distance,
    this.staticDuration,
  });

  factory LocalizedValues.fromJson(Map<String, dynamic> json) => LocalizedValues(
    distance: json["distance"] == null ? null : StaticDurationClass.fromJson(json["distance"]),
    staticDuration: json["staticDuration"] == null ? null : StaticDurationClass.fromJson(json["staticDuration"]),
  );

  Map<String, dynamic> toJson() => {
    "distance": distance?.toJson(),
    "staticDuration": staticDuration?.toJson(),
  };
}

class StaticDurationClass {
  String? text;

  StaticDurationClass({
    this.text,
  });

  factory StaticDurationClass.fromJson(Map<String, dynamic> json) => StaticDurationClass(
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
  };
}

class NavigationInstruction {
  String? maneuver;
  String? instructions;

  NavigationInstruction({
    this.maneuver,
    this.instructions,
  });

  factory NavigationInstruction.fromJson(Map<String, dynamic> json) => NavigationInstruction(
    maneuver: json["maneuver"],
    instructions: json["instructions"],
  );

  Map<String, dynamic> toJson() => {
    "maneuver": maneuver,
    "instructions": instructions,
  };
}

class Polyline {
  String? encodedPolyline;

  Polyline({
    this.encodedPolyline,
  });

  factory Polyline.fromJson(Map<String, dynamic> json) => Polyline(
    encodedPolyline: json["encodedPolyline"],
  );

  Map<String, dynamic> toJson() => {
    "encodedPolyline": encodedPolyline,
  };
}

enum TravelMode {
  DRIVE
}

final travelModeValues = EnumValues({
  "DRIVE": TravelMode.DRIVE
});

class TrafficInfo {
  Advisory? advisory;
  int? trafficPercentage;
  DurationClass? trafficDistance;

  TrafficInfo({
    this.advisory,
    this.trafficPercentage,
    this.trafficDistance,
  });

  factory TrafficInfo.fromJson(Map<String, dynamic> json) => TrafficInfo(
    advisory: json["advisory"] == null ? null : Advisory.fromJson(json["advisory"]),
    trafficPercentage: json["traffic_percentage"],
    trafficDistance: json["traffic_distance"] == null ? null : DurationClass.fromJson(json["traffic_distance"]),
  );

  Map<String, dynamic> toJson() => {
    "advisory": advisory?.toJson(),
    "traffic_percentage": trafficPercentage,
    "traffic_distance": trafficDistance?.toJson(),
  };
}

class Advisory {
  Advisory();

  factory Advisory.fromJson(Map<String, dynamic> json) => Advisory(
  );

  Map<String, dynamic> toJson() => {
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
