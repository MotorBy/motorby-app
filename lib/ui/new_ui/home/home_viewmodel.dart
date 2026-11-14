import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/checklist_data_model.dart';
import 'package:mobile_auto_drive/models/fuel_price_model.dart';
import 'package:mobile_auto_drive/models/reminder_model.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/auth_service.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/checklist_service.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/reminder_service.dart';
import 'package:mobile_auto_drive/services/sales_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/error_logging.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/session.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

/// Where the home screen is in loading its data.
enum HomeStatus {
  /// Nothing has loaded yet.
  loading,

  /// The user loaded; individual sections may still have failed, see
  /// [HomeViewModel.failedSections].
  ready,

  /// The user could not be loaded, so there is nothing to show.
  failed,
}

/// Sections of home that load independently, so one failing API call only
/// takes out its own card.
enum HomeSection { cars, plans, reminders, fuelPrice, weather, checklist }

/// How many reminders home previews before pointing at the full list.
const homeReminderPreviewCount = 5;

/// Drives the home tab, and is shared with the car screens it opens.
///
/// Every API response is read defensively: a field the backend renames or
/// drops shows up as an empty state, never a crash. Each request is isolated
/// so one failure does not blank the whole screen.
class HomeViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();
  final authService = serviceLocator<AuthService>();
  final persistentService = serviceLocator<PersistenceService>();
  final budgetingService = serviceLocator<BudgetingService>();
  final paymentService = serviceLocator<AppPaymentService>();
  final salesService = serviceLocator<SalesService>();
  final checklistService = serviceLocator<ChecklistService>();
  final reminderService = serviceLocator<ReminderService>();

  HomeStatus status = HomeStatus.loading;

  /// Why the user could not be loaded, when [status] is [HomeStatus.failed].
  String? loadError;

  /// Sections whose last load failed. Their cards fall back to empty states.
  final Set<HomeSection> failedSections = {};

  UserModel? userModel;
  BudgetingModel? budgetingModel;
  Budget? currentBudget;
  CarId? currentCar;
  int? currentBudgetViewIndex = 0;
  bool hasAddedCar = false;
  int currentSetBudget = 0;
  String? totalMileage = '0';

  ReminderListModel? reminderListModel;
  ChecklistDataModel? checkListDataModel;
  FuelData? fuelData;

  /// The most recent spend logged on any car, for the "Recent spend" card.
  LastBudget? recentSpend;

  Position? currentPosition;
  bool? locationDeclined = false;
  String? currentWeatherValue;
  String? currentWeatherDescription;

  /// Images picked for a sale listing.
  List<File> addImagesList = [];

  /// The in-flight load, so a pull-to-refresh during start-up joins it
  /// instead of firing every request twice.
  Future<void>? _loading;

  User? get user => userModel?.payload?.user;

  /// The name to greet the user by: their first name, else the first word of
  /// their full name.
  String get firstName {
    final first = user?.firstname?.trim();
    if (first != null && first.isNotEmpty) return first;
    final full = user?.fullname?.trim() ?? '';
    return full.isEmpty ? '' : full.split(RegExp(r'\s+')).first;
  }

  /// The user's initial for the avatar.
  String get initial => firstName.isEmpty ? '' : firstName[0].toUpperCase();

  /// "Good morning" and friends, from the device clock.
  String greeting([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// "Toyota Corolla 2019", skipping whatever the API left out.
  String? get currentCarTitle {
    final car = currentCar;
    if (car == null) return null;
    final title = [car.carMake, car.carModel, car.carYear]
        .where((part) => part != null && part.trim().isNotEmpty)
        .join(' ');
    return title.isEmpty ? null : title;
  }

  List<Budget> get budgets => budgetingModel?.budget ?? const [];

  /// Checklist progress for the selected car, without touching shared
  /// service state the way [checkListStatus] does.
  ({int checked, int total}) get checklistProgress {
    final items = currentBudget?.checklistData?.items ?? const [];
    return (
      checked: items.where((item) => item.isChecked == true).length,
      total: items.length,
    );
  }

  List<ReminderPayload> get recentReminders {
    final all = reminderListModel?.data ?? const <ReminderPayload>[];
    return all.length > homeReminderPreviewCount
        ? all.sublist(0, homeReminderPreviewCount)
        : all;
  }

  bool get hasWeather => currentWeatherValue != null;

  /// True when the first load failed and there is nothing to show.
  bool get showLoadError => status == HomeStatus.failed && userModel == null;

  /// True on the very first load, before anything is on screen.
  bool get isFirstLoad => status == HomeStatus.loading && userModel == null;

  /// Loads everything home shows. Safe to call again to refresh: the selected
  /// car is kept, and a call made while a load is running waits for it.
  ///
  /// [onErrorLogout] runs after an expired session has been cleared.
  /// [onPermissionCallBack] runs when the screen should ask for location.
  Future<void> init({
    VoidCallback? onErrorLogout,
    VoidCallback? onCallBack,
    VoidCallback? onPermissionCallBack,
  }) {
    return _loading ??= _load(
      onErrorLogout: onErrorLogout,
      onPermissionCallBack: onPermissionCallBack,
    ).whenComplete(() {
      _loading = null;
      onCallBack?.call();
    });
  }

  Future<void> _load({
    VoidCallback? onErrorLogout,
    VoidCallback? onPermissionCallBack,
  }) async {
    if (userModel == null) {
      status = HomeStatus.loading;
      notifyListeners();
    }

    try {
      await userService.getUsers();
    } catch (error) {
      if (isSessionExpiredError(error)) {
        authService.hasUser = false;
        await logOut();
        onErrorLogout?.call();
        return;
      }
      _log('user', error);
      loadError = readableError(error);
      // A failed refresh keeps what is already on screen.
      status = userModel == null ? HomeStatus.failed : HomeStatus.ready;
      notifyListeners();
      return;
    }

    userModel = userService.userModel;
    loadError = null;

    await Future.wait([
      _attempt(HomeSection.cars, budgetingService.getBudgets),
      _attempt(HomeSection.plans, paymentService.getPlans),
      _attempt(HomeSection.reminders, reminderService.getReminders),
      _attempt(
        HomeSection.fuelPrice,
        () => userService.getCurrentFuelPrice(
          country: user?.country,
          state: user?.state,
        ),
      ),
    ]);

    reminderListModel = reminderService.reminderListModel;
    fuelData = userService.fuelData;
    recentSpend = parseRecentSpend(budgetingService.lastBudget);

    onBudgetViewUpdated(currentBudgetViewIndex);
    status = HomeStatus.ready;
    notifyListeners();

    await _offerLocation(onPermissionCallBack);
  }

  /// Runs one request, recording a failure against [section] instead of
  /// letting it abort the rest of the load.
  Future<void> _attempt(HomeSection section, Future<dynamic> Function() request) async {
    try {
      await request();
      failedSections.remove(section);
    } catch (error) {
      failedSections.add(section);
      _log(section.name, error);
    }
  }

  void _log(String what, Object error) {
    if (kDebugMode) debugPrint('Home: could not load $what: ${readableError(error)}');
  }

  /// Points home at the car at [index], clamped to the cars that exist.
  void onBudgetViewUpdated(int? index) {
    budgetingModel = budgetingService.budgetingModel;
    final cars = budgets;
    hasAddedCar = cars.isNotEmpty;

    if (cars.isEmpty) {
      currentBudgetViewIndex = 0;
      currentBudget = null;
      currentCar = null;
      currentSetBudget = 0;
      totalMileage = '0';
      checkListDataModel = null;
      notifyListeners();
      return;
    }

    final selected = (index ?? 0).clamp(0, cars.length - 1);
    currentBudgetViewIndex = selected;
    budgetingService.getCurrentTotalValue(index: selected);

    currentBudget = cars[selected];
    // A budget can come back without its car (e.g. the car was deleted) or
    // with a car missing its make, so don't assume either is there.
    currentCar = currentBudget!.carId;
    currentSetBudget = currentBudget!.budget ?? 0;
    totalMileage = budgetingService.currentMileage;

    salesService.currentCar = currentCar;
    salesService.currentCarMake = currentCar?.carMake;
    budgetingService.currentCar = currentCar;

    notifyListeners();
    getChecklistDataModel();
  }

  /// Friendlier name for [onBudgetViewUpdated].
  void selectCar(int index) => onBudgetViewUpdated(index);

  Future<void> getChecklistDataModel() async {
    final carId = currentCar?.sId;
    if (carId == null) return;
    try {
      checkListDataModel = await checklistService.getCarChecklist(carId);
      failedSections.remove(HomeSection.checklist);
    } catch (error) {
      failedSections.add(HomeSection.checklist);
      _log('checklist', error);
    }
    notifyListeners();
  }

  /// "checked/total" for the car at [index]. Used by the car details screen.
  String checkListStatus({int? index}) {
    budgetingService.currentBudgetIndex = index;
    budgetingService.getCurrentTotalValue(index: index);
    return budgetingService.getCheckListStatus();
  }

  FuelMileageData getFuelMileageDate({int? index}) {
    budgetingService.currentBudgetIndex = index;
    budgetingService.getCurrentTotalValue(index: index);

    return FuelMileageData(
      currentMileage: budgetingService.currentMileage,
      lastTraveled: budgetingService.lastTraveled,
      lastDateTrip: budgetingService.lastDateTrip,
      totalMileage: budgetingService.totalMileage,
      fuelEfficiency: budgetingService.fuelEfficiency,
      lastRefuelAmount: budgetingService.lastRefuelAmount,
      lastRefuelDate: budgetingService.lastRefuelDate,
    );
  }

  bool? openCarSpecsView = false;
  void setCarSpecsView({bool? shouldOpen}) {
    openCarSpecsView = shouldOpen ?? !(openCarSpecsView ?? false);
    notifyListeners();
  }

  /// True while a car delete is in flight, so the action can show progress and
  /// refuse a second tap.
  bool isDeletingCar = false;

  /// Deletes a car together with its photos and document scans, then refreshes
  /// the budget list the car screens are driven from.
  Future<void> deleteCar({
    required CarId car,
    Function? onCallBack,
    Function(String? e)? onErrorBack,
  }) async {
    if (isDeletingCar) return;

    isDeletingCar = true;
    notifyListeners();

    try {
      await userService.deleteCar(car: car);
      if (currentCar?.sId == car.sId) currentCar = null;
      // Re-selects within the remaining cars, or falls back to the empty state.
      onBudgetViewUpdated(currentBudgetViewIndex);

      isDeletingCar = false;
      notifyListeners();
      onCallBack?.call();
    } catch (error) {
      isDeletingCar = false;
      notifyListeners();
      onErrorBack?.call(readableError(error));
    }
  }

  Future<void> putAddedCarOnSale({
    int? amount,
    String? carId,
    Function? onCallBack,
    Function(String e)? onErrorCallBack,
  }) async {
    if (currentCar?.images?.isNotEmpty != true) {
      onErrorCallBack?.call('No image on current car for sale');
      return;
    }

    setBusy(true);
    try {
      await salesService.makeSales(salesData: {
        'user_id': persistentService.getUserID,
        'data': {
          'amount_for_sale': amount,
          'units_left': 1,
        },
        'car_id': carId,
      });
      onCallBack?.call();
    } catch (error) {
      onErrorCallBack?.call(readableError(error));
    } finally {
      setBusy(false);
    }
  }

  /// Fetches weather straight away when location is already allowed, and only
  /// asks the screen to explain the permission when it could still be granted.
  Future<void> _offerLocation(VoidCallback? askForPermission) async {
    if (currentPosition != null) return;

    final PermissionStatus status;
    try {
      status = await Permission.location.status;
    } catch (_) {
      return; // No permission plugin (e.g. tests).
    }

    if (status.isGranted || status.isLimited) {
      await getLocationUpdate();
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      locationDeclined = true;
      notifyListeners();
    } else if (locationDeclined != true) {
      askForPermission?.call();
    }
  }

  /// Requests location if needed, then loads the weather for it.
  Future<void> getLocationUpdate() async {
    try {
      var permission = await Permission.location.status;
      if (!permission.isGranted && !permission.isLimited) {
        permission = await Permission.location.request();
      }
      if (!permission.isGranted && !permission.isLimited) {
        locationDeclined = true;
        notifyListeners();
        return;
      }

      locationDeclined = false;
      currentPosition = await Geolocator.getLastKnownPosition() ??
          await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 10),
          );
      await loadWeather();
    } catch (error) {
      _log('location', error);
    }
  }

  Future<void> loadWeather() async {
    final position = currentPosition;
    if (position == null) return;

    try {
      await userService.getWeather(
        lat: position.latitude.toString(),
        lng: position.longitude.toString(),
      );
      final weather = userService.weatherData?.payload;
      currentWeatherValue = weather?.tempMax?.round().toString();
      currentWeatherDescription = weather?.description;
      failedSections.remove(HomeSection.weather);
    } catch (error) {
      failedSections.add(HomeSection.weather);
      _log('weather', error);
    }
    notifyListeners();
  }

  Future logOut() => endSession();
}

/// Reads the "last spending" record budgeting keeps, tolerating a missing or
/// reshaped payload. Returns null when there is nothing usable.
LastBudget? parseRecentSpend(Map<String, dynamic>? raw, {DateTime? now}) {
  final data = raw?['data'];
  if (data is! Map) return null;

  try {
    final spend = LastBudget.fromJson({
      ...Map<String, dynamic>.from(data),
      'budget_type': raw?['dataType'],
    });
    if (spend.price == null) return null;
    spend.isFutureBudget = isFutureDate(spend.date, now: now);
    return spend;
  } catch (_) {
    return null; // A field changed type; skip the card rather than crash.
  }
}

/// Whether a "d-M-yyyy" date, as budgeting stores it, is after today.
bool isFutureDate(String? date, {DateTime? now}) {
  if (date == null || date.isEmpty) return false;
  try {
    final day = DateFormat('d-M-yyyy').parseStrict(date);
    final today = now ?? DateTime.now();
    return day.isAfter(DateTime(today.year, today.month, today.day));
  } catch (_) {
    return false;
  }
}
