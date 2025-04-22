import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

void listHelperPicker({
  required List<String?> listString,
    String? title,
    Function(String? selected)? selected,
    double? height,
    BuildContext? context}) {

  modalBottomSheetMenu(
      context: context!,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const YMargin(20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 5, bottom: 8),
                  child: NormalText(
                    text: title,
                    fontWeight: FontWeight.w700,
                    textColor: XColors.black(),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const YMargin(20),

            ...List.generate(listString.length, (index) {

              return Padding(
                padding:
                const EdgeInsets.only(left: 24, top: 5, bottom: 18),
                child: InkWell(
                  onTap: () {
                    selected!(listString[index]);
                    Navigator.pop(context);
                  },
                  child: NormalText(
                    text: listString[index],
                    textColor: XColors.black(),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );

            }),

            const YMargin(20),
          ],
        ),
      ),
  );
}
