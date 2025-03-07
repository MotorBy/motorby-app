class FuelData {
  int? statusCode;
  String? message;
  double? payload;

  FuelData({
    this.statusCode,
    this.message,
    this.payload,
  });

  factory FuelData.fromJson(Map<String, dynamic> json) => FuelData(
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": payload,
  };
}