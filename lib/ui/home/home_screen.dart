import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/home/info_details_view.dart';
import 'package:mobile_auto_drive/ui/marketplace/marketplace_screen.dart';
import 'package:mobile_auto_drive/ui/profile/profile_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String>? totalList = [
    'Fueling',
    'Servicing',
    'Repairing',
    'Mileage',
    'Breakdown'
  ];
  final List<String>? totalCosting = [
    '10,043',
    '6,455',
    '23,000',
    '124,533',
    '2'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: XColors.white(),
        surfaceTintColor: XColors.white(),
        leading: GestureDetector(
            onTap: () {
              navigate(context, const ProfileScreen());
            },
            child: Icon(
              Icons.account_circle_outlined,
              size: 28,
              color: XColors.black(),
            )),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  navigate(context, const MarketPlace());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NormalText(
                    text: 'Marketplace',
                    textColor: XColors.textColor(),
                    fontSize: 13,
                  ),
                ),
              ),
              Icon(
                Icons.shopping_basket,
                size: 18,
                color: XColors.primaryColor(),
              ),
              const XMargin(10)
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: SizeConfig.screenHeightDp! - 60,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 1,
                            outlineColor:
                                XColors.primaryColor().withOpacity(0.1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  child: NormalText(
                                    text: 'Petrol cost in your city Today',
                                    textColor: XColors.textColor(),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                  child: NormalText(
                                    text: 'N 600',
                                    textColor: XColors.textColor(),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const XMargin(10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 1,
                            outlineColor:
                            XColors.primaryColor().withOpacity(0.1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  child: NormalText(
                                    text: 'Current weather',
                                    textColor: XColors.textColor(),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  child: NormalText(
                                    text: '20c',
                                    textColor: XColors.textColor(),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const XMargin(10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 1,
                            outlineColor:
                            XColors.primaryColor().withOpacity(0.1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  child: NormalText(
                                    text: 'Going somewhere?',
                                    textColor: XColors.textColor(),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  child: NormalText(
                                    text: 'Directions',
                                    textColor: XColors.textColor(),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const XMargin(10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 1,
                            outlineColor:
                            XColors.primaryColor().withOpacity(0.1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  child: NormalText(
                                    text: 'Any issues?',
                                    textColor: XColors.textColor(),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  child: NormalText(
                                    text: 'Fix now, pay later',
                                    textColor: XColors.textColor().withOpacity(0.4),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const XMargin(10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 1,
                            outlineColor:
                            XColors.primaryColor().withOpacity(0.1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  child: NormalText(
                                    text: 'Vehicle validity',
                                    textColor: XColors.textColor(),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  child: NormalText(
                                    text: 'VIN Check',
                                    textColor: XColors.textColor().withOpacity(0.4),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const XMargin(10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 1,
                            outlineColor:
                            XColors.primaryColor().withOpacity(0.1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  child: NormalText(
                                    text: 'Want to talk about cars?',
                                    textColor: XColors.textColor(),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  child: NormalText(
                                    text: 'Community',
                                    textColor: XColors.textColor().withOpacity(0.4),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const YMargin(15),
                const Divider(
                  thickness: 0.2,
                ),
                const YMargin(15),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10),
                          child: NormalText(
                            text: 'Your car(s)',
                            textColor: XColors.textColor(),
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            navigate(context, AddCarsScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 1),
                            decoration: BoxDecorators.containerDecoration(
                                hasOutline: true,
                                outlineWidth: 2,
                                outlineColor:
                                    XColors.primaryColor().withOpacity(0.1)),
                            child: Row(
                              children: [
                                NormalText(
                                  text: 'New',
                                  textColor: XColors.textColor(),
                                  fontSize: 13,
                                ),
                                Icon(
                                  Icons.add,
                                  size: 17,
                                  color: XColors.black(),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const YMargin(15),
                    CarouselSlider(
                        options: CarouselOptions(
                            reverse: false,
                            autoPlay: false,
                            clipBehavior: Clip.hardEdge,
                            enableInfiniteScroll: false,
                            viewportFraction: 0.9,
                            height: 130,
                            autoPlayInterval: const Duration(seconds: 5),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            scrollDirection: Axis.horizontal,
                            padEnds: false,
                            scrollPhysics: const BouncingScrollPhysics()),
                        items: [
                          ...List.generate(
                            4,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: SizeConfig.screenWidthDp!,
                                decoration: BoxDecorators.containerDecoration(
                                    hasOutline: true,
                                    outlineWidth: 1,
                                    radius: 26,
                                    outlineColor: XColors.primaryColor()
                                        .withOpacity(0.1)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: NormalText(
                                              text: 'LEXUS RX350',
                                              textColor: XColors.textColor(),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              NormalText(
                                                text: 'Images',
                                                textColor: XColors.textColor(),
                                                fontSize: 13,
                                              ),
                                              const XMargin(5),
                                              Icon(
                                                Icons.image,
                                                size: 18,
                                                color: XColors.black(),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const YMargin(23),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            // NormalText(
                                            //   text:'Rent',
                                            //   textColor: XColors.textColor(),
                                            //   fontSize: 13,
                                            // ),
                                            NormalText(
                                              text: 'Fix/Service',
                                              textColor: XColors.textColor(),
                                              fontSize: 13,
                                            ),
                                            NormalText(
                                              text: 'Sell',
                                              textColor: XColors.textColor(),
                                              fontSize: 13,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                    ),
                  ],
                ),
                const YMargin(20),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NormalText(
                            text: 'Total spent: ',
                            textColor: XColors.textColor(),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                          NormalText(
                            text: 'N 100,000',
                            textColor:
                                XColors.primaryColor().withOpacity(0.7),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ],
                      ),
                    ),
                    const YMargin(2),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 10),
                      child: NormalText(
                        maxLines: 2,
                        text:
                            'The figures are updated based on your inputs you make daily or any time. To update this tap on any section below',
                        textColor: XColors.textColor().withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const YMargin(30),
                Expanded(
                  child: Column(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 21.0, // gap between adjacent chips
                        runSpacing: 24.0, // gap between lines
                        children: <Widget>[
                          ...List.generate(
                            totalList!.length,
                            (index) => GestureDetector(
                              onTap: () {
                                modalBottomSheetMenu(
                                    color: Colors.white,
                                    context: context,
                                    child: InfoDetailsView(
                                      infoType: totalList![index].toLowerCase(),
                                    ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecorators.containerDecoration(
                                    hasOutline: true,
                                    outlineWidth: 1,
                                    radius: 32,
                                    outlineColor: XColors.primaryColor()
                                        .withOpacity(0.1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    children: [
                                      NormalText(
                                        text: totalList![index],
                                        textColor: XColors.textColor(),
                                        fontSize: 11,
                                      ),
                                      NormalText(
                                        text: totalList![index] ==
                                                    'Breakdown' ||
                                                totalList![index] == 'Mileage'
                                            ? totalCosting![index]
                                            : 'N${totalCosting![index]}',
                                        textColor: XColors.textColor(),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const YMargin(35),
                      GestureDetector(
                        onTap: () {
                          modalBottomSheetMenu(
                            color: Colors.white,
                            context: context,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const YMargin(35),
                                  NormalText(
                                    text:
                                        'The valuation car will be calculated based on your overall '
                                        'inputs on your current car, So please do well to make sure all data '
                                        'are set currently to accurate get the value of your car',
                                    textColor: XColors.textColor(),
                                    fontSize: 12,
                                  ),
                                  const YMargin(35),
                                  XButton(
                                    onPressed: () {},
                                    text: "Continue",
                                    height: 56,
                                    textColor: Colors.white,
                                    buttonColor: XColors.primaryColor(),
                                    progressColor: Colors.white,
                                    radius: 26,
                                    width: SizeConfig().sw(400) as double?,
                                  ),
                                  const YMargin(35),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecorators.containerDecoration(
                              hasOutline: true,
                              outlineWidth: 2,
                              radius: 32,
                              outlineColor:
                                  XColors.primaryColor().withOpacity(0.1)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NormalText(
                              maxLines: 2,
                              text: 'Your LEXUS RX350 valuation',
                              textColor:
                                  XColors.primaryColor().withOpacity(0.7),
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
