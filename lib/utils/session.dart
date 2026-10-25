import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_auto_drive/services/notification_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

/// Clears everything tied to the signed-in user and leaves fresh, empty
/// services registered, so the next sign in starts clean.
Future<void> endSession() async {
  // Each step is best effort: one failing must not leave the user half signed in.
  try {
    await NotificationService.instance.clearReminders();
  } catch (e) {
    debugPrint('Could not clear reminders on log out: $e');
  }
  try {
    await GoogleSignIn().signOut();
  } catch (e) {
    debugPrint('Could not sign out of Google: $e');
  }
  if (serviceLocator.isRegistered<PersistenceService>()) {
    await serviceLocator<PersistenceService>().deleteAll();
  }

  await serviceLocator.reset(dispose: false);
  await locatorSetup();
}

/// Replaces the whole stack with the sign-in screen, so back can't return to the signed-in app.
void showSignIn(NavigatorState navigator) {
  navigator.pushAndRemoveUntil(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => SignInScreen(),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    ),
    (_) => false,
  );
}

/// Ends the session and returns to sign in. Safe to call from a sheet or
/// dialog that closes first: the navigator is taken before anything is awaited.
Future<void> logOutToSignIn(BuildContext context) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  await endSession();
  if (navigator.mounted) showSignIn(navigator);
}
