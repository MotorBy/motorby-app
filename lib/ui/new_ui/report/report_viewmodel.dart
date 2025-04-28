import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class ReportViewModel extends BaseViewModel {
  final budgetingService = serviceLocator<BudgetingService>();

  int _selectedTab = 0;
  String _selectedTimeFrame = 'This week';
  BudgetingModel? budgetingModel;

  // Form data
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _odometerReading = '';
  String _fuelAdded = '';
  String _location = '';

  // Mileage data
  int _totalMileage = 0;
  double _fuelEfficiency = 0.0;
  String _lastRefuelDate = '';
  String _lastRefuelAmount = '';
  int _currentMileage = 0;
  String _lastTripDate = '';
  int _lastTripDistance = 0;

  int? currentTotalSpent = 0;
  int? currentSetBudget = 0;
  int currentCarBudgetIndex = 0;
  List<int>? totalCostingAndValue = [
    0,
    0,
    0,
    0,
    0
  ];

  // Getters for last trip data
  String get lastTripDate => _lastTripDate;
  int get lastTripDistance => _lastTripDistance;

  // Getters for mileage data
  int get totalMileage => _totalMileage;
  double get fuelEfficiency => _fuelEfficiency.roundToDouble();
  String get lastRefuelDate => _lastRefuelDate;
  String get lastRefuelAmount => _lastRefuelAmount;
  int get currentMileage => _currentMileage;

  void _calculateMileageStats() {
    if (budgetingModel?.budget == null || budgetingModel!.budget!.isEmpty) return;

    final currentBudget = budgetingModel!.budget![currentCarBudgetIndex];
    
    // Calculate total mileage and last trip data
    if (currentBudget.mileageData != null && currentBudget.mileageData!.isNotEmpty) {
      final latestMileage = int.tryParse(currentBudget.mileageData!.last.odometerReading ?? '0') ?? 0;
      final firstMileage = int.tryParse(currentBudget.mileageData!.first.odometerReading ?? '0') ?? 0;
      _totalMileage = latestMileage - firstMileage;
      _currentMileage = latestMileage;

      // Set last trip data
      final lastTrip = currentBudget.mileageData!.last;
      _lastTripDate = lastTrip.inputDate?.toString().split(' ')[0] ?? '';
      
      if (currentBudget.mileageData!.length > 1) {
        final previousMileage = int.tryParse(currentBudget.mileageData![currentBudget.mileageData!.length - 2].odometerReading ?? '0') ?? 0;
        _lastTripDistance = latestMileage - previousMileage;
      } else {
        _lastTripDistance = 0;
      }
    }

    // Calculate fuel efficiency and get last refuel date
    if (currentBudget.fueling != null && currentBudget.fueling!.isNotEmpty) {
      final lastFueling = currentBudget.fueling!.last;
      _lastRefuelDate = lastFueling.date ?? '';
      _lastRefuelAmount = amtFormatter(lastFueling.price);

      // Calculate average fuel efficiency if we have both mileage and fueling data
      if (currentBudget.mileageData != null && currentBudget.mileageData!.length > 1) {
        final totalDistance = _totalMileage;
        double totalLiters = 0.0;
        for (var fuel in currentBudget.fueling!) {
          if (fuel.price != null && fuel.pricePerLiter != null && fuel.pricePerLiter! > 0) {
            totalLiters += fuel.price! / fuel.pricePerLiter!;
          }
        }
        if (totalLiters > 0) {
          _fuelEfficiency = totalDistance / totalLiters; // km/L
        }
      }
    }
  }

  Future setBudgetData({int currentIndex = 0}) async {
    if(budgetingService.budgetingModel == null) {
      await budgetingService.getBudgets();
      notifyListeners();
    }

    budgetingModel = budgetingService.budgetingModel;
    currentCarBudgetIndex = currentIndex;
    budgetingService.getCurrentTotalValue(index: currentIndex);

    totalCostingAndValue = budgetingService.totalCostingAndValue;
    currentTotalSpent = budgetingService.currentTotalSpent;
    currentSetBudget = budgetingService.currentSetBudget;

    _calculateMileageStats();

    notifyListeners();
  }

  List<Budget> getBudgetData() {
    return budgetingService.budgetingModel?.budget ?? [];
  }

  CarId? getCurrentCar() {
    return budgetingService.currentCar;
  }

  // Getters
  int get selectedTab => _selectedTab;
  String get selectedTimeFrame => _selectedTimeFrame;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String get odometerReading => _odometerReading;
  String get fuelAdded => _fuelAdded;
  String get location => _location;

  // Setters
  void setSelectedTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }


  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setOdometerReading(String reading) {
    _odometerReading = reading;
    notifyListeners();
  }

  void setFuelAdded(String fuel) {
    _fuelAdded = fuel;
    notifyListeners();
  }

  void setLocation(String loc) {
    _location = loc;
    notifyListeners();
  }

}
