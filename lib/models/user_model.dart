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
  PaymentDetails? paymentDetails;
  StatsDetails? statsDetails;
  PlanDetails? planDetails;
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

  Payload({
    this.paymentDetails,
    this.statsDetails,
    this.planDetails,
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

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    paymentDetails: json["payment_details"] != null ? PaymentDetails.fromJson(json["payment_details"]) : null,
    statsDetails: json["payment_details"] != null ? StatsDetails.fromJson(json["stats_details"]) : null,
    planDetails: json["payment_details"] != null ? PlanDetails.fromJson(json["plan_details"]) : null,
    businessDetails: json["payment_details"] != null ? BusinessDetails.fromJson(json["business_details"]) : null,
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
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "payment_details": paymentDetails!.toJson(),
    "stats_details": statsDetails!.toJson(),
    "plan_details": planDetails!.toJson(),
    "business_details": businessDetails!.toJson(),
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
    authPayment: AuthPayment.fromJson(json["auth_payment"]),
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
    lastPlanUpdate: DateTime.parse(json["last_plan_update"]),
  );

  Map<String, dynamic> toJson() => {
    "business_plan": businessPlan,
    "user_plan": userPlan,
    "last_plan_update": lastPlanUpdate!.toIso8601String(),
  };
}

class StatsDetails {
  int? discussions;

  StatsDetails({
    this.discussions,
  });

  factory StatsDetails.fromJson(Map<String, dynamic> json) => StatsDetails(
    discussions: json["discussions"],
  );

  Map<String, dynamic> toJson() => {
    "discussions": discussions,
  };
}