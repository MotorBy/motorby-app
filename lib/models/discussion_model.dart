class DiscussionModel {
  int? statusCode;
  String? message;
  List<Discussion>? discussions;

  DiscussionModel({
    this.statusCode,
    this.message,
    this.discussions,
  });

  factory DiscussionModel.fromJson(Map<String, dynamic> json) => DiscussionModel(
    statusCode: json["statusCode"],
    message: json["message"],
    discussions: List<Discussion>.from(json["payload"].map((x) => Discussion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": List<dynamic>.from(discussions!.map((x) => x.toJson())),
  };
}

class Discussion {
  String? id;
  String? content;
  bool? fromCommunity;
  String? communityId;
  List<String>? tags;
  int? commentsCount;
  List<Comment>? comments;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  User? user;

  Discussion({
    this.id,
    this.content,
    this.fromCommunity,
    this.communityId,
    this.tags,
    this.commentsCount,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.user,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) => Discussion(
    id: json["_id"],
    content: json["content"],
    fromCommunity: json["from_community"],
    communityId: json["community_id"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    commentsCount: json["commentsCount"],
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "content": content,
    "from_community": fromCommunity,
    "community_id": communityId,
    "tags": List<dynamic>.from(tags!.map((x) => x)),
    "commentsCount": commentsCount,
    "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "user": user!.toJson(),
  };
}

class Comment {
  String? comment;
  User? user;

  Comment({
    this.comment,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    comment: json["comment"],
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "comment": comment,
    "user": user!.toJson(),
  };
}

class User {
  String? fullname;
  String? profileImage;

  User({
    this.fullname,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    fullname: json["fullname"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "profile_image": profileImage,
  };
}