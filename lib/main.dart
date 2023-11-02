import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/home/home_screen.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          SizeConfig.init(context, width: size.width, height: size.height, allowFontScaling: true);
          return HomeScreen();
        }
      ),
    );
  }
}