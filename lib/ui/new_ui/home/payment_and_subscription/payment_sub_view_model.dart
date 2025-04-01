import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance_view_model.dart';
import 'package:stacked/stacked.dart';

class PaymentViewModel extends BaseViewModel {
  int selectedPaymentMethod = -1;
  int selectedPlan=-1;
   List<PaymentMethod> paymentMethod = [
    PaymentMethod(
        img: 'assets/images/visa-icon.svg', details: 'UBA ***** **** **68'),
    PaymentMethod(
        img: 'assets/images/master-card-icon.svg',
        details: 'Wema ***** **** **40'),

  ];

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