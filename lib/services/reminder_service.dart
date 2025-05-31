import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:mobile_auto_drive/models/reminder_model.dart';
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';

IconData getReminderCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'maintenance':
      return Icons.build;
    case 'changes':
      return Icons.swap_horiz;
    case 'repairs':
      return Icons.build_circle;
    case 'budget':
      return Icons.account_balance_wallet;
    case 'trips':
      return Icons.directions_car;
    case 'breakdown':
      return Icons.car_repair;
    case 'fueling':
      return Icons.local_gas_station;
    case 'service':
      return Icons.miscellaneous_services;
    case 'insurance':
      return Icons.security;
    default:
      return Icons.more_horiz;
  }
}

class ReminderService {

  ReminderListModel? reminderListModel;

  Future<List<ReminderPayload>> getReminders() async {
    var response = await http.get(
      Uri.parse('${APIService.root}reminders/'),
      headers: APIHelper().requestHeadersWithToken(),
    );

    final json = JSON.jsonDecode(response.body);
    print(json);

    if (response.statusCode == 200) {

      reminderListModel = ReminderListModel.fromJson(json);
      return reminderListModel!.data;

    } else {
      var error = json['message'];
      throw Exception(error);
    }
  }

  Future<ReminderModel> createReminder({
    String? budgetId,
    required String title,
    required String description,
    required String? dueDate,
    required String? dueTime,
    required String frequency,
    required String category,
    required Map<String, dynamic> notificationPreferences,
  }) async {

    final Map<String, dynamic> reminderData = {
      'budget_id': budgetId,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'due_time': dueTime,
      'frequency': frequency,
      'category': category,
      'notification_preferences': notificationPreferences,
    };

    print(reminderData);

    final jsonData = JSON.json.encode(reminderData);

    var response = await http.post(
      Uri.parse('${APIService.root}reminders/create'),
      headers: APIHelper().requestHeadersWithToken(),
      body: jsonData,
    );

    final json = JSON.jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {

      await getReminders();

      return ReminderModel.fromJson(json);
    } else {
      var error = json['message'];
      throw Exception(error);
    }
  }
}