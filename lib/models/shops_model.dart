class ShopsModel {
  int? statusCode;
  String? message;
  List<Shop>? shop;

  ShopsModel({
    this.statusCode,
    this.message,
    this.shop,
  });

  factory ShopsModel.fromJson(Map<String, dynamic> json) => ShopsModel(
    statusCode: json["statusCode"],
    message: json["message"],
    shop: List<Shop>.from(json["payload"].map((x) => Shop.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": List<dynamic>.from(shop!.map((x) => x.toJson())),
  };
}

class Shop {
  String? id;
  Address? address;
  String? logo;
  StatsDetails? statsDetails;
  String? country;
  String? state;
  String? name;
  String? descriptions;
  List<String>? into;
  List<String>? supportMake;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Shop({
    this.id,
    this.address,
    this.logo,
    this.statsDetails,
    this.country,
    this.state,
    this.name,
    this.descriptions,
    this.into,
    this.supportMake,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    id: json["_id"],
    address: json["address"] != null ? Address.fromJson(json["address"]) : null,
    logo: json["logo"],
    statsDetails: json["stats_details"] != null ? StatsDetails.fromJson(json["stats_details"]) : null,
    country: json["country"],
    state: json["state"],
    name: json["name"],
    descriptions: json['descriptions'],
    into: List<String>.from(json["into"].map((x) => x)),
    supportMake: List<String>.from(json["support_make"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "address": address?.toJson(),
    "logo": logo,
    "stats_details": statsDetails?.toJson(),
    "country": country,
    "state": state,
    "name": name,
    "descriptions": descriptions,
    "into": List<dynamic>.from(into!.map((x) => x)),
    "support_make": List<dynamic>.from(supportMake!.map((x) => x)),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}

class Address {
  String? addressName;
  String? lat;
  String? lng;
  String? pobox;

  Address({
    this.addressName,
    this.lat,
    this.lng,
    this.pobox,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    addressName: json["address_name"],
    lat: json["lat"],
    lng: json["lng"],
    pobox: json["pobox"],
  );

  Map<String, dynamic> toJson() => {
    "address_name": addressName,
    "lat": lat,
    "lng": lng,
    "pobox": pobox,
  };
}

class StatsDetails {
  int? sales;
  int? products;
  int? visits;

  StatsDetails({
    this.sales,
    this.products,
    this.visits,
  });

  factory StatsDetails.fromJson(Map<String, dynamic> json) => StatsDetails(
    sales: json["sales"],
    products: json["products"],
    visits: json["visits"],
  );

  Map<String, dynamic> toJson() => {
    "sales": sales,
    "products": products,
    "visits": visits,
  };
}