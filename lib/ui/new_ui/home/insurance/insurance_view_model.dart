import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/get_insurance_product_model.dart';
import 'package:mobile_auto_drive/models/insurance_product_details.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/firebase_service.dart';
import 'package:mobile_auto_drive/services/insurance_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/api_keys.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class InsuranceViewModel extends BaseViewModel {
  final insuranceService = serviceLocator<InsuranceService>();
  final budgetingService = serviceLocator<BudgetingService>();
  final userService =  serviceLocator<UserService>();

  UserModel? userModel = serviceLocator<UserService>().userModel;

  String selectedVehicle = '';
  String selectedModel = '';
  String selectedEngine = '';
  int selectedVehicleIndex = -1;
  int selectedModelIndex = -1;
  int selectedEngineIndex = -1;
  int selectedPaymentMethod = -1;
  String incidentType = 'choose';
  int selectedIncidentTypeIndex = -1;

  bool hasKycVerification = false;
  FilePickerResult? filePickerResultMain;
  FilePickerResult? filePickerResultBack;

  GetInsuranceModel? insuranceProduct;
  GetInsuranceProduct? insuranceProductDetails;
  List<InsuranceList> insuranceList = [];

  void updateIncidentChoice(String choice, int selectedIndex) {
    incidentType = choice;
    selectedIncidentTypeIndex = selectedIndex;
    notifyListeners();
  }

  void updateSelectedVehicle(String vehicle, int index) {
    selectedVehicle = vehicle;
    selectedVehicleIndex = index;
    notifyListeners();
  }

  void updateSelectedPaymentMethod(int index) {
    selectedPaymentMethod = index;
    notifyListeners();
  }

  void updateSelectedModel(String model, int index) {
    selectedModel = model;
    selectedModelIndex = index;
    notifyListeners();
  }

  void updateSelectedEngine(String engine, int index) {
    selectedEngine = engine;
    selectedEngineIndex = index;
    notifyListeners();
  }

  final manufacture = TextEditingController();
  final vehicleType = TextEditingController();
  final registrationNumber = TextEditingController();
  //New Claim screen
  final dateOfIncident = TextEditingController();
  final timeOfIncident = TextEditingController();
  final locationOfIncident = TextEditingController();
  final descriptionOfIncident = TextEditingController();

  Future getInsuranceProducts() async {

    print(userService.userModel!.payload!.user!.kycData.toString());
    hasKycVerification = userService.userModel!.payload!.user!.kycData != null;

    if (insuranceService.insuranceProduct != null) {
      insuranceProduct = insuranceService.insuranceProduct;
      insuranceList = insuranceProduct?.payload ?? [];
    } else {
      setBusy(true);

      await insuranceService.getInsuranceList();
      setBusy(false);

      insuranceProduct = insuranceService.insuranceProduct;
      insuranceList = insuranceProduct?.payload ?? [];
    }
    notifyListeners();
    print('the list of product: ${insuranceList.first.company}');
  }

  double? purchaseAmount = 0.0;
  final double processingFee = 800.0;

  Future getInsuranceProductDetails({String? productId}) async {
    setBusy(true);
    insuranceService.currentInsuranceId = productId ?? insuranceService.currentInsuranceId;

    await insuranceService.getInsuranceProductDetails(productId: productId ?? insuranceService.currentInsuranceId).then((v) {
      insuranceProductDetails = insuranceService.insuranceProductDetails;

      if (insuranceProductDetails?.payload != null) {
        final vehicleValue = budgetingService.vehicleValue;

        if (insuranceProductDetails!.payload!.variant == 1) {
          purchaseAmount = double.tryParse(insuranceProductDetails!.payload!.price ?? '0.0');
        } else {
          final percentage = double.tryParse(insuranceProductDetails!.payload!.price ?? '0.0') ?? 0.0;
          purchaseAmount = (percentage / 100) * vehicleValue!.toInt();
        }

        purchaseAmount = (purchaseAmount ?? 0.0) + processingFee;
      }
      
      setBusy(false);
    }).onError((e, s) {
      print(s);
      setBusy(false);
    });

  }

  String? currentPayRef = '';
  Future makePayment({
    Function(String? error)? onInitialisedError,
    Function(PaystackInitializedTraction? initTransc)? onShowPayModal}) async {

    final request = PaystackTransactionRequest(
      reference: 'MBY-${DateTime.now().microsecondsSinceEpoch}',
      secretKey: APIKey.payStackSKey,
      email: userModel!.payload!.user!.email!,
      amount: purchaseAmount!.ceil() * 100,
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

  }

  Future verifyPayment() async {
    try {
      setBusy(true);
      
      final currentCar = getCurrentCar();
      final user = userModel?.payload?.user;
      
      if (currentCar == null || user == null) {
        throw Exception('Car or user data not found');
      }

      final Map<String, dynamic> purchaseData = {
        "name": insuranceProductDetails?.payload?.name,
        "type": insuranceProduct!.payload!.where((it) => it.productId == insuranceService.currentInsuranceId).toList()[0].type,
        "product_id": insuranceService.currentInsuranceId,
        "by": user.userId,
        "attached_car": currentCar.sId,
        "insurance_amount": purchaseAmount,
        "insurance_product": insuranceProductDetails?.payload?.name,
        "payment_provider": "Paystack",
        "payment_reference": currentPayRef,
        "payment_date": DateTime.now().toIso8601String(),
        "payment_status": "success",
        "start_date": DateTime.now().toIso8601String().split('T')[0],
        "activation_date": "",
        "expiration_date": "",
        "delayedRoute": true,
        "purchase_id": "STI-MC-${DateTime.now().millisecondsSinceEpoch}",
        "productId": insuranceService.currentInsuranceId,
        "car": {
          "make": currentCar.carMake,
          "model": currentCar.carModel,
          //"registration_number": currentCar.registrationNumber,
          //"engine_number": currentCar.engineNumber,
          //"chassis_number": currentCar.chassisNumber,
          "type": "Car"
        },
        "user": {
          "first_name": user.firstname,
          "last_name": user.lastname,
          "email": user.email,
          "phone": user.phonenumber,
          "dob": user.kycData?.dateOfBirth.toString(),
          "id_type": user.kycData?.documents?[0].type,
          "id_url": user.kycData?.documents?[0].url,
          //"address": user.address,
          "state": user.state,
          "country": user.country
        }
      };

      //await insuranceService.purchaseInsurance(purchaseData);
      setBusy(false);
      
    } catch (e) {
      setBusy(false);
      rethrow;
    }
  }

  void setSelectedInsuranceProduct({String? id}){
    insuranceService.currentInsuranceId = id;
    notifyListeners();
  }

  List<Budget> getBudgetData() {
    return budgetingService.budgetingModel?.budget ?? [];
  }

  CarId? getCurrentCar() {
    return budgetingService.currentCar;
  }

  List<PaymentMethod> paymentMethod = [
    PaymentMethod(
        img: 'assets/images/visa-icon.svg', details: 'UBA ***** **** **68'),
    PaymentMethod(
        img: 'assets/images/master-card-icon.svg',
        details: 'Wema ***** **** **40'),
    PaymentMethod(img: 'assets/images/epay-icon.svg', details: 'Apple Pay'),
    PaymentMethod(
        img: 'assets/images/internet-icon.svg', details: 'Internet Banking'),
  ];

  final List<String> incidentList = [
    "Accident Damage",
    "Theft or Vandalism",
    "Natural Disaster",
    "Third-Party Liability",
    "Others"
  ];

  List<String> vehicle = [
    "BMW 3 series",
    "Toyota Corolla",
    "Honda Accord",
    "Toyota RAV4 ",
    "Tesla Model Y",
    "Ford F-150",
    "Chevrolet Silverado 1500",
    "Tesla Model 3",
    "Nissan Leaf",
    "Hyundai Loniq 5",
    "Chevrolet Corvette",
    "Porsche 911",
    "Ford Mustang",
    "Harley-Davidson Street Glide",
    "Kawasaki Ninja ZX-10R",
    "Audi e-Tron",
  ];
  List<String> model = [
    "330e (Plug-in-Hybrid)",
    "XLE",
    "EX-L",
    "Limited",
    "Touring",
    "ong Range",
    "Platinum",
    "High Country",
    "WT",
    "XLT",
    "Standard Range Plus",
    "Long Range",
    "Stingyray",
    "Turbo S",
    "EcoBoost",
    "Mach 1"
  ];
  List<String> engineType = [
    "Gasoline - 2.0L Turbo 4-Cylinder",
    "Gasoline - 1.8L 4-Cylinder",
    "Hybride - 1.8L 4-Cylinder",
    "Electric - Dual Motor All-Wheel Drive",
    "Electric - RAV4 Prime (Plug-in-Hybrid)",
    "Gasoline - 2.5L 4-Cylinder",
    "Hybrid - 2.0L 4-Cylinder + Electric Motor",
    "Electric - Rear-Wheel Drive",
    "Electric - 40 kWh and 62 kWh Battery Options",
    "Electric -  58 kWh and 72.6 kWh Battery Options",
    "Gasoline - 6.2L V8",
    "Gasoline - 3.0L Twin-Turbo Flat-6",
    "Gasoline - 2.3L Turbo 4-Cylinder, 5.0L V8",
    "Harley-Davidson Street Glide",
    "Hybrid - 3.5L PowerBoost V6 + Electric Motor",
    "Gasoline - 1.5L Turbo 4-Cylinder",
  ];
  final List<String> viewDetails = [
    'Provider Name:',
    "Policy Number:",
    "Coverage Period:",
    "Renewal Date:",
    "Coverage Type:"
  ];
  final List<String> viewDetailsValue = [
    'Comprehensive Party Insurance',
    "123456789",
    "Valid from Dec 1-31, 2024",
    "Renew by Dec 29, 2024",
    "Comprehensive /Third party"
  ];
}

class PaymentMethod {
  final String img;
  final String details;
  PaymentMethod({required this.img, required this.details});
}
