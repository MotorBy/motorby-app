import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
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
  final int totalMileage = 12345;
  final double fuelEfficiency = 15.0;
  final String lastRefuelDate = '10, Nov 2024';
  final int currentMileage = 10030409;
  
  // Weather data
  final String temperature = '34C';
  final String weatherCondition = 'Clear Sky';
  final String humidity = '60%';

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

    print(currentSetBudget);
    print(currentTotalSpent);

    notifyListeners();

  }

  List<Budget> getBudgetData() {
    return budgetingService.budgetingModel?.budget ?? [];
  }

  CarId? getCurrentCar() {
    return budgetingService.currentCar;
  }

  // Last mileage log
  final String lastTripDate = '14, Nov 2024';
  final int lastTripDistance = 120;
  final int lastTripFuelConsumed = 11;
  final double lastTripEfficiency = 15.0;

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

  void setTimeFrame(String timeFrame) {
    _selectedTimeFrame = timeFrame;
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

  // Actions
  Future<void> saveMileageLog() async {
    if (_selectedDate == null || _selectedTime == null || 
        _odometerReading.isEmpty || _fuelAdded.isEmpty || _location.isEmpty) {
      // TODO: Handle validation error
      return;
    }

    // TODO: Save mileage log to database
    // Create a map of the log data
    final logData = {
      'date': _selectedDate,
      'time': _selectedTime,
      'odometer_reading': _odometerReading,
      'fuel_added': _fuelAdded,
      'location': _location,
    };

    // Reset form
    _selectedDate = null;
    _selectedTime = null;
    _odometerReading = '';
    _fuelAdded = '';
    _location = '';
    
    notifyListeners();
  }

  void addMileageLog() {
    // TODO: Implement mileage log addition
    notifyListeners();
  }

  // TODO: Add methods to fetch and calculate expense data
  // TODO: Add methods to handle mileage data when tab is switched
  // TODO: Add methods to filter data based on selected time frame
}
