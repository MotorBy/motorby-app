import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class CarSaleDetailScreen extends StatelessWidget {
  const CarSaleDetailScreen({super.key});

  final bool? isABusiness = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            popView(context);
          },
          child: const Icon(Icons.arrow_back_ios_rounded, size: 21, color: Colors.purpleAccent,),
        ),
      ),
      floatingActionButton: Container(
        height: 60,
        child: isABusiness! ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecorators.containerDecoration(
                hasOutline: false,
                color: XColors.primaryColor(),
                outlineWidth: 2,
                radius: 32,
              ),
              child: NormalText(
                text: 'Sold out?',
                textColor: XColors.white(),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const XMargin(12),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecorators.containerDecoration(
                hasOutline: false,
                color: XColors.primaryColor(),
                outlineWidth: 2,
                radius: 32,
              ),
              child: NormalText(
                text: 'Promote',
                textColor: XColors.white(),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecorators.containerDecoration(
                hasOutline: false,
                color: XColors.primaryColor(),
                outlineWidth: 2,
                radius: 32,
              ),
              child: NormalText(
                text: 'Get contact',
                textColor: XColors.white(),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const XMargin(12),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecorators.containerDecoration(
                hasOutline: false,
                color: XColors.primaryColor(),
                outlineWidth: 2,
                radius: 32,
              ),
              child: NormalText(
                text: 'Create budget',
                textColor: XColors.white(),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            CarouselSlider(
                options: CarouselOptions(
                    reverse: false,
                    autoPlay: true,
                    viewportFraction: 0.9,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                    scrollPhysics: const BouncingScrollPhysics()
                ),
                items: [
                  ...List.generate(4, (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Image.asset('assets/images/car_placeholder.jpeg', fit: BoxFit.cover,),
                    ),
                  ),)
                ]
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              child: Column(
                children: [
                  const YMargin(15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NormalText(
                          text: 'Ford Kuga (2015)',
                          textColor: XColors.black(),
                          fontWeight: FontWeight.w700,
                          fontSize: 19,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.favorite_border, color: Colors.purpleAccent, size: 24,),
                        )
                      ],
                    ),
                  ),
                  const YMargin(15),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecorators.containerDecoration(
                        hasOutline: true,
                        outlineWidth: 2,
                        radius: 32,
                        outlineColor: XColors.primaryColor().withOpacity(0.1)
                    ),
                    child: NormalText(
                      text: 'Promoted',
                      textColor: XColors.textColor().withOpacity(0.8),
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const YMargin(15),
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
                              text: '124km',
                              textColor: XColors.black(),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const YMargin(35),
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
                              Image.asset('assets/images/icons/airbag.png'),
                            ),
                            const XMargin(5),
                            NormalText(
                              text: '3',
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
                              child: Image.asset('assets/images/icons/aircondition.png'),
                            ),
                            const XMargin(5),
                            NormalText(
                              text: 'ok',
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
                              Image.asset('assets/images/icons/speaker.png'),
                            ),
                            const XMargin(5),
                            NormalText(
                              text: '10',
                              textColor: XColors.black(),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const YMargin(25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NormalText(
                        text: 'posted by: MADAutos',
                        textColor: XColors.black(),
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                      ),
                      NormalText(
                        text: 'N 11 million',
                        textColor: XColors.black(),
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                      ),
                    ],
                  ),
                  const YMargin(25),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NormalText(
                            text: 'Condition',
                            textColor: XColors.black(),
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                          NormalText(
                            text: 'Brand new',
                            textColor: XColors.black(),
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}