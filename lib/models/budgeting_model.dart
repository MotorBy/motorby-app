class BudgetingModel {
  int? statusCode;
  String? message;
  List<Budget>? budget;

  BudgetingModel({this.statusCode, this.message, this.budget});

  BudgetingModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['payload'] != null) {
      budget = <Budget>[];
      json['payload'].forEach((v) {
        budget!.add(Budget.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (budget != null) {
      data['payload'] = budget!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Budget {
  bool? isActive;
  String? sId;
  CarId? carId;
  String? userId;
  String? carName;
  int? mileage;
  int? budget;
  int? currentSpending;
  List<Fueling>? fueling;
  List<Servicing>? servicing;
  List<Repairing>? repairing;
  List<Breakdowns>? breakdowns;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Budget(
      {this.isActive,
        this.sId,
        this.carId,
        this.userId,
        this.carName,
        this.mileage,
        this.currentSpending,
        this.fueling,
        this.servicing,
        this.repairing,
        this.breakdowns,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Budget.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    sId = json['_id'];
    carId = json['car_id'] != null ? CarId.fromJson(json['car_id']) : null;
    userId = json['user_id'];
    carName = json['car_name'];
    mileage = json['mileage'];
    budget = json['budget_amount'];
    currentSpending = json['current_spending'];
    if (json['fueling'] != null) {
      fueling = <Fueling>[];
      json['fueling'].forEach((v) {
        fueling!.add(Fueling.fromJson(v));
      });
    }
    if (json['servicing'] != null) {
      servicing = <Servicing>[];
      json['servicing'].forEach((v) {
        servicing!.add(Servicing.fromJson(v));
      });
    }
    if (json['repairing'] != null) {
      repairing = <Repairing>[];
      json['repairing'].forEach((v) {
        repairing!.add(Repairing.fromJson(v));
      });
    }
    if (json['breakdowns'] != null) {
      breakdowns = <Breakdowns>[];
      json['breakdowns'].forEach((v) {
        breakdowns!.add(Breakdowns.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isActive'] = isActive;
    data['_id'] = sId;
    if (carId != null) {
      data['car_id'] = carId!.toJson();
    }
    data['user_id'] = userId;
    data['car_name'] = carName;
    data['mileage'] = mileage;
    data['budget_amount'] = budget;
    data['current_spending'] = currentSpending;
    if (fueling != null) {
      data['fueling'] = fueling!.map((v) => v.toJson()).toList();
    }
    if (servicing != null) {
      data['servicing'] = servicing!.map((v) => v.toJson()).toList();
    }
    if (repairing != null) {
      data['repairing'] = repairing!.map((v) => v.toJson()).toList();
    }
    if (breakdowns != null) {
      data['breakdowns'] = breakdowns!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class CarId {
  Details? details;
  String? sId;
  String? carModel;
  String? carYear;
  String? color;
  String? by;
  List<String>? images;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? carMake;

  CarId(
      {this.details,
        this.sId,
        this.carModel,
        this.carYear,
        this.color,
        this.by,
        this.images,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.carMake});

  CarId.fromJson(Map<String, dynamic> json) {
    details =
    json['details'] != null ? Details.fromJson(json['details']) : null;
    sId = json['_id'];
    carModel = json['car_model'];
    carYear = json['car_year'];
    color = json['color'];
    by = json['by'];
    images = json['images'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    carMake = json['car_make'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['_id'] = sId;
    data['car_model'] = carModel;
    data['car_year'] = carYear;
    data['color'] = color;
    data['by'] = by;
    data['images'] = images;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['car_make'] = carMake;
    return data;
  }
}

class Details {
  String? airBag;
  String? breaks;
  String? gear;
  int? speakers;
  int? mileage;
  int? seats;
  String? airConditioner;
  String? conditions;

  Details(
      {this.airBag,
        this.breaks,
        this.gear,
        this.speakers,
        this.mileage,
        this.seats,
        this.airConditioner,
        this.conditions});

  Details.fromJson(Map<String, dynamic> json) {
    airBag = json['air_bag'];
    breaks = json['breaks'];
    gear = json['gear'];
    speakers = json['speakers'];
    mileage = json['mileage'];
    seats = json['seats'];
    airConditioner = json['air_conditioner'];
    conditions = json['conditions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['air_bag'] = airBag;
    data['breaks'] = breaks;
    data['gear'] = gear;
    data['speakers'] = speakers;
    data['mileage'] = mileage;
    data['seats'] = seats;
    data['air_conditioner'] = airConditioner;
    data['conditions'] = conditions;
    return data;
  }
}

class Fueling {
  String? date;
  int? price;
  String? sId;
  int? pricePerLiter;

  Fueling({this.date, this.price, this.sId, this.pricePerLiter});

  Fueling.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    price = json['price'];
    sId = json['_id'];
    pricePerLiter = json['price_per_liter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['price'] = price;
    data['_id'] = sId;
    data['price_per_liter'] = pricePerLiter;
    return data;
  }
}

class Servicing {
  String? date;
  String? condition;
  String? shopName;
  int? price;
  String? sId;

  Servicing({this.date, this.condition, this.shopName, this.price, this.sId});

  Servicing.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    condition = json['condition'];
    shopName = json['shop_name'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['condition'] = condition;
    data['shop_name'] = shopName;
    data['price'] = price;
    data['_id'] = sId;
    return data;
  }
}

class Repairing {
  String? date;
  String? condition;
  String? shopName;
  int? price;
  String? sId;

  Repairing({this.date, this.condition, this.shopName, this.price, this.sId});

  Repairing.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    condition = json['condition'];
    shopName = json['shop_name'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['condition'] = condition;
    data['shop_name'] = shopName;
    data['price'] = price;
    data['_id'] = sId;
    return data;
  }
}

class Breakdowns {
  String? date;
  String? cause;
  String? location;
  String? sId;

  Breakdowns({this.date, this.cause, this.location, this.sId});

  Breakdowns.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    cause = json['cause'];
    location = json['location'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['cause'] = cause;
    data['location'] = location;
    data['_id'] = sId;
    return data;
  }
}
