import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

class ReferralViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();

  String _referralCode = '';
  double _totalEarnings = 0.0;
  int _totalReferrals = 0;
  List<ReferralHistory> _referralHistory = [];

  // Getters
  String get referralCode => _referralCode;
  double get totalEarnings => _totalEarnings;
  int get totalReferrals => _totalReferrals;
  List<ReferralHistory> get referralHistory => _referralHistory;

  Future<void> initialize() async {
    setBusy(true);
    try {
      await loadReferralData();
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> loadReferralData() async {
    // TODO: Implement API call to fetch referral data
    // This is a placeholder implementation
    _referralCode = 'MOTOR123';
    _totalEarnings = 1500.0;
    _totalReferrals = 5;
    _referralHistory = [
      ReferralHistory(
        userName: 'John Doe',
        date: DateTime.now().subtract(const Duration(days: 5)),
        earnings: 10.0,
        status: 'Completed',
      ),
      ReferralHistory(
        userName: 'Jane Smith',
        date: DateTime.now().subtract(const Duration(days: 10)),
        earnings: 10.0,
        status: 'Completed',
      ),
    ];
    notifyListeners();
  }

  Future<void> copyReferralCode() async {
    // TODO: Implement clipboard functionality
    notifyListeners();
  }

  Future<void> shareReferralCode() async {
    // TODO: Implement share functionality
    notifyListeners();
  }
}

class ReferralHistory {
  final String userName;
  final DateTime date;
  final double earnings;
  final String status;

  ReferralHistory({
    required this.userName,
    required this.date,
    required this.earnings,
    required this.status,
  });
}