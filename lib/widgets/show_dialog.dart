import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';

void showActionDialog(BuildContext context, {
  String? message,
  String negative = 'Back',
  String? positive,
  Function? onPressed}) {
  showDialog(context: context, builder: (BuildContext context) {
    return AlertDialog(
      backgroundColor: XColors.background(),
      content: Text(
        message ?? "Dialog action",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: XColors.textColor()),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            negative,
            style: TextStyle(color: XColors.textColor()),
          ),
        ),
        TextButton(
          onPressed: onPressed != null ? () {
            Navigator.of(context).pop();
            onPressed();
          } : () {},
          child: Text(
            positive ?? "OK",
            style: TextStyle(
                color: XColors.textColor(), fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  });
}