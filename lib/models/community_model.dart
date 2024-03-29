class CommunityModel {
  int? statusCode;
  String? message;
  List<Community>? communities;

  CommunityModel({
    this.statusCode,
    this.message,
    this.communities,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) => CommunityModel(
    statusCode: json["statusCode"],
    message: json["message"],
    communities: List<Community>.from(json["payload"].map((x) => Community.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": List<dynamic>.from(communities!.map((x) => x.toJson())),
  };
}

class Community {
  List<String>? tags;
  String? id;
  String? name;
  String? description;
  List<String>? discussions;
  List<String>? userList;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? userTotal;

  Community({
    this.tags,
    this.id,
    this.name,
    this.description,
    this.discussions,
    this.userList,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.userTotal,
  });

  factory Community.fromJson(Map<String, dynamic> json) => Community(
    tags: List<String>.from(json["tags"].map((x) => x)),
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    discussions: List<String>.from(json["discussions"].map((x) => x)),
    userList: json["users_list"] != null ? List<String>.from(json["users_list"].map((x) => x)) : [],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    userTotal: json["user_total"],
  );

  Map<String, dynamic> toJson() => {
    "tags": List<dynamic>.from(tags!.map((x) => x)),
    "_id": id,
    "name": name,
    "description": description,
    "discussions": List<dynamic>.from(discussions!.map((x) => x)),
    "users_list": userList != null ? List<dynamic>.from(userList!.map((x) => x)) : [],
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "user_total": userTotal,
  };
}