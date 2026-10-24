import 'dart:convert';

CarMakersModel carMakersModelFromJson(String str) => CarMakersModel.fromJson(json.decode(str));

String carMakersModelToJson(CarMakersModel data) => json.encode(data.toJson());

class CarMakersModel {
  int? statusCode;
  String? message;
  CarMakers? payload;

  CarMakersModel({
    this.statusCode,
    this.message,
    this.payload,
  });

  factory CarMakersModel.fromJson(Map<String, dynamic> json) => CarMakersModel(
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? null : CarMakers.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": payload?.toJson(),
  };
}

class CarMakers {
  int? total;
  List<Car>? cars;

  CarMakers({
    this.total,
    this.cars,
  });

  factory CarMakers.fromJson(Map<String, dynamic> json) => CarMakers(
    total: json["total"],
    cars: json["cars"] == null ? [] : List<Car>.from(json["cars"]!.map((x) => Car.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "cars": cars == null ? [] : List<dynamic>.from(cars!.map((x) => x.toJson())),
  };
}

class Car {
  String? brand;
  List<Model>? models;

  Car({
    this.brand,
    this.models,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    brand: json["brand"],
    models: json["models"] == null ? [] : List<Model>.from(json["models"]!.map((x) => Model.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "brand": brand,
    "models": models == null ? [] : List<dynamic>.from(models!.map((x) => x.toJson())),
  };
}

class Model {
  String? name;
  Size? size;
  String? fuelTankSize;
  String? carType;

  Model({
    this.name,
    this.size,
    this.fuelTankSize,
    this.carType,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
    name: json["name"],
    size: sizeValues.map[json["size"]]!,
    fuelTankSize: json["fuel_tank_size"],
    carType: json["car_type"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "size": sizeValues.reverse[size],
    "fuel_tank_size": fuelTankSize,
    "car_type": carType,
  };
}

enum Size {
  COMPACT,
  FULL_SIZE,
  MID_SIZE,
  SUBCOMPACT
}

final sizeValues = EnumValues({
  "Compact": Size.COMPACT,
  "Full-size": Size.FULL_SIZE,
  "Mid-size": Size.MID_SIZE,
  "Subcompact": Size.SUBCOMPACT
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
