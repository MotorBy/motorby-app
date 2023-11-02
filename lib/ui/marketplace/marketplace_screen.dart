import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/marketplace/sales/car_sales_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/shops/shops_screen.dart';
import 'package:mobile_auto_drive/utils/car_make_data.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class MarketPlace extends StatelessWidget {
  const MarketPlace({super.key});

  final bool? pickOptionsBeforeNav = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: XColors.white(),
        surfaceTintColor: XColors.white(),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: (){
            popView(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.arrow_back_ios_rounded, size: 21, color: Colors.purpleAccent,),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  decoration: BoxDecorators.containerDecoration(
                      hasOutline: true,
                      outlineWidth: 2,
                      radius: 32,
                      outlineColor: Colors.purpleAccent.withOpacity(0.2)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NormalText(
                          text: 'All',
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ],
                    ),
                  ),
                ),
                const YMargin(16),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: 16.0, // gap between adjacent chips
                  runSpacing: 16.0, // gap between lines
                  children: <Widget>[
                    ...List.generate(carMakeData.length, (index) => GestureDetector(
                      onTap: (){

                        if(pickOptionsBeforeNav!) {
                          modalBottomSheetMenu(
                              context: context,
                              color: XColors.background(),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    const YMargin(20),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            navigate(context, const CarSalesScreen());
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecorators.containerDecoration(
                                                hasOutline: true,
                                                outlineWidth: 2,
                                                radius: 32,
                                                outlineColor: Colors.purpleAccent.withOpacity(0.2)
                                            ),
                                            child: NormalText(
                                              text: 'Sales',
                                              textColor: XColors.textColor(),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            navigate(context, ShopsScreen());
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecorators.containerDecoration(
                                                hasOutline: true,
                                                outlineWidth: 2,
                                                radius: 32,
                                                outlineColor: Colors.purpleAccent.withOpacity(0.2)
                                            ),
                                            child: NormalText(
                                              text: 'Shops',
                                              textColor: XColors.textColor(),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        )
                                      ],),
                                    const YMargin(20),
                                  ],
                                ),
                              )
                          );
                        }

                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: carMakeData[index]['name']!.length < 6 ? carMakeData[index]['name']!.length * 33 : carMakeData[index]['name']!.length * 19,
                        decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 2,
                            radius: 32,
                            outlineColor: Colors.purpleAccent.withOpacity(0.1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    32,
                                  ),
                                ),
                                child: Image.asset(carMakeData[index]['logo']!),
                              ),
                              const XMargin(10),
                              NormalText(
                                text: carMakeData[index]['name'],
                                textColor: XColors.textColor(),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),)
                  ],
                ),
                const YMargin(80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
