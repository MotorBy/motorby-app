import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/cars/vin_check_screen.dart';
import 'package:mobile_auto_drive/ui/community/community_screen.dart';
import 'package:mobile_auto_drive/ui/components/coming_soon_view.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/ui/home/info_details_view.dart';
import 'package:mobile_auto_drive/ui/marketplace/marketplace_screen.dart';
import 'package:mobile_auto_drive/ui/profile/profile_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) => model.init(
            onErrorLogout: (){
              model.LogOut(
                  onCallBack: () {
                    popView(context);
                    navigateReplace(context, SignInScreen());
              });
            },
        ),
        builder: (context, model, child) {
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
                ),
            ),
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
                                horizontal: 5, vertical: 5
                            ),
                            decoration: BoxDecorators.containerDecoration(
                                hasOutline: true,
                                outlineWidth: 1,
                                outlineColor:
                                    XColors.primaryColor().withOpacity(0.1),
                            ),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        children: [
                                          NormalText(
                                            text: 'N600',
                                            textColor: XColors.textColor(),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                          ),
                                          NormalText(
                                            text: '/ltr',
                                            textColor: XColors.textColor(),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const XMargin(10),
                          GestureDetector(
                            onTap: (){
                              navigate(context, CommunityScreen());
                            },
                            child: Container(
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
                          ),
                          const XMargin(10),
                          GestureDetector(
                            onTap: (){
                              modalBottomSheetMenu(
                                  context: context,
                                  child: const ComingSoon(),
                                  color: XColors.background()
                              );
                            },
                            child: Container(
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
                          ),
                          const XMargin(10),
                          GestureDetector(
                            onTap: (){
                              modalBottomSheetMenu(
                                  context: context,
                                  child: const ComingSoon(),
                                  color: XColors.background()
                              );
                            },
                            child: Container(
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
                                          text: 'want a new car?',
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
                                          text: 'Save now, buy later',
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
                          ),
                          // const XMargin(10),
                          // GestureDetector(
                          //   onTap: (){
                          //     modalBottomSheetMenu(
                          //         context: context,
                          //         child: const ComingSoon(),
                          //         color: XColors.background()
                          //     );
                          //   },
                          //   child: Container(
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 5, vertical: 5),
                          //     decoration: BoxDecorators.containerDecoration(
                          //         hasOutline: true,
                          //         outlineWidth: 1,
                          //         outlineColor:
                          //         XColors.primaryColor().withOpacity(0.1)),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Row(
                          //           children: [
                          //             Padding(
                          //               padding: const EdgeInsets.symmetric(
                          //                   vertical: 2, horizontal: 10),
                          //               child: NormalText(
                          //                 text: 'Any issues?',
                          //                 textColor: XColors.textColor(),
                          //                 fontSize: 12,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         Row(
                          //           children: [
                          //             Padding(
                          //               padding:
                          //               const EdgeInsets.symmetric(horizontal: 10),
                          //               child: NormalText(
                          //                 text: 'Fix now, pay later',
                          //                 textColor: XColors.textColor().withOpacity(0.4),
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.w900,
                          //               ),
                          //             ),
                          //           ],
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          const XMargin(10),
                          GestureDetector(
                            onTap: (){
                              navigate(context, const VinCheckScreen());
                            },
                            child: Container(
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
                          ),
                        ],
                      ),
                    ),

                    const YMargin(45),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            // if(!isBusiness) {
                            //   model.updateCurrentViewState();
                            // }
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                child: NormalText(
                                  text: 'Your car(s)',
                                  textColor: model.currentViewState == CurrentView.cars ? XColors.textColor() : XColors.textColor().withOpacity(0.3),
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  navigate(context, const AddCarsScreen(action: 'add',));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecorators.containerDecoration(
                                      hasOutline: true,
                                      outlineWidth: 2,
                                      radius: 30,
                                      outlineColor: XColors.primaryColor().withOpacity(0.1)),
                                  child: Icon(
                                    Icons.add,
                                    size: 17,
                                    color: XColors.primaryColor(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const XMargin(25),
                        if(!isBusiness) ... [
                          // GestureDetector(
                          //   onTap: (){
                          //     model.updateCurrentViewState();
                          //   },
                          //   child: Row(
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //             vertical: 2, horizontal: 10),
                          //         child: NormalText(
                          //           text: 'Your sale(s)',
                          //           textColor: model.currentViewState == CurrentView.sales ? XColors.textColor() : XColors.textColor().withOpacity(0.3),
                          //           fontSize: 13,
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: () {
                          //           navigate(context, const AddCarsScreen(action: 'sell',));
                          //         },
                          //         child: Container(
                          //           padding: const EdgeInsets.all(2),
                          //           decoration: BoxDecorators.containerDecoration(
                          //               hasOutline: true,
                          //               outlineWidth: 2,
                          //               radius: 30,
                          //               outlineColor: XColors.primaryColor().withOpacity(0.1)),
                          //           child: Icon(
                          //             Icons.add,
                          //             size: 17,
                          //             color: XColors.primaryColor(),
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ]
                      ],
                    ),

                    const YMargin(15),

                    if(model.currentViewState == CurrentView.cars) ... [

                      const BudgetCars(),

                    ] else ... [

                      const SaleCars(),

                    ]

                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}

class BudgetCars extends ViewModelWidget<HomeViewModel> {
  const BudgetCars({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      height: MediaQuery.of(context).size.height - 240,
      child: Column(
        children: [
          if(viewModel.hasAddedCar) ... [

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
                onPageChanged: (i, p) {
                  viewModel.onBudgetViewUpdated(i);
                },
                padEnds: false,
                scrollPhysics: const BouncingScrollPhysics(),
              ),
              items: [
                ...List.generate(
                  viewModel.totalCarsAdded!,
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
                                    text: viewModel.budgetingModel!.budget![index].carName,
                                    textColor: XColors.textColor(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const XMargin(5),
                                    Icon(
                                      Icons.image,
                                      size: 21,
                                      color: XColors.primaryColor(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const YMargin(23),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  GestureDetector(
                                    onTap: (){
                                      navigate(context, const AddCarsScreen(action: 'sell',));
                                    },
                                    child: NormalText(
                                      text: 'Sell',
                                      textColor: XColors.textColor(),
                                      fontSize: 13,
                                    ),
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

            const YMargin(20),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 10),
                  child: Row(
                    children: [
                      NormalText(
                        text: 'Total spent: ',
                        textColor: XColors.textColor(),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      const XMargin(10),
                      NormalText(
                        text: 'N ${numberFormat(number: viewModel.budgetingModel!.budget![viewModel.currentBudgetViewIndex!].currentSpending!.toDouble())}',
                        textColor:
                        XColors.black(),
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
                        viewModel.totalList!.length,
                            (index) => GestureDetector(
                          onTap: () {
                            viewModel.resetUpdateBudgetData();

                            modalBottomSheetMenu(
                              color: Colors.white,
                              context: context,
                              child: InfoDetailsView(
                                homeViewModel: viewModel,
                                infoType: viewModel.totalList![index].toLowerCase(),
                                currentIndex: index,
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
                                    text: viewModel.totalList![index],
                                    textColor: XColors.textColor(),
                                    fontSize: 11,
                                  ),
                                  NormalText(
                                    text: viewModel.totalList![index] == 'Breakdown' || viewModel.totalList![index] == 'Mileage'
                                        ? viewModel.totalCostingAndValue![index].toString()
                                        : 'N ${numberFormat(number: viewModel.totalCostingAndValue![index].toDouble())}',
                                    textColor: XColors.textColor(),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
                              Row(
                                children: [
                                  NormalText(
                                    text:
                                    'State',
                                    textColor: XColors.textColor(),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                              const YMargin(35),
                              NormalText(
                                text:
                                'With your data inputs on your car, we are able to use our '
                                    'cutting edge analytic tools to determine two important '
                                    'states of your car so you can know how best to keep maintaining it and keep track of it performance.',
                                textColor: XColors.textColor(),
                                fontSize: 12,
                              ),
                              const YMargin(35),
                              Container(
                                decoration: BoxDecorators.containerDecoration(
                                    hasOutline: true,
                                    outlineWidth: 1,
                                    radius: 26,
                                    outlineColor: XColors.primaryColor()
                                        .withOpacity(0.1)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: Image.asset('assets/images/icons/car-health.png'),
                                      ),
                                      const XMargin(15),
                                      NormalText(
                                        text:
                                        'Your car health',
                                        textColor: XColors.textColor(),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const YMargin(15),
                              Container(
                                decoration: BoxDecorators.containerDecoration(
                                    hasOutline: true,
                                    outlineWidth: 1,
                                    radius: 26,
                                    outlineColor: XColors.primaryColor()
                                        .withOpacity(0.1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: Image.asset('assets/images/icons/price-tag.png'),
                                      ),
                                      const XMargin(15),
                                      NormalText(
                                        text:
                                        'Your car price valuation',
                                        textColor: XColors.textColor(),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //const YMargin(35),
                              // XButton(
                              //   onPressed: () {},
                              //   text: "Continue",
                              //   height: 56,
                              //   textColor: Colors.white,
                              //   buttonColor: XColors.primaryColor(),
                              //   progressColor: Colors.white,
                              //   radius: 26,
                              //   width: SizeConfig().sw(400) as double?,
                              // ),
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
                          text: 'Your ${viewModel.budgetingModel!.budget![viewModel.currentBudgetViewIndex!].carName} state',
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

          ] else ... [

            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  YMargin(MediaQuery.of(context).size.height - 380),
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: Image.asset('assets/images/add_car_icon.png'),
                  ),
                  const YMargin(30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 200,
                        child: NormalText(
                          text: 'Add your car here to manage and keep track of all the activities '
                              'you do on it and there after the motorBy app will help you detect the state and value of your car',
                          maxLines: 6,
                          textColor: XColors.black(),
                          fontSize: 13,
                        ),
                      ),
                      const YMargin(20),
                      XButton(
                        onPressed: () {
                          navigate(
                              context,
                              const AddCarsScreen(action: 'add',),
                              onCallback: (){
                                viewModel.init();
                          });
                        },
                        text: 'Add a car',
                        isLoading: viewModel.isBusy,
                        buttonColor: XColors.primaryColor(),
                        width: 120,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ],
      ),
    );
  }
}

class SaleCars extends ViewModelWidget<HomeViewModel> {
  const SaleCars({super.key});

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 240,
        child: Column(
          children: [
            const YMargin(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NormalText(
                  text: 'View All',
                  textColor: XColors.textColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
            ],),
            const YMargin(15),
            ...List.generate(
              5, (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: Container(
                          height: 55,
                          width: 70,
                          child: Image.asset('assets/images/car_placeholder.jpeg', fit: BoxFit.cover,),
                        ),
                      )
                    ],
                  ),
                  const XMargin(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormalText(
                        text: 'Name of Product',
                        textColor: XColors.textColor(),
                        fontSize: 13,
                      ),
                      NormalText(
                        text: '10,000,00',
                        textColor: XColors.textColor(),
                        fontSize: 13,
                      ),
                    ],)
                  ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
