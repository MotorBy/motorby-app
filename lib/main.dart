import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/ui/splash/splash_screen.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

void main() {
  runZonedGuarded(() async {

    WidgetsFlutterBinding.ensureInitialized();
    //await Firebase.initializeApp();

    await locatorSetup();
    await PersistenceService.getInstance();

    final persistence = serviceLocator<PersistenceService>();

    bool? isAuthed = persistence.getUserID.isNotEmpty;

    if (kDebugMode) {
      print(persistence.getUserID);
    }

    runApp(MyApp(isAuthed: isAuthed,));

  }, (error, stackTrace) {

    if (kDebugMode) {
      print(error);
      print(stackTrace);
    }

  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isAuthed});

  final bool? isAuthed;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: "Montserrat",
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          Size size = MediaQuery.of(context).size;
          EvnConfig.init(envType: 'Dev',);
          SizeConfig.init(context, width: size.width, height: size.height, allowFontScaling: true);
          return SplashScreen(isAuthed: isAuthed,);
        }
      ),
    );
  }
}