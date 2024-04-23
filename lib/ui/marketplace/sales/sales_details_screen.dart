import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_auto_drive/ui/cars/update_car_image_view.dart';
import 'package:mobile_auto_drive/ui/marketplace/sales/sales_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

import '../../components/coming_soon_view.dart';

class CarSaleDetailScreen extends StatelessWidget {
  const CarSaleDetailScreen({super.key, this.salesViewModel});

  final bool? isABusiness = false;
  final SalesViewModel? salesViewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesViewModel>.reactive(
        viewModelBuilder: () => salesViewModel ?? SalesViewModel(),
        disposeViewModel: false,
        builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: (){
                popView(context);
              },
              child: const Icon(Icons.arrow_back_ios_rounded, size: 21, color: Colors.purpleAccent,),
            ),
            actions: [
              if(model.isSalesMaker()) ... [
                GestureDetector(
                  onTap: (){
                    modalBottomSheetMenu(
                        context: context,
                        child: const ComingSoon(),
                        color: XColors.background()
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecorators.containerDecoration(
                        hasOutline: true,
                        outlineWidth: 2,
                        radius: 26,
                        outlineColor: Colors.purpleAccent.withOpacity(0.2)
                    ),
                    child: NormalText(
                      text: 'Allow Bidding',
                      textColor: XColors.textColor().withOpacity(0.3),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                const XMargin(15),
                GestureDetector(
                  onTap: (){
                    modalBottomSheetMenu(
                      color: Colors.white,
                      context: context,
                      child: UpdateCarImage(
                        fromSale: true,
                        setImages: model.currentSalesModel!.images,
                        onCompleteImageUpload: (v) async {
                          if(v) {
                            popView(context);

                          }
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecorators.containerDecoration(
                        hasOutline: true,
                        outlineWidth: 2,
                        radius: 26,
                        outlineColor: Colors.purpleAccent.withOpacity(0.2)
                    ),
                    child: NormalText(
                      text: 'update car images',
                      textColor: XColors.textColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const XMargin(25),
            ],
          ),
          floatingActionButton: Container(
            height: 60,
            child: model.isSalesMaker() ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(model.currentSalesModel!.salesDetails!.isSold == false) ... [
                  XButton(
                    onPressed: () {

                      modalBottomSheetMenu(
                          context: context,
                          child: Container(
                            child: Column(children: [
                              const YMargin(50),
                              NormalText(
                                text: 'You are about to confirm this sale is sold out, click confirm below',
                                textColor: XColors.textColor(),
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              const YMargin(50),
                              XButton(
                                onPressed: () {
                                  popView(context);
                                  model.updateCurrentSale(
                                      updateType: 'isSold'
                                  );
                                },
                                text: 'Confirm',
                                isLoading: model.busy('sold-out'),
                                buttonColor: XColors.primaryColor(),
                                width: 120,
                              ),
                              const YMargin(30),

                            ],),
                          ),
                          color: XColors.background()
                      );

                    },
                    text: 'Sold out?',
                    isLoading: model.busy('sales-updating'),
                    buttonColor: XColors.primaryColor(),
                    width: 120,
                  ),
                  const XMargin(12),
                ],
                XButton(
                  onPressed: () {
                    modalBottomSheetMenu(
                        context: context,
                        child: const ComingSoon(),
                        color: XColors.background()
                    );
                  },
                  text: 'Promote',
                  isLoading: model.busy('sold-out'),
                  buttonColor: XColors.primaryColor().withOpacity(0.3),
                  width: 120,
                ),
              ],
            ) : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const XMargin(12),
                XButton(
                  onPressed: () {
                    modalBottomSheetMenu(
                        context: context,
                        child: const ComingSoon(),
                        color: XColors.background()
                    );
                  },
                  text: 'Place bids',
                  isLoading: false,
                  buttonColor: XColors.primaryColor().withOpacity(0.3),
                  width: 110,
                ),
                const XMargin(12),
                XButton(
                  onPressed: () {
                    modalBottomSheetMenu(
                        context: context,
                        child: Container(
                          padding: const EdgeInsets.all(19),
                          child: Column(children: [
                            const YMargin(10),
                            NormalText(
                              text: 'Reach the contact for this sale',
                              textColor: XColors.textColor(),
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            const YMargin(30),
                            Row(
                              children: [
                                NormalText(
                                  text: 'Phonenumber: ',
                                  textColor: XColors.textColor().withOpacity(0.4),
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                const XMargin(10),
                                NormalText(
                                  text: model.currentSalesModel!.sellerDetails!.phonenumber,
                                  textColor: XColors.textColor(),
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                            const YMargin(20),
                            Row(
                              children: [
                                NormalText(
                                  text: 'Name: ',
                                  textColor: XColors.textColor().withOpacity(0.4),
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                const XMargin(10),
                                NormalText(
                                  text: model.currentSalesModel!.sellerDetails!.name,
                                  textColor: XColors.textColor(),
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                            const YMargin(50),
                          ],),
                        ),
                        color: XColors.background()
                    );
                  },
                  text: 'Contact sales',
                  isLoading: model.busy('sold-out'),
                  buttonColor: XColors.primaryColor(),
                  width: 110,
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              CarouselSlider(
                  options: CarouselOptions(
                      reverse: false,
                      autoPlay: false,
                      viewportFraction: 0.9,
                      enableInfiniteScroll: false,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.horizontal,
                      scrollPhysics: const BouncingScrollPhysics()
                  ),
                  items: [
                    ...List.generate(model.currentSalesModel!.images!.length, (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              model.currentSalesModel!.images![index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
                            text: model.currentSalesModel!.name ?? 'Car',
                            textColor: XColors.black(),
                            fontWeight: FontWeight.w700,
                            fontSize: model.currentSalesModel!.name != null ? model.currentSalesModel!.name!.length > 23 ? 13 : 16 : 12,
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
                    // Container(
                    //   alignment: Alignment.center,
                    //   padding: const EdgeInsets.all(3),
                    //   decoration: BoxDecorators.containerDecoration(
                    //       hasOutline: true,
                    //       outlineWidth: 2,
                    //       radius: 32,
                    //       outlineColor: XColors.primaryColor().withOpacity(0.1)
                    //   ),
                    //   child: NormalText(
                    //     text: 'Promoted',
                    //     textColor: XColors.textColor().withOpacity(0.8),
                    //     fontWeight: FontWeight.w700,
                    //     fontSize: 11,
                    //   ),
                    // ),
                    const YMargin(15),
                    Column(
                      children: [
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
                                    text: '12km',
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
                                    text: '2',
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
                                    text: '15',
                                    textColor: XColors.black(),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const YMargin(25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // NormalText(
                        //   text: 'posted by: ${model.currentSalesModel!.salesDetails!.amountForSale}',
                        //   textColor: XColors.black(),
                        //   fontWeight: FontWeight.w400,
                        //   fontSize: 11,
                        // ),
                        const XMargin(25),
                        NormalText(
                          text: 'N ${amtFormatter(model.currentSalesModel!.salesDetails!.amountForSale)}',
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
                              text: model.currentSalesModel!.carDetails!.condition ?? 'Foreign used',
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
        );
      }
    );
  }
}