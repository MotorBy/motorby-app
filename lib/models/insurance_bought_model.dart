class InsuranceBoughtModel {
  int? statusCode;
  String? message;
  List<Payload>? payload;

  InsuranceBoughtModel({
    this.statusCode,
    this.message,
    this.payload,
  });

  factory InsuranceBoughtModel.fromJson(Map<String, dynamic> json) => InsuranceBoughtModel(
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? [] : List<Payload>.from(json["payload"]!.map((x) => Payload.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": payload == null ? [] : List<dynamic>.from(payload!.map((x) => x.toJson())),
  };
}

class Payload {
  InsuranceType? insuranceType;
  String? id;
  String? country;
  String? state;
  String? attachedCar;
  String? by;
  InsuranceData? insuranceData;
  String? paymentReference;
  String? paymentStatus;
  bool? claimed;
  String? claimStatus;
  String? insuranceStatus;
  bool? active;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? paymentId;

  Payload({
    this.insuranceType,
    this.id,
    this.country,
    this.state,
    this.attachedCar,
    this.by,
    this.insuranceData,
    this.paymentReference,
    this.paymentStatus,
    this.claimed,
    this.claimStatus,
    this.insuranceStatus,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.paymentId,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    insuranceType: json["insurance_type"] == null ? null : InsuranceType.fromJson(json["insurance_type"]),
    id: json["_id"],
    country: json["country"],
    state: json["state"],
    attachedCar: json["attached_car"],
    by: json["by"],
    insuranceData: json["insurance_data"] == null ? null : InsuranceData.fromJson(json["insurance_data"]),
    paymentReference: json["payment_reference"],
    paymentStatus: json["payment_status"],
    claimed: json["claimed"],
    claimStatus: json["claim_status"],
    insuranceStatus: json["insurance_status"],
    active: json["active"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    paymentId: json["payment_id"],
  );

  Map<String, dynamic> toJson() => {
    "insurance_type": insuranceType?.toJson(),
    "_id": id,
    "country": country,
    "state": state,
    "attached_car": attachedCar,
    "by": by,
    "insurance_data": insuranceData?.toJson(),
    "payment_reference": paymentReference,
    "payment_status": paymentStatus,
    "claimed": claimed,
    "claim_status": claimStatus,
    "insurance_status": insuranceStatus,
    "active": active,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "payment_id": paymentId,
  };
}

class InsuranceData {
  String? vehicleMake;
  String? vehicleModel;
  String? address;
  String? state;
  String? country;
  DateTime? insuranceStartDate;
  DateTime? insuranceEndDate;
  String? engineNumber;
  String? chassisNumber;
  String? vehicleInsuranceType;
  String? vehicleRegistrationNumber;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? dob;
  String? phone;
  String? productId;
  bool? claimed;
  bool? active;
  String? paymentReference;
  String? paymentStatus;
  InsuranceType? insuranceType;

  InsuranceData({
    this.vehicleMake,
    this.vehicleModel,
    this.address,
    this.state,
    this.country,
    this.insuranceStartDate,
    this.insuranceEndDate,
    this.engineNumber,
    this.chassisNumber,
    this.vehicleInsuranceType,
    this.vehicleRegistrationNumber,
    this.firstName,
    this.lastName,
    this.email,
    this.dob,
    this.phone,
    this.productId,
    this.claimed,
    this.active,
    this.paymentReference,
    this.paymentStatus,
    this.insuranceType,
  });

  factory InsuranceData.fromJson(Map<String, dynamic> json) => InsuranceData(
    vehicleMake: json["vehicle_make"],
    vehicleModel: json["vehicle_model"],
    address: json["address"],
    state: json["state"],
    country: json["country"],
    insuranceStartDate: json["insurance_start_date"] == null ? null : DateTime.parse(json["insurance_start_date"]),
    insuranceEndDate: json["insurance_end_date"] == null ? null : DateTime.parse(json["insurance_end_date"]),
    engineNumber: json["engine_number"],
    chassisNumber: json["chassis_number"],
    vehicleInsuranceType: json["vehicle_insurance_type"],
    vehicleRegistrationNumber: json["vehicle_registration_number"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    phone: json["phone"],
    productId: json["product_id"],
    claimed: json["claimed"],
    active: json["active"],
    paymentReference: json["payment_reference"],
    paymentStatus: json["payment_status"],
    insuranceType: json["insurance_type"] == null ? null : InsuranceType.fromJson(json["insurance_type"]),
  );

  Map<String, dynamic> toJson() => {
    "vehicle_make": vehicleMake,
    "vehicle_model": vehicleModel,
    "address": address,
    "state": state,
    "country": country,
    "insurance_start_date": "${insuranceStartDate!.year.toString().padLeft(4, '0')}-${insuranceStartDate!.month.toString().padLeft(2, '0')}-${insuranceStartDate!.day.toString().padLeft(2, '0')}",
    "insurance_end_date": "${insuranceEndDate!.year.toString().padLeft(4, '0')}-${insuranceEndDate!.month.toString().padLeft(2, '0')}-${insuranceEndDate!.day.toString().padLeft(2, '0')}",
    "engine_number": engineNumber,
    "chassis_number": chassisNumber,
    "vehicle_insurance_type": vehicleInsuranceType,
    "vehicle_registration_number": vehicleRegistrationNumber,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "phone": phone,
    "product_id": productId,
    "claimed": claimed,
    "active": active,
    "payment_reference": paymentReference,
    "payment_status": paymentStatus,
    "insurance_type": insuranceType?.toJson(),
  };
}

class InsuranceType {
  String? provider;
  int? cost;
  String? insuranceId;
  String? type;

  InsuranceType({
    this.provider,
    this.cost,
    this.insuranceId,
    this.type,
  });

  factory InsuranceType.fromJson(Map<String, dynamic> json) => InsuranceType(
    provider: json["provider"],
    cost: json["cost"],
    insuranceId: json["insurance_id"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "provider": provider,
    "cost": cost,
    "insurance_id": insuranceId,
    "type": type,
  };
}