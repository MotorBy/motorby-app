import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/services/payment_gateway.dart';
import 'package:mobile_auto_drive/services/stripe_service.dart';
import 'package:mobile_auto_drive/utils/supported_countries.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:mobile_auto_drive/models/current_plans_model.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/insurance/insurance_view_model.dart';
import 'package:mobile_auto_drive/utils/api_keys.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class PaymentViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();
  final persistentService = serviceLocator<PersistenceService>();
  final paymentService =  serviceLocator<AppPaymentService>();

  UserModel? userModel;
  User? user;

  String? currentPayRef = '';

  PlansModel? plansModel;
  CurrentSubscription? currentSubscription;

  String get currentTierAmount {
    if (plansModel?.payload?.subscriptionOptions == null || currentSubscription?.tier == null) {
      return '0.00';
    }

    final options = plansModel!.payload!.subscriptionOptions!;
    final tier = currentSubscription!.tier!.toLowerCase();
    
    switch (tier) {
      case 'free':
        return options.free?.subscriptionAmount?.toString() ?? '0.00';
      case 'pro':
        return options.pro?.subscriptionAmount?.toString() ?? '0.00';
      case 'enterprise':
        return options.enterprise?.subscriptionAmount?.toString() ?? '0.00';
      default:
        return '0.00';
    }
  }

  int selectedPaymentMethod = -1;
  int selectedPlan = -1;
  String selectedPlanName = '';
  String selectedPlanAmount = '';

  final cardHolderController =TextEditingController();
  final cardNumberController =TextEditingController();
  final cardExpiryDateController =TextEditingController();
  final cardCvvController =TextEditingController();

  bool isCardSaved = false;
  saveCard() {
    isCardSaved = !isCardSaved;
    notifyListeners();
  }

  List<PaymentMethod> paymentMethod = [
    PaymentMethod(
        img: 'assets/images/visa-icon.svg', details: 'UBA ***** **** **68'),
    PaymentMethod(
        img: 'assets/images/master-card-icon.svg',
        details: 'Wema ***** **** **40'),
  
  ];

  List<PaymentMethod> paymentMethod2 = [
    PaymentMethod(
        img: 'assets/images/visa-icon.svg', details: 'UBA ***** **** **68'),
    PaymentMethod(
        img: 'assets/images/master-card-icon.svg',
        details: 'Wema ***** **** **40'),
    PaymentMethod(img: 'assets/images/epay-icon.svg', details: 'Apple Pay'),
    PaymentMethod(
        img: 'assets/images/internet-icon.svg', details: 'Internet Banking'),
  ];

  updateSelectedPlanDetails(String planAmount, String planName) {
    selectedPlanAmount = planAmount;
    selectedPlanName = planName;
    notifyListeners();
  }

  void updateSelectedPaymentMethod(int index) {
    selectedPaymentMethod = index;
    notifyListeners();
  }

  void updateSelectedPlan(int index) {
    selectedPlan = index;
    notifyListeners();
  }

  Future getCurrentUserPlan() async {
    setBusy(true);

    if(userService.userModel != null) {
      userModel = userService.userModel;
      user = userModel!.payload!.user;
    } else {
      await userService.getUsers();
      userModel = userService.userModel;
      user = userModel!.payload!.user;
    }

    if(paymentService.currentPlansModel!= null) {
      plansModel = paymentService.currentPlansModel;
    } else {
      await paymentService.getCurrentPlans();
      plansModel = paymentService.currentPlansModel;
    }

    currentSubscription = plansModel!.payload!.currentSubscription;
    setBusy(false);
  }

  Future makePayment({
    Function(String? error)? onInitialisedError,
    Function(PaystackInitializedTraction? initTransc)? onShowPayModal}) async {

    if(!selectedPlanName.toUpperCase().contains('FREE')) {

      final country = countryByName(userModel!.payload!.user!.country);
      final gateway = gatewayForCountry(country);

      // Austria (EUR) routes to Stripe, which is not finished. Say so rather
      // than opening a Paystack sheet that would charge the wrong currency.
      if (gateway != PaymentGateway.paystack) {
        final reason = gateway == PaymentGateway.stripe && !StripeService.isConfigured
            ? 'Card payments in ${country.currencyCode} are coming soon to ${country.name}'
            : 'Payments are not available in ${country.name} yet';
        onInitialisedError?.call(reason);
        return;
      }

      final request = PaystackTransactionRequest(
        reference: 'MBY-${DateTime.now().microsecondsSinceEpoch}',
        secretKey: APIKey.payStackSKey,
        email: userModel!.payload!.user!.email!,
        amount: double.parse(selectedPlanAmount).ceil() * 100,
        currency: paystackCurrencyFor(country.currencyCode),
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
          "plan" : selectedPlanName.toUpperCase(),
          "reference": currentPayRef,
          "status": paymentService.paystackTransactionVerified!.data?.gatewayResponse ?? 'Successful',
          "amount": double.parse(selectedPlanAmount).ceil(),
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
        "plan" : selectedPlanName.toUpperCase(),
        "reference": currentPayRef,
        "status": 'Success',
        "amount": 0,
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
        print(stackTrace);
        setBusy(false);

        if(onErrorCallBack != null) {
          onErrorCallBack();
        }

      });

    }

  }

}
