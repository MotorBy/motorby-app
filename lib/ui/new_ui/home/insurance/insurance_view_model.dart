import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/get_insurance_product_model.dart';
import 'package:mobile_auto_drive/models/insurance_product_details.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/firebase_service.dart';
import 'package:mobile_auto_drive/services/insurance_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
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

  // KYC Data Fields
  Map<String, dynamic> kycData = {
    'kyc_data': {
      'country': '',
      'name': '',
      'date_of_birth': '',
      'place_of_birth': '',
      'gender': '',
      'nationality': '',
      'documents': [{
        'type': 'national_id',
        'number': "",
        'url': '',
        'front': '',
        'back': '',
        'expiry_date': ""
      }]
    }
  };

  void prefillUserData({
    required TextEditingController nameController,
    required TextEditingController nationalityController,
    required TextEditingController stateController,
  }) {
    if (userService.userModel?.payload?.user != null) {

      final user = userService.userModel!.payload!.user!;
      nameController.text = user.fullname ?? '';
      nationalityController.text = user.country ?? '';
      stateController.text = user.state ?? '';

    }
  }

  // KYC Data Handling
  Future<void> updateKycData({
    required String fullName,
    required String dateOfBirth,
    required String placeOfBirth,
    required String gender,
    required String nationality,
    required String nationalIdNumber,
    String? state,
    Function? onCallBack,
    Function(String? e)? onError,
  }) async {

    kycData['kyc_data']['country'] = nationality;
    kycData['kyc_data']['name'] = fullName;
    kycData['kyc_data']['date_of_birth'] = dateOfBirth;
    kycData['kyc_data']['place_of_birth'] = placeOfBirth;
    kycData['kyc_data']['gender'] = gender.toLowerCase();
    kycData['kyc_data']['nationality'] = nationality;
    kycData['kyc_data']['state'] = state;
    kycData['kyc_data']['documents'][0]['number'] = nationalIdNumber;

    setBusy(true);

    await uploadDocument(front: true, onCallback: () {});
    await uploadDocument(front: false, onCallback: () async {

      await userService.updateUsers(data: kycData).then((v) {

        setBusy(false);
        userModel = userService.userModel;
        hasKycVerification = true;
        onCallBack?.call();

      }).onError((e, s) {
        print(s);
        setBusy(false);
        onError?.call(e.toString());
      });

    });

  }

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

  Future getInsuranceProductDetails({String? productId}) async {
    setBusy(true);
    insuranceService.currentInsuranceId = productId ?? insuranceService.currentInsuranceId;

    await insuranceService.getInsuranceProductDetails(productId: productId ?? insuranceService.currentInsuranceId).then((v) {

      insuranceProductDetails = insuranceService.insuranceProductDetails;
      setBusy(false);

    }).onError((e, s) {
      print(s);
      setBusy(false);
    });

  }

  Future<void> pickDocument({ bool? front = true, Function? onComplete }) async {
    try {

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {

        if(onComplete != null) {
          if(front!) {
            filePickerResultMain = result;
          } else {
            filePickerResultBack = result;
          }
          onComplete();
        }

      }

    } catch (e) {
      print('Error uploading document: $e');
    }
  }

  Future<void> uploadDocument({ bool? front = true, Function? onCallback, Function(String e)? onError}) async {

    try {

      setBusyForObject('upload', true);

      await FirebaseService().uploadFileToStorage(
          storagePath: 'profile/kyc/${userService.userModel!.payload!.user?.userId}/${front == true ? filePickerResultMain!.files.single.name : filePickerResultBack!.files.single.name}',
          filePath: front == true ? filePickerResultMain!.files.single.path! : filePickerResultBack!.files.single.path!,
          onCallBack: (s) async {
            if(front!) {
              kycData['kyc_data']['documents'][0]['front'] = s;
              kycData['kyc_data']['documents'][0]['url'] = s;
            } else {
              kycData['kyc_data']['documents'][0]['back'] = s;
              kycData['kyc_data']['documents'][0]['url'] = s;
            }

            onCallback?.call();

          }
      );

    } catch (e) {
      print('Error uploading document: $e');

      setBusyForObject('upload', false);
      onError!.call(e.toString());
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
