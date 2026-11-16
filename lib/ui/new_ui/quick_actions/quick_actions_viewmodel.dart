import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/utils/currency.dart';
import 'package:mobile_auto_drive/models/reminder_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/drive_session_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/drive/drive_mode_viewmodel.dart';
import 'package:mobile_auto_drive/services/places_services.dart';
import 'package:mobile_auto_drive/services/reminder_service.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class QuickActionsViewModel extends BaseViewModel {
  final _budgetingService = serviceLocator<BudgetingService>();
  final _placesService = serviceLocator<PlacesService>();
  final _reminderService = serviceLocator<ReminderService>();
  final driveService = serviceLocator<DriveSessionService>();

  /// True while drive mode is asking for location and starting up.
  bool isStartingDrive = false;
  
  BudgetingModel? _budgetingModel;
  Budget? currentBudget;
  CarId? _currentCar;
  final List<ReminderPayload> _reminders = [];

  BudgetingModel? get budgetingModel => _budgetingModel;
  CarId? get currentCar => _currentCar;
  List<ReminderPayload> get reminders => _reminders;
  String get currentCarName => _currentCar != null ? '${_currentCar!.carMake}' : 'Toyota';
  
  // Spending statistics - calculated dynamically from budget data
  String get repairsSpent {
    if (_budgetingModel == null || _currentCar == null) return 'N0 spent';

    final currentBudget = _findCurrentBudget();
    if (currentBudget == null) return '${money(0)} spent';

    int total = 0;
    if (currentBudget.repairing != null) {
      for (var repair in currentBudget.repairing!) {
        total += repair.price ?? 0;
      }
    }
    
    return '${money(total)} spent';
  }
  
  String get fuelingSpent {
    if (_budgetingModel == null || _currentCar == null) return 'N0 spent';

    final currentBudget = _findCurrentBudget();
    if (currentBudget == null) return '${money(0)} spent';

    int total = 0;
    if (currentBudget.fueling != null) {
      for (var fuel in currentBudget.fueling!) {
        total += fuel.price ?? 0;
      }
    }
    
    return '${money(total)} spent';
  }
  
  String get servicingSpent {
    if (_budgetingModel == null || _currentCar == null) return 'N0 spent';

    final currentBudget = _findCurrentBudget();
    if (currentBudget == null) return '${money(0)} spent';

    int total = 0;
    if (currentBudget.servicing != null) {
      for (var service in currentBudget.servicing!) {
        total += service.price ?? 0;
      }
    }
    
    return '${money(total)} spent';
  }

  String get totalReminderSet {
    if(_reminderService.reminderListModel != null) {
      return _reminderService.reminderListModel!.data.length.toString();
    } else {
      return '0';
    }
  }

  // Location and car counts - calculated dynamically
  String get savedLocationsCount {
    final savedLocations = _placesService.savedLocationsResponse?.payload;
    int locationCount = 0;
    
    if (savedLocations != null) {
      // Count all locations except home and work addresses
      locationCount = savedLocations.where((location) => 
        location.savedLocationAs != 'home' && 
        location.savedLocationAs != 'work'
      ).length;
    }
    
    return '$locationCount location(s)';
  }
  
  String get addedCarsCount {
    int carCount = _budgetingModel?.budget?.length ?? 0;
    return '$carCount added car(s)';
  }
  
  String get activeRemindersCount {

    final currentBudget = _findCurrentBudget();
    int reminderCount = 0;
    
    if (currentBudget?.mileageData != null) {
      reminderCount = currentBudget!.mileageData!.length;
    }
    
    return '$reminderCount active reminder';
  }

  Future<void> init() async {
    driveService.addListener(notifyListeners);
    setBusy(true);
    try {

      _budgetingModel = _budgetingService.budgetingModel;

      if(_budgetingService.currentCar != null) {
        _currentCar = _budgetingService.currentCar;
      }

      notifyListeners();

    } catch (e) {

      setError(e.toString());

    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    driveService.removeListener(notifyListeners);
    super.dispose();
  }

  // ---- Drive mode ----

  bool get isDriving => driveService.isDriving;

  String get driveTitle => isDriving ? 'Driving now' : 'Start driving';

  String get driveSubtitle => isDriving
      ? '${DriveModeViewModel.carNameFor(driveService.drivingCar)} is in drive mode · tap to view'
      : "Put your car in drive mode and we'll track the trip";

  /// Puts the selected car in drive mode. Returns why it couldn't, or null
  /// when drive mode is on (including when it already was).
  Future<String?> startDriving() async {
    if (isDriving) return null;
    final car = getCurrentCar();
    if (car == null) return 'Add a car to start driving';

    isStartingDrive = true;
    notifyListeners();
    try {
      return await driveService.start(car);
    } finally {
      isStartingDrive = false;
      notifyListeners();
    }
  }

  List<Budget> getBudgetData() {
    return _budgetingService.budgetingModel?.budget ?? [];
  }

  CarId? getCurrentCar() {
    return _budgetingService.currentCar;
  }

  void setCurrentCar(CarId? carId) {
    if (carId != null) {
      _currentCar = carId;
      _budgetingService.currentCar = carId;
      notifyListeners();
    }
  }
  
  /// Calculate total spending for a specific category
  String calculateSpending(String category) {
    switch (category) {
      case 'repairs':
        return repairsSpent;
      case 'fueling':
        return fuelingSpent;
      case 'servicing':
        return servicingSpent;
      default:
        return 'N0 spent';
    }
  }
  
  /// Find the budget for the current car
  Budget? _findCurrentBudget() {
    if (_budgetingModel?.budget == null || _currentCar == null) return null;
    
    for (var budget in _budgetingModel!.budget!) {
      if (budget.carId?.sId == _currentCar!.sId) {
        currentBudget = budget;
        return budget;
      }
    }
    
    return null;
  }

}