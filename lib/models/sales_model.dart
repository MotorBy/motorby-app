class SalesListModel {
  int? statusCode;
  String? message;
  List<SalesModel>? payload;

  SalesListModel({this.statusCode, this.message, this.payload});

  SalesListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['payload'] != null) {
      payload = <SalesModel>[];
      json['payload'].forEach((v) {
        payload!.add(SalesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (payload != null) {
      data['payload'] = payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class SalesModel {
  String? sId;
  String? by;
  int? views;
  int? saves;
  String? name;
  String? country;
  String? state;
  bool? allowBidding;
  List<String>? images;
  SalesDetails? salesDetails;
  CarDetails? carDetails;
  SellerDetails? sellerDetails;
  List<BiddingPrices>? biddingPrices;

  SalesModel(
      {this.sId,
        this.by,
        this.views,
        this.saves,
        this.name,
        this.country,
        this.state,
        this.allowBidding,
        this.images,
        this.salesDetails,
        this.sellerDetails,
        this.carDetails,
        this.biddingPrices});

  SalesModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    by = json['by'];
    views = json['views'];
    saves = json['saves'];
    name = json['name'];
    country = json['country'];
    state = json['state'];
    allowBidding = json['allow_bidding'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    salesDetails = json['sales_details'] != null
        ? SalesDetails.fromJson(json['sales_details'])
        : null;
    carDetails = json['car_details'] != null
        ? CarDetails.fromJson(json['car_details'])
        : null;
    sellerDetails = json['seller_details'] != null
        ? SellerDetails.fromJson(json['seller_details'])
        : null;
    if (json['bidding_prices'] != null) {
      biddingPrices = <BiddingPrices>[];
      json['bidding_prices'].forEach((v) {
        biddingPrices!.add(BiddingPrices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['by'] = by;
    data['views'] = views;
    data['saves'] = saves;
    data['country'] = country;
    data['state'] = state;
    data['name'] = name;
    data['allow_bidding'] = allowBidding;
    data['images'] = images;
    if (salesDetails != null) {
      data['sales_details'] = salesDetails!.toJson();
    }
    if (carDetails != null) {
      data['car_details'] = carDetails!.toJson();
    }
    if (sellerDetails != null) {
      data['seller_details'] = sellerDetails!.toJson();
    }
    if (biddingPrices != null) {
      data['bidding_prices'] =
          biddingPrices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesDetails {
  String? salesId;
  int? amountForSale;
  bool? isSold;
  bool? forSale;
  int? units;
  bool? isPromoted;
  String? promotionId;

  SalesDetails(
      {this.salesId,
        this.amountForSale,
        this.isSold,
        this.forSale,
        this.units,
        this.isPromoted,
        this.promotionId});

  SalesDetails.fromJson(Map<String, dynamic> json) {
    salesId = json['sales_id'];
    amountForSale = json['amount_for_sale'];
    units = json['units_left'];
    isSold = json['is_sold'];
    forSale = json['for_sale'];
    isPromoted = json['is_promoted'];
    promotionId = json['promotion_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sales_id'] = salesId;
    data['amount_for_sale'] = amountForSale;
    data['units_left'] = units;
    data['is_sold'] = isSold;
    data['for_sale'] = forSale;
    data['is_promoted'] = isPromoted;
    data['promotion_id'] = promotionId;
    return data;
  }
}

class CarDetails {
  String? airBag;
  String? breaks;
  int? speakers;
  int? mileage;
  String? gear;
  int? seats;
  String? airConditioner;
  String? condition;
  String? carMake;
  String? carModel;
  String? carYear;
  String? carId;
  String? vinNumber;

  CarDetails(
      {this.airBag,
        this.breaks,
        this.speakers,
        this.mileage,
        this.gear,
        this.seats,
        this.airConditioner,
        this.condition,
        this.carMake,
        this.carModel,
        this.carYear,
        this.carId,
        this.vinNumber
      });

  CarDetails.fromJson(Map<String, dynamic> json) {
    airBag = json['air_bag'];
    breaks = json['breaks'];
    speakers = json['speakers'];
    mileage = json['mileage'];
    gear = json['gear'];
    seats = json['seats'];
    airConditioner = json['air_conditioner'];
    condition = json['condition'];
    carMake = json['car_make'];
    carModel = json['car_model'];
    carYear = json['car_year'];
    carId = json['car_id'];
    vinNumber = json['vin_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['air_bag'] = airBag;
    data['breaks'] = breaks;
    data['speakers'] = speakers;
    data['mileage'] = mileage;
    data['gear'] = gear;
    data['seats'] = seats;
    data['air_conditioner'] = airConditioner;
    data['condition'] = condition;
    data['car_make'] = carMake;
    data['car_model'] = carModel;
    data['car_year'] = carYear;
    data['car_id'] = carId;
    data['vin_number'] = vinNumber;
    return data;
  }
}

class BiddingPrices {
  String? users;
  int? priceQuote;
  bool? isAccepted;
  String? dateTime;

  BiddingPrices({this.users, this.priceQuote, this.isAccepted, this.dateTime});

  BiddingPrices.fromJson(Map<String, dynamic> json) {
    users = json['users'];
    priceQuote = json['price_quote'];
    isAccepted = json['is_accepted'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['users'] = users;
    data['price_quote'] = priceQuote;
    data['is_accepted'] = isAccepted;
    data['date_time'] = dateTime;
    return data;
  }
}

class SellerDetails {
  String? phonenumber;
  String? email;
  String? name;
  String? state;

  SellerDetails({this.phonenumber, this.email, this.name, this.state});

  SellerDetails.fromJson(Map<String, dynamic> json) {
    phonenumber = json['phonenumber'];
    email = json['email'];
    name = json['name'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phonenumber'] = phonenumber;
    data['email'] = email;
    data['name'] = name;
    data['state'] = state;
    return data;
  }
}
