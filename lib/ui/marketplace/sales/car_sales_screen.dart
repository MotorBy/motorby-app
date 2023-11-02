import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/marketplace/sales/sales_details_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class CarSalesScreen extends StatelessWidget {
  const CarSalesScreen({super.key});

  final bool isADealer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: XColors.white(),
      appBar: AppBar(
        backgroundColor: XColors.white(),
        surfaceTintColor: XColors.white(),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: (){
            popView(context);
          },
          child: const Icon(Icons.arrow_back_ios_rounded, size: 21, color: Colors.purpleAccent,),
        ),
        actions: [
          Container(
            height: 50,
            width: 50,
            child: Image.asset('assets/images/auto/ford_logo.jpeg'),
          ),
          const XMargin(60),
          GestureDetector(
            onTap: (){
              modalBottomSheetMenu(
                  color: Colors.white,
                  context: context,
                  child: const FilterView()
              );
            },
            child: Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecorators.containerDecoration(
                  hasOutline: true,
                  outlineWidth: 2,
                  radius: 32,
                  outlineColor: Colors.purpleAccent.withOpacity(0.2)
              ),
              child: const Icon(Icons.filter_list_rounded, color: Colors.purpleAccent, size: 16,),
            ),
          ),
          const XMargin(30),
        ],
      ),
      floatingActionButton: isADealer ? Container(
        height: 60,
        width: 200,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecorators.containerDecoration(
          hasOutline: false,
          color: XColors.primaryColor(),
          outlineWidth: 2,
          radius: 32,
        ),
        child: NormalText(
          text: 'New Sale',
          textColor: XColors.white(),
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ) : null,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const YMargin(10),
              ...List.generate(5, (index) =>
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    navigate(context, const CarSaleDetailScreen());
                  },
                  child: const CarListItem(),
                ),
              ),),
              const YMargin(60),
            ],
          ),
        ),
      ),
    );
  }
}

class CarListItem extends StatelessWidget {
  const CarListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecorators.containerDecoration(
          hasOutline: true,
          outlineWidth: 1,
          outlineColor: Colors.black.withOpacity(0.2)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 0.9,
              child: Image.asset('assets/images/car_placeholder.jpeg', fit: BoxFit.cover,),
            ),
          ),
          const YMargin(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: 'Ford Kuga (2015)',
                  textColor: XColors.black(),
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.favorite_border, color: Colors.purpleAccent, size: 19,),
                )
              ],
            ),
          ),
          const YMargin(10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      child:
                          Image.asset('assets/images/icons/gearbox.png'),
                    ),
                    const XMargin(5),
                    NormalText(
                      text: 'Automatic',
                      textColor: XColors.black(),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      child: Image.asset('assets/images/icons/seat.png'),
                    ),
                    const XMargin(5),
                    NormalText(
                      text: '5',
                      textColor: XColors.black(),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      child:
                          Image.asset('assets/images/icons/odometer.png'),
                    ),
                    const XMargin(5),
                    NormalText(
                      text: '173km',
                      textColor: XColors.black(),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const YMargin(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NormalText(
                text: 'N 11 million',
                textColor: XColors.black(),
                fontWeight: FontWeight.w900,
                fontSize: 19,
              ),
              const XMargin(15),
            ],
          ),
          const YMargin(15),
        ],
      ),
    );
  }
}

class FilterView extends StatelessWidget {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}
