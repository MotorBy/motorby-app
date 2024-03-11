import 'dart:developer';

import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:mobile_auto_drive/models/plan_model.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:stacked/stacked.dart';

import '../../services/user_service.dart';
import '../../utils/locator_setup.dart';

class ProfileViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();
  final paymentService =  serviceLocator<AppPaymentService>();

  UserModel? userModel;
  Payload? user;

  PlanModel? planModel;

  List<String>? plans = [
    "Free",
    "Pro",
    "Ultra"
  ];

  String? currentPlan = 'Free';

  bool? isBusiness = false;
  bool? hasBusiness = false;

  int? currentPlanIndex = 0;

  Future init() async {

    if(userService.userModel != null) {
      userModel = userService.userModel;
      user = userModel!.payload;
    } else {
      await userService.getUsers();
      userModel = userService.userModel;
      user = userModel!.payload;
    }

    if(userModel!.payload!.businessDetails != null) {
      if(userModel!.payload!.businessDetails!.businessName != null) {
        hasBusiness = true;
      }
    }

    if(paymentService.planModel != null) {
      planModel =  paymentService.planModel;
    } else {
      await paymentService.getPlans();
      planModel =  paymentService.planModel;
    }

    print("helloo....${planModel!.toJson()}");

    notifyListeners();

  }

  Future updateUserProfile() async {

  }

  Future getAppPlan() async {

  }

  void updatePlanPickIndex(int? v) {
    currentPlanIndex = v;
    currentPlan = plans![v!];
    notifyListeners();
  }

  Future makePayment({
    Function(String? error)? onInitialisedError,
    Function(PaystackInitializedTraction initTransc)? onShowPayModal}) async {
    const secretKey = 'sk_test_2fbad8fef30e5949069e608408dd2e7c879e04ed';

    final request = PaystackTransactionRequest(
      reference: 'ps_${DateTime.now().microsecondsSinceEpoch}',
      secretKey: secretKey,
      email: 'test@mail.com',
      amount: 1500 * 100,
      currency: PaystackCurrency.ngn,
      channel: [
        PaystackPaymentChannel.mobileMoney,
        PaystackPaymentChannel.card,
        PaystackPaymentChannel.ussd,
        PaystackPaymentChannel.bankTransfer,
        PaystackPaymentChannel.bank,
      ],
    );

    final initializedTransaction = await PaymentService.initializeTransaction(request);

    if (!initializedTransaction.status) {
      if(onInitialisedError != null) {
        onInitialisedError(initializedTransaction.message);
      }
      return;
    }

    onShowPayModal!(initializedTransaction);

    final response = await PaymentService.verifyTransaction(
      paystackSecretKey: secretKey,
      initializedTransaction.data?.reference ?? request.reference,
    );

    log("verifying: $response");



  }

}