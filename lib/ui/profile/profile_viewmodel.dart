import 'dart:developer';

import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:mobile_auto_drive/models/plan_model.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:mobile_auto_drive/utils/key_consts.dart';
import 'package:stacked/stacked.dart';

import '../../services/user_service.dart';
import '../../utils/locator_setup.dart';

class ProfileViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();
  final paymentService =  serviceLocator<AppPaymentService>();

  UserModel? userModel;
  Payload? user;

  PlanModel? planModel;

  String? currentPayRef = '';

  List<String>? plans = [
    "Free",
    "Pro",
    "Ultra"
  ];

  String? currentPlan = 'Free';
  String? userPlan = 'free';

  bool? hasBusiness = false;

  int? currentPlanIndex = 0;
  int? currentAmount = 0;

  Map<String, dynamic> updateData = {};

  Future init() async {

    await getUserProfile();

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

    notifyListeners();

  }

  Future updateUserTypeProfile({Function? onCallBack, Function? onErrorCallBack, String? updateTo}) async {

    if(updateData.isEmpty) {
      updateData['user_type'] = updateTo;
    }

    setBusyForObject('user_type_loading', true);
    await userService.updateUsers(data: updateData).then((value) async {

      await getUserProfile();

      setBusyForObject('user_type_loading', false);
      if(onCallBack != null) {
        updateData = {};
        onCallBack();
      }

    }).onError((error, stackTrace) {
      setBusyForObject('user_type_loading', false);
      print(stackTrace.toString());
      if(onCallBack != null) {
        onCallBack();
      }
    });

  }

  Future getUserProfile() async {

    if(userService.userModel != null) {
      userModel = userService.userModel;
      user = userModel!.payload;
    } else {
      await userService.getUsers();
      userModel = userService.userModel;
      user = userModel!.payload;
    }

    if(userModel!.payload!.userType == 'USER') {
      userPlan = userModel!.payload!.planDetails!.userPlan;
    } else {
      userPlan = userModel!.payload!.planDetails!.businessPlan;
    }

  }

  void setUserTypeDetails({String? value, String? type, String? key}) {

    if(key == 'business') {
      updateData['user_type'] = 'BUSINESS';

      if(updateData['business_details'] == null) {
        updateData['business_details'] = {};
      }

      if(type == 'name') {
        updateData['business_details']['business_name'] = value;
      } else if(type == 'reg_no') {
        updateData['business_details']['business_reg_no'] = value;
      }
    } else if(key == 'user') {
      updateData['user_type'] = 'USER';
    }

    print(updateData);

    notifyListeners();

  }

  Future getAppPlan() async {

  }

  void updatePlanPickIndex(int? v) {
    currentPlanIndex = v;

    if(currentPlanIndex == 0) {

      currentAmount = isBusiness ? planModel!.plans!.business!.free!.price : planModel!.plans!.user!.free!.price;

    } else if (currentPlanIndex == 1) {

      currentAmount = isBusiness ? planModel!.plans!.business!.pro!.price : planModel!.plans!.user!.pro!.price;

    } else if(currentPlanIndex == 2) {

      currentAmount = isBusiness ? planModel!.plans!.business!.ultra!.price : planModel!.plans!.user!.ultra!.price;

    }

    currentPlan = plans![v!];
    notifyListeners();
  }

  Future makePayment({
    Function(String? error)? onInitialisedError,
    Function(PaystackInitializedTraction initTransc)? onShowPayModal}) async {
    const secretKey = PSKey;

    final request = PaystackTransactionRequest(
      reference: 'MBY-${DateTime.now().microsecondsSinceEpoch}',
      secretKey: secretKey,
      email: 'teamexceptos@gmail.com',
      amount: currentAmount! * 100,
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
    } else {
      currentPayRef = initializedTransaction.data?.reference ?? request.reference;
    }

    onShowPayModal!(initializedTransaction);

  }

  Future verifyPayStackPayment({Function? onCallBack, Function? onErrorCallBack}) async {

    setBusy(true);

    await PaymentService.verifyTransaction(
      paystackSecretKey: PSKey,
      currentPayRef!,
    ).then((value) async {

      paymentService.paystackTransactionVerified = value;
      log("verifying: ${paymentService.paystackTransactionVerified!.toJson().toString()}");

      var payData = {
        "last_plan_update" : DateTime.now().toString(),
        "for": "PLAN",
        "by": userService.persistService.getUserID,
        "plan" : currentPlan?.toUpperCase(),
        "reference": currentPayRef,
        "status": paymentService.paystackTransactionVerified!.data.gatewayResponse,
        "amount": currentAmount,
        "provider": 'Paystack',
        "auth_payment": null,
      };

      await paymentService.createPayment(
        payment: payData,
      ).onError((error, stackTrace) {
        setBusy(false);
      });

      if(onCallBack != null) {
        setBusy(false);
        onCallBack();
      }

    });

  }

}