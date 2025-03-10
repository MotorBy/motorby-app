import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/ui/onboarding/onboarding_screen.dart';
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

    runApp(MyApp(isAuthed: isAuthed, isOnboarded: isOnboarded,));

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
          EvnConfig.init(envType: APIKey.appStage,);
          SizeConfig.init(context, width: size.width, height: size.height, allowFontScaling: true);
          return isOnboarded == true ? SplashScreen(isAuthed: isAuthed,) : const NewHomeScreen();
        }
      ),
    );
  }
}