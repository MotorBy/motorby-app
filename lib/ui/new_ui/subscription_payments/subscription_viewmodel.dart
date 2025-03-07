import 'package:stacked/stacked.dart';

class SubscriptionViewModel extends BaseViewModel {
  String currentPlan = 'Free Plan';
  double monthlyPrice = 0.00;
  List<String> features = [
    'Add 2 budgeting cars',
    'Make 10 daily posts',
    '8 nearby place searches',
    'Create 1 shop',
    'Upload 10 cars',
    'Create 3 promotions',
    'Save 20 directions',
  ];

  List<PaymentCard> cards = [
    PaymentCard(
      type: 'VISA',
      bank: 'UBA',
      maskedNumber: '***** **** **68',
      logoAsset: 'assets/images/visa_logo.png',
    ),
    PaymentCard(
      type: 'Mastercard',
      bank: 'Wema',
      maskedNumber: '***** **** **68',
      logoAsset: 'assets/images/mastercard_logo.png',
    ),
  ];

  void updateNewCard() {
    // TODO: Implement update new card functionality
    print('Update new card clicked');
  }

  Future<void> upgradePlan() async {
    // TODO: Implement plan upgrade functionality
    print('Upgrade plan clicked');
  }
}

class PaymentCard {
  final String type;
  final String bank;
  final String maskedNumber;
  final String logoAsset;

  PaymentCard({
    required this.type,
    required this.bank,
    required this.maskedNumber,
    required this.logoAsset,
  });
}
