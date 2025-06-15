import 'package:mobile_auto_drive/models/saved_place_model.dart';

class SavedLocationsResponse {
  final int? statusCode;
  final String? message;
  final List<SavedPlacePayload>? payload;

  SavedLocationsResponse({
    this.statusCode,
    this.message,
    this.payload,
  });

  factory SavedLocationsResponse.fromJson(Map<String, dynamic> json) {
    return SavedLocationsResponse(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      payload: json['payload'] != null
          ? (json['payload'] as List)
              .map((place) => SavedPlacePayload.fromJson(place as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'payload': payload?.map((place) => place.toJson()).toList(),
    };
  }
}