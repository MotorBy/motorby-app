import 'dart:developer';

import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:mobile_auto_drive/models/plan_model.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/api_keys.dart';
import 'package:stacked/stacked.dart';

import '../../services/user_service.dart';
import '../../utils/locator_setup.dart';

class ProfileViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();
  final persistentService = serviceLocator<PersistenceService>();
  final paymentService =  serviceLocator<AppPaymentService>();

  UserModel? userModel;
  User? user;

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

    if(userModel!.payload!.user!.businessDetails != null) {
      if(userModel!.payload!.user!.businessDetails!.businessName != null) {
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
      user = userModel!.payload!.user;
    } else {
      await userService.getUsers();
      userModel = userService.userModel;
      user = userModel!.payload!.user;
    }

    if(userModel!.payload!.user!.userType == 'USER') {
      userPlan = userModel!.payload!.user!.planDetails!.userPlan;
    } else {
      userPlan = userModel!.payload!.user!.planDetails!.businessPlan;
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
      } else if(type == 'bemail') {
        updateData['business_details']['business_email'] = value;
      } else if(type == 'bcontact') {
        updateData['business_details']['business_contact'] = value;
      } else if(type == 'btype') {
        updateData['business_details']['business_type'] = value;
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
    Function(PaystackInitializedTraction? initTransc)? onShowPayModal}) async {

    if(currentPlan?.toUpperCase() != 'FREE') {

      final request = PaystackTransactionRequest(
        reference: 'MBY-${DateTime.now().microsecondsSinceEpoch}',
        secretKey: APIKey.payStackSKey,
        email: userModel!.payload!.user!.email!,
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
        onShowPayModal!(initializedTransaction);
      }

    } else {
      currentPayRef = 'MBY-${DateTime.now().microsecondsSinceEpoch}';
      onShowPayModal!(null);
    }

  }

  Future verifyPayment({Function? onCallBack, Function? onErrorCallBack, bool? freeSub = false}) async {

    setBusy(true);

    if(freeSub == false) {

      await PaymentService.verifyTransaction(
        paystackSecretKey: APIKey.payStackSKey,
        currentPayRef!,
      ).then((value) async {

        paymentService.paystackTransactionVerified = value;

        var payData = {
          "last_plan_update" : DateTime.now().toString(),
          "for": "PLAN",
          "by": userService.persistService.getUserID,
          "plan" : currentPlan?.toUpperCase(),
          "reference": currentPayRef,
          "status": paymentService.paystackTransactionVerified!.data?.gatewayResponse ?? 'Successful',
          "amount": currentAmount,
          "provider": 'Paystack',
          "auth_payment": paymentService.paystackTransactionVerified!.data?.authorization != null ? {
            "auth_code" : paymentService.paystackTransactionVerified!.data!.authorization!.authorizationCode ,
            "last4" : paymentService.paystackTransactionVerified!.data!.authorization!.last4,
            "exp_year" : paymentService.paystackTransactionVerified!.data!.authorization!.expYear,
            "exp_month" : paymentService.paystackTransactionVerified!.data!.authorization!.expMonth,
            "exp_bank" : paymentService.paystackTransactionVerified!.data!.authorization!.bank
          } : null,
        };

        if(paymentService.paystackTransactionVerified!.data!.paidAt != null) {

          await paymentService.createPayment(
            payment: payData,
          ).then((value) {

            if(onCallBack != null) {
              setBusy(false);
              onCallBack();
            }

          }).onError((error, stackTrace) {
            setBusy(false);
            print(stackTrace);
            if(onErrorCallBack != null) {
              onErrorCallBack();
            }
          });

        } else {

          setBusy(false);
          if(onErrorCallBack != null) {
            onErrorCallBack();
          }

        }

      });

    } else {

      var payData = {
        "last_plan_update" : DateTime.now().toString(),
        "for": "PLAN",
        "by": userService.persistService.getUserID,
        "plan" : currentPlan?.toUpperCase(),
        "reference": currentPayRef,
        "status": 'Success',
        "amount": currentAmount,
        "provider": 'App',
        "auth_payment": null,
      };

      await paymentService.createPayment(
        payment: payData,
      ).then((value) {
        setBusy(false);

        if(onCallBack != null) {
          setBusy(false);
          onCallBack();
        }

      }).onError((error, stackTrace) {
        setBusy(false);

        if(onErrorCallBack != null) {
          onErrorCallBack();
        }

      });

    }

  }

  Future logOut() async {
    await persistentService.deleteAll();
  }

}