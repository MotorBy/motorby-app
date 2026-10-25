import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:mobile_auto_drive/models/current_plans_model.dart';
import 'package:mobile_auto_drive/models/insurance_bought_model.dart';
import 'package:mobile_auto_drive/models/insurance_product_details.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/auth_service.dart';
import 'package:mobile_auto_drive/services/insurance_service.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/services/payment_gateway.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/supported_countries.dart';
import 'package:stacked/stacked.dart';

class MoreViewModel extends BaseViewModel {
  final UserService _userService = serviceLocator<UserService>();
  final AuthService _authService = serviceLocator<AuthService>();
  final InsuranceService _insuranceService = serviceLocator<InsuranceService>();

  User? _user;
  User? get user => _user;

  /// The market this account belongs to. Everything country-specific on the
  /// More page - which features show, which currency prices print in, whether
  /// payment is possible at all - reads from here.
  SupportedCountry get country => countryByName(_user?.country);

  String get currencyCode => country.currencyCode;

  bool offers(MarketFeature feature) => country.offers(feature);

  /// Whether any processor can charge this market yet.
  bool get canTakePayment => canTakePaymentIn(country);

  /// 'Lagos, Nigeria' when we know the state, otherwise just the country.
  String get locationLabel {
    final state = _user?.state;
    return state == null || state.isEmpty
        ? country.name
        : '$state, ${country.name}';
  }

  /// What the Payment & Subscription row says it will bill in.
  String get billingLabel => canTakePayment
      ? 'Billed in $currencyCode'
      : 'Not available in ${country.name} yet';

  bool _isPro = false;
  bool get isPro => _isPro;

  InsuranceBoughtModel? _currentInsurance;
  InsuranceBoughtModel? get currentInsurance => _currentInsurance;

  GetInsuranceProduct? _currentPlan;
  GetInsuranceProduct? get currentPlan => _currentPlan;

  List<InsuranceBoughtModel> _insuranceHistory = [];
  List<InsuranceBoughtModel> get insuranceHistory => _insuranceHistory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    setBusy(true);
    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        _loadUserData(),
        _loadInsuranceData(),
        _loadSubscriptionData(),
      ]);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load data: ${e.toString()}';
    } finally {
      _isLoading = false;
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> _loadUserData() async {
    try {
      // This used to call getCurrentFuelPrice, which returns fuel prices, not
      // a user - so _user was never populated and the page knew nothing about
      // who was looking at it.
      if (_userService.userModel?.payload?.user == null) {
        await _userService.getUsers();
      }
      _user = _userService.userModel?.payload?.user;
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _loadInsuranceData() async {
    try {
      final insuranceResponse = await _insuranceService.getBoughtInsurance();
      if (insuranceResponse.isNotEmpty) {
        _insuranceHistory = insuranceResponse;
        // Find the most recent active insurance
        _currentInsurance = insuranceResponse
            .where((insurance) => insurance.status?.toLowerCase() == 'active')
            .isNotEmpty
            ? insuranceResponse
                .where((insurance) => insurance.status?.toLowerCase() == 'active')
                .first
            : null;
      }
    } catch (e) {
      print('Error loading insurance data: $e');
    }
  }

  Future<void> _loadSubscriptionData() async {
    try {
      //final plansResponse = await _paymentService.getCurrentPlans();
      // if (plansResponse.isNotEmpty) {
      //   _currentPlan = plansResponse.first;
      //   _isPro = _currentPlan?.planName?.toLowerCase() != 'free' &&
      //           _currentPlan?.planName?.toLowerCase() != 'basic';
      // }
    } catch (e) {
      print('Error loading subscription data: $e');
    }
  }

  Future<void> refreshData() async {
    await init();
  }

  Future<void> logOut() async {
    setBusy(true);
    try {
      //await _userService.logOut();
    } catch (e) {
      _errorMessage = 'Failed to log out: ${e.toString()}';
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  String getInsuranceStatusText() {
    if (_currentInsurance == null) {
      return 'No active insurance';
    }
    return 'No active insurance';
  }

  String getSubscriptionStatusText() {
    if (_currentPlan == null) {
      return 'Free Plan';
    }
    return 'Free Plan';
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}