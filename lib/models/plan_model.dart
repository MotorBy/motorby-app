class PlanModel {
  int? statusCode;
  String? message;
  Plans? plans;

  PlanModel({
    this.statusCode,
    this.message,
    this.plans,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
    statusCode: json["statusCode"],
    message: json["message"],
    plans: Plans.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": plans!.toJson(),
  };
}

class Plans {
  String? baseCurreny;
  PlanType? user;
  PlanType? business;

  Plans({
    this.baseCurreny,
    this.user,
    this.business,
  });

  factory Plans.fromJson(Map<String, dynamic> json) => Plans(
    baseCurreny: json["base_curreny"],
    user: PlanType.fromJson(json["user"]),
    business: PlanType.fromJson(json["business"]),
  );

  Map<String, dynamic> toJson() => {
    "base_curreny": baseCurreny,
    "user": user!.toJson(),
    "business": business!.toJson(),
  };
}

class PlanType {
  Plan? free;
  Plan? pro;
  Plan? ultra;

  PlanType({
    this.free,
    this.pro,
    this.ultra,
  });

  factory PlanType.fromJson(Map<String, dynamic> json) => PlanType(
    free: Plan.fromJson(json["free"]),
    pro: Plan.fromJson(json["pro"]),
    ultra: Plan.fromJson(json["ultra"]),
  );

  Map<String, dynamic> toJson() => {
    "free": free!.toJson(),
    "pro": pro!.toJson(),
    "ultra": ultra!.toJson(),
  };
}

class Plan {
  int? price;
  List<String>? actions;

  Plan({
    this.price,
    this.actions,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    price: json["price"],
    actions: List<String>.from(json["actions"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "price": price,
    "actions": List<dynamic>.from(actions!.map((x) => x)),
  };
}