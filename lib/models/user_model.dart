class UserModel {
  int? statusCode;
  String? message;
  Payload? payload;

  UserModel({this.statusCode, this.message, this.payload});

  UserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    payload =
    json['payload'] != null ? Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (payload != null) {
      data['payload'] = payload!.toJson();
    }
    return data;
  }
}

class Payload {
  PaymentDetails? paymentDetails;
  StatsDetails? statsDetails;
  PlanDetails? planDetails;
  String? fullname;
  String? firstname;
  String? lastname;
  String? email;
  String? country;
  String? phonenumber;
  String? userType;
  String? userId;
  String? referralCode;
  //List<Null>? favourites;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Payload(
      {this.paymentDetails,
        this.statsDetails,
        this.planDetails,
        this.fullname,
        this.firstname,
        this.lastname,
        this.email,
        this.country,
        this.phonenumber,
        this.userType,
        this.userId,
        this.referralCode,
        //this.favourites,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Payload.fromJson(Map<String, dynamic> json) {
    paymentDetails = json['payment_details'] != null
        ? PaymentDetails.fromJson(json['payment_details'])
        : null;
    statsDetails = json['stats_details'] != null
        ? StatsDetails.fromJson(json['stats_details'])
        : null;
    planDetails = json['plan_details'] != null
        ? PlanDetails.fromJson(json['plan_details'])
        : null;
    fullname = json['fullname'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    country = json['country'];
    phonenumber = json['phonenumber'];
    userType = json['user_type'];
    userId = json['user_id'];
    referralCode = json['referral_code'];
    // if (json['favourites'] != null) {
    //   favourites = <Null>[];
    //   json['favourites'].forEach((v) {
    //     favourites!.add(Null.fromJson(v));
    //   });
    // }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (paymentDetails != null) {
      data['payment_details'] = paymentDetails!.toJson();
    }
    if (statsDetails != null) {
      data['stats_details'] = statsDetails!.toJson();
    }
    if (planDetails != null) {
      data['plan_details'] = planDetails!.toJson();
    }
    data['fullname'] = fullname;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['country'] = country;
    data['phonenumber'] = phonenumber;
    data['user_type'] = userType;
    data['user_id'] = userId;
    data['referral_code'] = referralCode;
    // if (favourites != null) {
    //   data['favourites'] = favourites!.map((v) => v.toJson()).toList();
    // }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class PaymentDetails {
  String? type;

  PaymentDetails({this.type});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    return data;
  }
}

class StatsDetails {
  int? discussions;

  StatsDetails({this.discussions});

  StatsDetails.fromJson(Map<String, dynamic> json) {
    discussions = json['discussions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discussions'] = discussions;
    return data;
  }
}

class PlanDetails {
  String? businessPlan;
  String? userPlan;
  String? lastPlanUpdate;

  PlanDetails({this.businessPlan, this.userPlan, this.lastPlanUpdate});

  PlanDetails.fromJson(Map<String, dynamic> json) {
    businessPlan = json['business_plan'];
    userPlan = json['user_plan'];
    lastPlanUpdate = json['last_plan_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_plan'] = businessPlan;
    data['user_plan'] = userPlan;
    data['last_plan_update'] = lastPlanUpdate;
    return data;
  }
}
