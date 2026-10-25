import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/checklist_data_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/services/checklist_service.dart';

class ChecklistViewModel extends BaseViewModel {
  final ChecklistService _checklistService = ChecklistService();

  Map<String, dynamic>? _checklistData;
  String _selectedFrequency = 'weekly';

  ChecklistDataModel? checkListDataModel;
  List<Item>? updatingChecklistItems = [];

  // Getters
  Map<String, dynamic>? get checklistData => _checklistData;
  String get selectedFrequency => _selectedFrequency;

  // Initialize checklist data
  Future<void> initializeChecklist(String? carId) async {
    try {

      if(carId != null) {

        setBusy(true);
        final response = await _checklistService.getCarChecklist(carId);
        checkListDataModel = response;

        if(checkListDataModel != null) {
          _selectedFrequency = checkListDataModel!.payload!.frequency!.setFrequency ?? 'weekly';
        }

      }

      setBusy(false);
    } catch (e) {
      setBusy(false);
      debugPrint('Error initializing checklist: $e');
    }
  }

  // Update checklist item
  Future<void> updateChecklistItem(String carId, String key, bool value) async {
    try {
      // Find the item in the checklist data model
      final itemIndex = checkListDataModel?.payload?.items?.indexWhere((item) => item.item == key);
      
      if (itemIndex != null && itemIndex != -1) {

        checkListDataModel!.payload!.items![itemIndex].isChecked = value;
        notifyListeners();

        if (!updatingChecklistItems!.any((item) => item.item == key)) {
          updatingChecklistItems!.add(checkListDataModel!.payload!.items![itemIndex]);
        }
      }

    } catch (e) {
      debugPrint('Error updating checklist item: $e');
    }
  }

  void updateFrequency(String carId, String frequency) {
      _selectedFrequency = frequency;
      notifyListeners();
  }

  Future<void> updateChecklist(String carId, {Function? onCallBack, Function(String? e)? onErrorCallback}) async {
    try {
      setBusyForObject('updatingChecklistItems', true);

        await _checklistService.updateCarChecklist(
          checkListId: checkListDataModel!.payload!.id!,
          items: updatingChecklistItems?.map((item) => item.toJson()).toList() ?? [],
          frequency: _selectedFrequency,
        );

      setBusyForObject('updatingChecklistItems', false);

      onCallBack?.call();

    } catch (e) {
      debugPrint('Error updating checklist: $e');
      onErrorCallback?.call(e.toString());
    } finally {
      setBusyForObject('updatingChecklistItems', false);
    }
  }

}