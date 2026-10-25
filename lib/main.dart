import 'dart:async';
import 'package:mobile_auto_drive/services/reminder_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_details_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/services/notification_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav.dart';
import 'package:mobile_auto_drive/ui/splash/splash_screen.dart';
import 'package:mobile_auto_drive/utils/api_keys.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'firebase_options.dart';

void main() {
  runZonedGuarded(() async {

    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize notification service
    await NotificationService.instance.initialize();

    Future<PackageInfo> packageInfo() async => await PackageInfo.fromPlatform();

    await locatorSetup();
    await PersistenceService.getInstance();

    final persistence = serviceLocator<PersistenceService>();

    bool? isAuthed = persistence.getUserID.isNotEmpty;
    bool? isOnboarded = persistence.getOnboarding;

    packageInfo().then((value) {
      persistence.currentVersion = value.version;
    });

    if (kDebugMode) {
      print(persistence.getUserID);
    }

    NotificationService.onOpenTarget = (target) {
      // Only signed-in users have reminders to open.
      if (target.type != NotificationTarget.reminder || target.id == null) return;
      if (!serviceLocator.isRegistered<ReminderService>()) return;
      NotificationService.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ReminderDetailsScreen(reminderId: target.id),
        ),
      );
    };

    runApp(MyApp(isAuthed: isAuthed, isOnboarded: isOnboarded,));

    // A reminder tapped while the app was closed opens once the first frame
    // (and so the navigator) exists.
    if (isAuthed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NotificationService.instance.handleLaunchTarget();
      });
    }

  }, (error, stackTrace) {

    if (kDebugMode) {
      print(error);
      print(stackTrace);
    }

  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,
    this.isAuthed,
    this.isOnboarded = false
  });

  final bool? isAuthed;
  final bool? isOnboarded;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Lets notifications show in-app banners and open screens on tap.
      navigatorKey: NotificationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomSheetTheme: const BottomSheetThemeData(surfaceTintColor: Colors.white),
        fontFamily: "Montserrat",
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          Size size = MediaQuery.of(context).size;
          EvnConfig.init(envType: APIKey.production,);
          SizeConfig.init(context, width: size.width, height: size.height, allowFontScaling: true);
          return isAuthed != true ? SplashScreen(isAuthed: isAuthed,) : const DashBoardScreen();
        }
      ),
    );
  }
}