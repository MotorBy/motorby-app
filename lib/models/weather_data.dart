class WeatherData {
  int? statusCode;
  String? message;
  Payload? payload;

  WeatherData({
    this.statusCode,
    this.message,
    this.payload,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
    statusCode: json["statusCode"],
    message: json["message"],
    payload: Payload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": payload!.toJson(),
  };
}

class Payload {
  String? id;
  dynamic weatherId;
  String? weatherName;
  String? country;
  double? lng;
  double? lat;
  double? temp;
  double? tempMin;
  double? tempMax;
  String? description;
  String? weatherDriveInstruction;
  int? humidity;
  int? pressure;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Payload({
    this.id,
    this.weatherId,
    this.weatherName,
    this.country,
    this.lng,
    this.lat,
    this.temp,
    this.tempMin,
    this.tempMax,
    this.description,
    this.weatherDriveInstruction,
    this.humidity,
    this.pressure,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    id: json["_id"],
    weatherId: json["weather_id"],
    weatherName: json["weather_name"],
    country: json["country"],
    lng: json["lng"].toDouble(),
    lat: json["lat"].toDouble(),
    temp: json["temp"].toDouble(),
    tempMin: json["temp_min"].toDouble(),
    tempMax: json["temp_max"].toDouble(),
    description: json["description"],
    weatherDriveInstruction: json['weather_drive_instructions'],
    humidity: json["humidity"],
    pressure: json["pressure"],
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    updatedAt: json["createdAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "weather_id": weatherId,
    "weather_name": weatherName,
    "country": country,
    "lng": lng,
    "lat": lat,
    "temp": temp,
    "temp_min": tempMin,
    "temp_max": tempMax,
    "description": description,
    "humidity": humidity,
    "pressure": pressure,
    'weather_drive_instructions': weatherDriveInstruction,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}