import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance_view_model.dart';
import 'package:stacked/stacked.dart';

class PaymentViewModel extends BaseViewModel {
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

  final List<String> basicFeatures = [
    'Add 2 budgeting cars',
    'Make 10 daily posts',
    '8 nearby place searches',
    'Create 1 shop',
    'Upload 10 cars',
    'Create 3 promotions',
    'Save 20 directions'
  ];

  final List<String> proFeatures = [
    'Add 2 budgeting cars',
    'Make 10 daily posts',
    '8 nearby place searches',
    'Create 1 shop',
    'Upload 10 cars',
    'Create 3 promotions',
    'Save 20 directions'
  ];

  final List<String> ultraFeatures = [
    'Add 2 budgeting cars',
    'Make 10 daily posts',
    '8 nearby place searches',
    'Create 1 shop',
    'Upload 10 cars',
    'Create 3 promotions',
    'Save 20 directions'
  ];
}
