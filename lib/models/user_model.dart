// class UserModel {
//   int? statusCode;
//   String? message;
//   User? payload;
//
//   UserModel({
//     this.statusCode,
//     this.message,
//     this.payload,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//     statusCode: json["statusCode"],
//     message: json["message"],
//     payload: User.fromJson(json["payload"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "statusCode": statusCode,
//     "message": message,
//     "payload": payload!.toJson(),
//   };
// }

class UserModel {
  int? statusCode;
  String? message;
  Payload? payload;

  UserModel({
    this.statusCode,
    this.message,
    this.payload,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
  User? user;
  ReferralProfile? referralProfile;

  Payload({
    this.user,
    this.referralProfile,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    user: User.fromJson(json["user"]),
    referralProfile: ReferralProfile.fromJson(json["referral_profile"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user!.toJson(),
    "referral_profile": referralProfile!.toJson(),
  };
}

class User {
  PaymentDetails? paymentDetails;
  StatsDetails? statsDetails;
  PlanDetails? planDetails;
  Subscription? subscription;
  BusinessDetails? businessDetails;
  String? fullname;
  String? firstname;
  String? lastname;
  String? email;
  String? country;
  String? state;
  String? phonenumber;
  String? userType;
  String? userId;
  String? referralCode;
  List<dynamic>? favourites;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  User({
    this.paymentDetails,
    this.statsDetails,
    this.planDetails,
    this.subscription,
    this.businessDetails,
    this.fullname,
    this.firstname,
    this.lastname,
    this.email,
    this.country,
    this.state,
    this.phonenumber,
    this.userType,
    this.userId,
    this.referralCode,
    this.favourites,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    paymentDetails: json["payment_details"] != null ? PaymentDetails.fromJson(json["payment_details"]) : null,
    statsDetails: json["stats_details"] != null ? StatsDetails.fromJson(json["stats_details"]) : null,
    planDetails: json["plan_details"] != null ? PlanDetails.fromJson(json["plan_details"]) : null,
    businessDetails: json["business_details"] != null ? BusinessDetails.fromJson(json["business_details"]) : null,
    subscription: json["subscription"] != null ? Subscription.fromJson(json["subscription"]) : null,
    fullname: json["fullname"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    country: json["country"],
    state: json["state"],
    phonenumber: json["phonenumber"],
    userType: json["user_type"],
    userId: json["user_id"],
    referralCode: json["referral_code"],
    favourites: json["favourites"] != null ? List<dynamic>.from(json["favourites"].map((x) => x)) : [],
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "payment_details": paymentDetails!.toJson(),
    "stats_details": statsDetails!.toJson(),
    "plan_details": planDetails!.toJson(),
    "business_details": businessDetails!.toJson(),
    "subscription": subscription!.toJson(),
    "fullname": fullname,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "country": country,
    "state": state,
    "phonenumber": phonenumber,
    "user_type": userType,
    "user_id": userId,
    "referral_code": referralCode,
    "favourites": List<dynamic>.from(favourites!.map((x) => x)),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}

class ReferralProfile {
  String? id;
  String? userId;
  int? totalEarnings;
  String? referralCode;
  String? referredCode;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ReferralProfile({
    this.id,
    this.userId,
    this.totalEarnings,
    this.referralCode,
    this.referredCode,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ReferralProfile.fromJson(Map<String, dynamic> json) => ReferralProfile(
    id: json["_id"],
    userId: json["user_id"],
    totalEarnings: json["total_earnings"],
    referralCode: json["referral_code"],
    referredCode: json["referred_code"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "total_earnings": totalEarnings,
    "referral_code": referralCode,
    "referred_code": referredCode,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}

class Subscription {
  String? tier;
  DateTime? startDate;
  bool? isActive;
  List<Feature>? features;
  List<dynamic>? paymentHistory;

  Subscription({
    this.tier,
    this.startDate,
    this.isActive,
    this.features,
    this.paymentHistory,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    tier: json["tier"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    isActive: json["isActive"],
    features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
    paymentHistory: json["paymentHistory"] == null ? [] : List<dynamic>.from(json["paymentHistory"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "tier": tier,
    "startDate": startDate?.toIso8601String(),
    "isActive": isActive,
    "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x.toJson())),
    "paymentHistory": paymentHistory == null ? [] : List<dynamic>.from(paymentHistory!.map((x) => x)),
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

class BusinessDetails {
  String? businessName;
  String? businessRegNo;

  BusinessDetails({
    this.businessName,
    this.businessRegNo,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) => BusinessDetails(
    businessName: json["business_name"],
    businessRegNo: json["business_reg_no"],
  );

  Map<String, dynamic> toJson() => {
    "business_name": businessName,
    "business_reg_no": businessRegNo,
  };
}

class PaymentDetails {
  AuthPayment? authPayment;
  String? type;
  String? lastPayment;

  PaymentDetails({
    this.authPayment,
    this.type,
    this.lastPayment,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
    authPayment: json["auth_payment"] != null ? AuthPayment.fromJson(json["auth_payment"]) : null,
    type: json["type"],
    lastPayment: json["last_payment"],
  );

  Map<String, dynamic> toJson() => {
    "auth_payment": authPayment!.toJson(),
    "type": type,
    "last_payment": lastPayment,
  };
}

class AuthPayment {
  String? authCode;
  String? last4;
  String? expYear;
  String? expMonth;
  String? bank;

  AuthPayment({
    this.authCode,
    this.last4,
    this.expYear,
    this.expMonth,
    this.bank,
  });

  factory AuthPayment.fromJson(Map<String, dynamic> json) => AuthPayment(
    authCode: json["auth_code"],
    last4: json["last4"],
    expYear: json["exp_year"],
    expMonth: json["exp_month"],
    bank: json["bank"],
  );

  Map<String, dynamic> toJson() => {
    "auth_code": authCode,
    "last4": last4,
    "exp_year": expYear,
    "exp_month": expMonth,
    "bank": bank,
  };
}

class PlanDetails {
  String? businessPlan;
  String? userPlan;
  DateTime? lastPlanUpdate;

  PlanDetails({
    this.businessPlan,
    this.userPlan,
    this.lastPlanUpdate,
  });

  factory PlanDetails.fromJson(Map<String, dynamic> json) => PlanDetails(
    businessPlan: json["business_plan"],
    userPlan: json["user_plan"],
    lastPlanUpdate: json["last_plan_update"] != null ? DateTime.parse(json["last_plan_update"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "business_plan": businessPlan,
    "user_plan": userPlan,
    "last_plan_update": lastPlanUpdate!.toIso8601String(),
  };
}

class StatsDetails {
  int? discussions;
  int? addCars;
  int? shops;
  int? sold;
  int? sales;
  int? communities;

  StatsDetails({
    this.discussions,
    this.addCars,
    this.shops,
    this.sold,
    this.sales,
    this.communities
  });

  factory StatsDetails.fromJson(Map<String, dynamic> json) => StatsDetails(
    discussions: json["discussions"],
    addCars: json['added_cars'],
    shops: json['shops'],
    sold: json['sold'],
    sales: json['sales'],
    communities: json['communities']
  );

  Map<String, dynamic> toJson() => {
    "discussions": discussions,
    "added_cars": addCars,
    "shops": shops,
    "sales": sales,
    "communities": communities
  };
}