class GetInsuranceModel {
  int? statusCode;
  String? message;
  List<InsuranceList>? payload;

  GetInsuranceModel({this.statusCode, this.message, this.payload});

  GetInsuranceModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['payload'] != null) {
      payload = <InsuranceList>[];
      json['payload'].forEach((v) {
        payload!.add(InsuranceList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (payload != null) {
      data['payload'] = payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InsuranceList {
  String? company;
  String? name;
  String? type;
  String? cost;
  String? broker;
  String? productId;
  List<String>? country;

  InsuranceList(
      {this.company,
      this.name,
      this.type,
      this.cost,
      this.broker,
      this.productId,
      this.country});

  InsuranceList.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    name = json['name'];
    type = json['type'];
    cost = json['cost'];
    broker = json['broker'];
    productId = json['product_id'];
    country = json['country'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['company'] = company;
    data['name'] = name;
    data['type'] = type;
    data['cost'] = cost;
    data['broker'] = broker;
    data['product_id'] = productId;
    data['country'] = country;
    return data;
  }
}
