import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/payment_and_subscription/payment_sub_screen.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  // User data
  final String name = 'Matthew Ola';
  final String email = 'thematthewola@gmail.com';
  final String profileImage = 'assets/images/profile.jpg';
  final bool isOnline = true;
  final bool isPremium = false;

  // Navigation methods
  void navigateToMyCars() {
    // TODO: Implement navigation to cars screen
  }

  void navigateToMyDocuments() {
    // TODO: Implement navigation to documents screen
  }

  void navigateToReferralAndEarning() {
    // TODO: Implement navigation to referral screen
  }

  void navigateToSettings() {
    // TODO: Implement navigation to settings screen
  }

  void navigateToBusinessProfile() {
    // TODO: Implement navigation to business profile screen
  }

  void navigateToAboutApp() {
    // TODO: Implement navigation to about screen
  }

  void upgradeAccount() {
    // TODO: Implement upgrade account functionality
  }
}
