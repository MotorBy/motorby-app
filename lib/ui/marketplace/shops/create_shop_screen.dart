import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class CreateShopScreen extends StatelessWidget {
  CreateShopScreen({super.key});

  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopDescController = TextEditingController();
  final TextEditingController _shopContactController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              popView(context);
            },
            child: Icon(Icons.arrow_back_ios_rounded, size: 18, color: XColors.black(),)
        ),
      ),
      floatingActionButton: Container(
        height: 60,
        width: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecorators.containerDecoration(
          hasOutline: false,
          color: XColors.primaryColor(),
          outlineWidth: 2,
          radius: 32,
        ),
        child: NormalText(
          text: 'Create',
          textColor: XColors.white(),
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecorators.containerDecoration(
                      hasOutline: true,
                      outlineWidth: 2,
                      radius: 32,
                      outlineColor: Colors.purpleAccent.withOpacity(0.2)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        NormalText(
                          text: 'Add Logo',
                          textColor: XColors.black(),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const YMargin(20),
            const MkInputField2(
              label: "Shop name",
              isEnabled: true,
            ),
            const YMargin(20),
            const MkInputField2(
              label: "Shop description",
              isEnabled: true,
              maxLines: 5,
            ),
            const YMargin(20),
            const MkInputField2(
              label: "Shop contact (phone number)",
              isEnabled: true,
            ),
            const YMargin(20),
            const MkInputField2(
              label: "Shop address",
              isEnabled: true,
            ),
            const YMargin(20),
            const MkInputField2(
              label: "Email address",
              isEnabled: true,
            ),
          ],),
        ),
      ),
    );
  }

}