class ReminderListModel {
  int statusCode;
  String message;
  List<ReminderPayload> data;

  ReminderListModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ReminderListModel.fromJson(Map<String, dynamic> json) => ReminderListModel(
    statusCode: json["statusCode"],
    message: json["message"],
    data: List<ReminderPayload>.from(json["data"].map((x) => ReminderPayload.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ReminderModel {
  int? status;
  String? message;
  ReminderPayload? payload;

  ReminderModel({
    this.status,
    this.message,
    this.payload,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
    status: json["status"],
    message: json["message"],
    payload: json["payload"] == null ? null : ReminderPayload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "payload": payload?.toJson(),
  };
}

class ReminderPayload {
  String? id;
  String? budgetId;
  String? title;
  String? description;
  DateTime? dueDate;
  String? dueTime;
  String? frequency;
  String? category;
  NotificationPreferences? notificationPreferences;
  Metadata? metadata;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReminderPayload({
    this.id,
    this.budgetId,
    this.title,
    this.description,
    this.dueDate,
    this.dueTime,
    this.frequency,
    this.category,
    this.metadata,
    this.notificationPreferences,
    this.createdAt,
    this.updatedAt,
  });

  factory ReminderPayload.fromJson(Map<String, dynamic> json) => ReminderPayload(
    id: json["_id"],
    budgetId: json["budget_id"],
    title: json["title"],
    description: json["description"],
    dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
    dueTime: json["due_time"],
    frequency: json["frequency"],
    category: json["category"],
    metadata: Metadata.fromJson(json["metadata"]),
    notificationPreferences: json["notification_preferences"] == null
        ? null
        : NotificationPreferences.fromJson(json["notification_preferences"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "budget_id": budgetId,
    "title": title,
    "metadata": metadata!.toJson(),
    "description": description,
    "due_date": dueDate?.toIso8601String(),
    "due_time": dueTime,
    "frequency": frequency,
    "category": category,
    "notification_preferences": notificationPreferences?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class NotificationPreferences {
  bool? email;
  bool? push;
  bool? sms;

  NotificationPreferences({
    this.email,
    this.push,
    this.sms,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) => NotificationPreferences(
    email: json["email"],
    push: json["push"],
    sms: json["sms"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "push": push,
    "sms": sms,
  };
}

class Metadata {
  String budgetId;
  String category;

  Metadata({
    required this.budgetId,
    required this.category,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    budgetId: json["budget_id"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "budget_id": budgetId,
    "category": category,
  };
}