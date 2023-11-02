import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

class XMargin extends StatelessWidget {
  const XMargin(this.x, {super.key});
  final double x;
  @override
  Widget build(BuildContext context) {
    final SizeConfig config = SizeConfig();
    
    return SizedBox(width: config.sw(x) as double?);
  }
}

class YMargin extends StatelessWidget {
  const YMargin(this.y, {super.key});
  final double y;
  @override
  Widget build(BuildContext context) {
    final SizeConfig config = SizeConfig();

    return SizedBox(height: config.sh(y) as double?);
  }
}

double screenHeight(BuildContext context, {double percent = 1}) =>
    MediaQuery.of(context).size.height * percent;

double screenWidth(BuildContext context, {double percent = 1}) =>
    MediaQuery.of(context).size.width * percent;