import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class ShopDetailsScreen extends StatelessWidget {
  const ShopDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XColors.white(),
      appBar: AppBar(
        backgroundColor: XColors.white(),
        leading: GestureDetector(
          onTap: (){
            popView(context);
          },
          child: const Icon(Icons.arrow_back_ios_rounded, size: 21, color: Colors.purpleAccent,),
        ),
      ),
      floatingActionButton: Row(
        children: [
          const XMargin(32),
          Container(
            height: 60,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            decoration: BoxDecorators.containerDecoration(
              hasOutline: false,
              color: XColors.primaryColor(),
              outlineWidth: 2,
              radius: 32,
            ),
            child: NormalText(
              text: 'New parts',
              textColor: XColors.white(),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const XMargin(12),
          Container(
            height: 60,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            decoration: BoxDecorators.containerDecoration(
              hasOutline: false,
              color: XColors.primaryColor(),
              outlineWidth: 2,
              radius: 32,
            ),
            child: NormalText(
              text: 'New Car',
              textColor: XColors.white(),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      32,
                    ),
                  ),
                  child: Image.asset('assets/images/auto/bmw_logo.jpeg'),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecorators.containerDecoration(
                          hasOutline: true,
                          outlineWidth: 2,
                          radius: 26,
                          outlineColor: Colors.purpleAccent.withOpacity(0.2)
                      ),
                      child: NormalText(
                        text: 'Contact Shop',
                        textColor: XColors.textColor(),
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                    const XMargin(15),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecorators.containerDecoration(
                          hasOutline: true,
                          outlineWidth: 2,
                          radius: 26,
                          outlineColor: Colors.purpleAccent.withOpacity(0.2)
                      ),
                      child: NormalText(
                        text: 'Visit Shop',
                        textColor: XColors.textColor(),
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const YMargin(10),
            NormalText(
              text: 'Auto shop',
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            const YMargin(10),
            NormalText(
              text: 'Litehsds trher sjfwlnn '
                  'wjnrh ssjtekj sjre g szdkjoi '
                  'azs w yrdtf xrkw e wrtr szfkenr dfdb weiudgn qwosf ety ndjhwihf',
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            const YMargin(20),
            Row(
              children: [
                const Icon(Icons.star_border_purple500_rounded),
                const XMargin(5),
                NormalText(
                  text: '4/5',
                  textColor: XColors.textColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ],
            ),
            const YMargin(20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecorators.containerDecoration(
                      hasOutline: true,
                      outlineWidth: 2,
                      radius: 26,
                      outlineColor: Colors.purpleAccent.withOpacity(0.2)
                  ),
                  child: NormalText(
                    text: 'Cars',
                    textColor: XColors.textColor(),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const XMargin(10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecorators.containerDecoration(
                      hasOutline: true,
                      outlineWidth: 2,
                      radius: 26,
                      outlineColor: Colors.purpleAccent.withOpacity(0.2)
                  ),
                  child: NormalText(
                    text: 'Parts',
                    textColor: XColors.textColor(),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
        ],),
      ),
    );
  }
}