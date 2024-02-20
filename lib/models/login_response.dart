class LoginResponse {
  String? status;
  String? token;
  String? userId;
  int? statusCode;

  LoginResponse({this.status, this.token, this.userId, this.statusCode});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    userId = json['_id'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    data['_id'] = userId;
    data['statusCode'] = statusCode;
    return data;
  }
}
