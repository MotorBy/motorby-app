class ChecklistDataModel {
  int? status;
  String? message;
  ChecklistData? payload;

  ChecklistDataModel({
    this.status,
    this.message,
    this.payload,
  });

  factory ChecklistDataModel.fromJson(Map<String, dynamic> json) => ChecklistDataModel(
    status: json["status"],
    message: json["message"],
    payload: json["payload"] == null ? null : ChecklistData.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "payload": payload?.toJson(),
  };
}

class ChecklistData {
  Frequency? frequency;
  String? id;
  String? carId;
  List<Item>? items;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ChecklistData({
    this.frequency,
    this.id,
    this.carId,
    this.items,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ChecklistData.fromJson(Map<String, dynamic> json) => ChecklistData(
    frequency: json["frequency"] == null ? null : Frequency.fromJson(json["frequency"]),
    id: json["_id"],
    carId: json["car_id"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "frequency": frequency?.toJson(),
    "_id": id,
    "car_id": carId,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Frequency {
  DateTime? lastUpdated;
  String? setFrequency;

  Frequency({
    this.lastUpdated,
    this.setFrequency,
  });

  factory Frequency.fromJson(Map<String, dynamic> json) => Frequency(
    lastUpdated: json["last_updated"] == null ? null : DateTime.parse(json["last_updated"]),
    setFrequency: json["set_frequency"],
  );

  Map<String, dynamic> toJson() => {
    "last_updated": lastUpdated?.toIso8601String(),
    "set_frequency": setFrequency,
  };
}

class Item {
  String? item;
  bool? isChecked;
  String? category;
  String? id;

  Item({
    this.item,
    this.isChecked,
    this.category,
    this.id,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    item: json["item"],
    isChecked: json["isChecked"],
    category: json["category"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "item": item,
    "isChecked": isChecked,
    "category": category,
    "_id": id,
  };
}