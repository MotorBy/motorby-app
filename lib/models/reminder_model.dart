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

  /// The budget (and so the car) this reminder belongs to. Older reminders
  /// only carry it inside metadata.
  String? get linkedBudgetId {
    final direct = budgetId;
    if (direct != null && direct.isNotEmpty) return direct;
    final fromMeta = metadata?.budgetId;
    return fromMeta == null || fromMeta.isEmpty ? null : fromMeta;
  }

  String get effectiveCategory {
    final c = category ?? metadata?.category;
    return c == null || c.isEmpty ? 'Other' : c;
  }

  int get remindBeforeMinutes => notificationPreferences?.remindMeBefore ?? 30;

  bool get pushEnabled => notificationPreferences?.push ?? true;

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
    metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
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
    "metadata": metadata?.toJson(),
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

  /// Minutes before the due time to alert. The create form has always sent
  /// this (default 30); it just was never read back.
  int? remindMeBefore;

  NotificationPreferences({
    this.email,
    this.push,
    this.sms,
    this.remindMeBefore,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) => NotificationPreferences(
    email: json["email"],
    push: json["push"],
    sms: json["sms"],
    remindMeBefore: json["remind_me_before"] is num
        ? (json["remind_me_before"] as num).toInt()
        : int.tryParse('${json["remind_me_before"] ?? ''}'),
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "push": push,
    "sms": sms,
    "remind_me_before": remindMeBefore,
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
    budgetId: json["budget_id"] ?? '',
    category: json["category"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "budget_id": budgetId,
    "category": category,
  };
}