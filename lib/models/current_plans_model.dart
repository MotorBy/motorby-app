class PlansModel {
  int? statusCode;
  String? message;
  Payload? payload;

  PlansModel({
    this.statusCode,
    this.message,
    this.payload,
  });

  factory PlansModel.fromJson(Map<String, dynamic> json) => PlansModel(
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
  CurrentSubscription? currentSubscription;
  SubscriptionOptions? subscriptionOptions;

  Payload({
    this.currentSubscription,
    this.subscriptionOptions,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    currentSubscription: json["current_subscription"] == null ? null : CurrentSubscription.fromJson(json["current_subscription"]),
    subscriptionOptions: json["subscription_options"] == null ? null : SubscriptionOptions.fromJson(json["subscription_options"]),
  );

  Map<String, dynamic> toJson() => {
    "current_subscription": currentSubscription?.toJson(),
    "subscription_options": subscriptionOptions?.toJson(),
  };
}

class CurrentSubscription {
  String? tier;
  bool? isActive;
  DateTime? startDate;
  List<Feature>? features;
  Stats? stats;

  CurrentSubscription({
    this.tier,
    this.isActive,
    this.startDate,
    this.features,
    this.stats,
  });

  factory CurrentSubscription.fromJson(Map<String, dynamic> json) => CurrentSubscription(
    tier: json["tier"],
    isActive: json["isActive"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
    stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
  );

  Map<String, dynamic> toJson() => {
    "tier": tier,
    "isActive": isActive,
    "startDate": startDate?.toIso8601String(),
    "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x.toJson())),
    "stats": stats?.toJson(),
  };
}

class Feature {
  String? name;
  int? count;
  int? limit;
  bool? isEnabled;
  String? simpleDescription;
  String? detailedDescription;
  String? id;

  Feature({
    this.name,
    this.count,
    this.limit,
    this.isEnabled,
    this.simpleDescription,
    this.detailedDescription,
    this.id,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    name: json["name"],
    count: json["count"],
    limit: json["limit"],
    isEnabled: json["isEnabled"],
    simpleDescription: json["simpleDescription"],
    detailedDescription: json["detailedDescription"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "count": count,
    "limit": limit,
    "isEnabled": isEnabled,
    "simpleDescription": simpleDescription,
    "detailedDescription": detailedDescription,
    "_id": id,
  };
}

class Stats {
  int? addedCars;
  int? communities;
  int? sales;
  int? fuelPriceInputs;
  int? nearbyPlaces;
  int? savedLocations;

  Stats({
    this.addedCars,
    this.communities,
    this.sales,
    this.fuelPriceInputs,
    this.nearbyPlaces,
    this.savedLocations,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    addedCars: json["added_cars"],
    communities: json["communities"],
    sales: json["sales"],
    fuelPriceInputs: json["fuel_price_inputs"],
    nearbyPlaces: json["nearby_places"],
    savedLocations: json["saved_locations"],
  );

  Map<String, dynamic> toJson() => {
    "added_cars": addedCars,
    "communities": communities,
    "sales": sales,
    "fuel_price_inputs": fuelPriceInputs,
    "nearby_places": nearbyPlaces,
    "saved_locations": savedLocations,
  };
}

class SubscriptionOptions {
  Plan? free;
  Plan? pro;
  Plan? enterprise;

  SubscriptionOptions({
    this.free,
    this.pro,
    this.enterprise,
  });

  List<Feature>? getFeaturesByTier(int tierIndex) {
    switch (tierIndex) {
      case 0:
        return free?.features;
      case 1:
        return pro?.features;
      case 2:
        return enterprise?.features;
      default:
        return null;
    }
  }

  String getAmountByTier(int tierIndex) {
    switch (tierIndex) {
      case 0:
        return free?.subscriptionAmount?.toString() ?? '0.0';
      case 1:
        return pro?.subscriptionAmount?.toString() ?? '5,000';
      case 2:
        return enterprise?.subscriptionAmount?.toString() ?? '12,000';
      default:
        return '0.0';
    }
  }

  String getTierName(int tierIndex) {
    switch (tierIndex) {
      case 0:
        return 'Free Plan';
      case 1:
        return 'Pro Plan';
      case 2:
        return 'Enterprise Plan';
      default:
        return 'Basic Plan';
    }
  }

  factory SubscriptionOptions.fromJson(Map<String, dynamic> json) => SubscriptionOptions(
    free: json["free"] == null ? null : Plan.fromJson(json["free"]),
    pro: json["pro"] == null ? null : Plan.fromJson(json["pro"]),
    enterprise: json["enterprise"] == null ? null : Plan.fromJson(json["enterprise"]),
  );

  Map<String, dynamic> toJson() => {
    "free": free?.toJson(),
    "pro": pro?.toJson(),
    "enterprise": enterprise?.toJson(),
  };
}

class Plan {
  double? subscriptionAmount;
  int? annualDiscountPercentage;
  int? earlyUserReductionPercentage;
  List<Feature>? features;

  Plan({
    this.subscriptionAmount,
    this.annualDiscountPercentage,
    this.earlyUserReductionPercentage,
    this.features,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    subscriptionAmount: json["subscriptionAmount"]?.toDouble(),
    annualDiscountPercentage: json["annualDiscountPercentage"],
    earlyUserReductionPercentage: json["earlyUserReductionPercentage"],
    features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "subscriptionAmount": subscriptionAmount,
    "annualDiscountPercentage": annualDiscountPercentage,
    "earlyUserReductionPercentage": earlyUserReductionPercentage,
    "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x.toJson())),
  };
}