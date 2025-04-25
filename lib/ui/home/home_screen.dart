import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/cars/update_car_image_view.dart';
import 'package:mobile_auto_drive/ui/community/community_screen.dart';
import 'package:mobile_auto_drive/components/coming_soon_view.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/marketplace/marketplace_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/shops/shops_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/documents/car_documents_screen.dart';
import 'package:mobile_auto_drive/ui/profile/profile_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/snackbar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) => model.init(
            onErrorLogout: () {
              navigateReplace(context, SignInScreen());
            },
          onPermissionCallBack: () {

            if(model.currentPosition == null &&
                model.locationDeclined == false) {

              modalBottomSheetMenu(
                color: Colors.white,
                isDismissible: false,
                context: context,
                child: const InfoDetailsView(
                  infoType: InfoType.locationSetup,
                ),
              );

            }
          }
        ),
        builder: (context, viewModel, child) {
          return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: XColors.white(),
            surfaceTintColor: XColors.white(),
            leading: GestureDetector(
                onTap: () {
                  if(viewModel.userService.userModel != null) {
                    navigate(context, const ProfileScreen());
                  }
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
                  if(viewModel.currentPosition == null) ... [

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {

                            modalBottomSheetMenu(
                              color: Colors.white,
                              isDismissible: false,
                              context: context,
                              child: const InfoDetailsView(
                                infoType: InfoType.locationSetup,
                              ),
                            );

                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecorators.containerDecoration(
                                hasOutline: true,
                                outlineWidth: 1,
                                radius: 26,
                                outlineColor: Colors.purpleAccent.withOpacity(0.2)
                            ),
                            child: Row(
                              children: [
                                NormalText(
                                  text: 'Allow',
                                  textColor: XColors.textColor(),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                                const XMargin(12),
                                Container(
                                    width: 15,
                                    height: 15,
                                    child: Image.asset('assets/images/icons/location-map.png'
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const XMargin(12),
                  ],
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
              child: Column(
                children: [
                  const YMargin(10),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        TopHeaderFastPicksView(
                          onPickAction: (){
                            modalBottomSheetMenu(
                              color: Colors.white,
                              context: context,
                              child: const InfoDetailsView(
                                infoType: InfoType.weatherView,
                              ),
                            );
                          },
                          mainTitle: 'Weather ${ ' •  ${viewModel.currentWeatherDescription!}' }',
                          subTitle: '${viewModel.currentWeatherValue} \u2103',
                        ),
                        const XMargin(10),
                        TopHeaderFastPicksView(
                          mainTitle: 'Avg. petrol cost in your state',
                          subTitle: 'N${viewModel.currentFuelPrice}/ltr',
                          onPickAction: () {

                            modalBottomSheetMenu(
                              color: Colors.white,
                              context: context,
                              child: const InfoDetailsView(
                                infoType: InfoType.fuelUpdate,
                              ),
                            );

                          },
                        ),
                        const XMargin(10),
                        TopHeaderFastPicksView(
                          onPickAction: (){
                            navigate(context, const CommunityScreen());
                          },
                          mainTitle: 'Want to talk about cars?',
                          subTitle: 'Join community',
                        ),
                        const XMargin(10),
                        const TopHeaderFastPicksView(
                          isComingSoon: true,
                          mainTitle: 'Going somewhere?',
                          subTitle: 'Directions',
                        ),
                        const XMargin(10),
                        const TopHeaderFastPicksView(
                          isComingSoon: true,
                          mainTitle: 'Want to drive with confidence?',
                          subTitle: 'Auto insurance',
                        ),
                        const XMargin(10),
                        const TopHeaderFastPicksView(
                          isComingSoon: true,
                          mainTitle: 'Want a new car?',
                          subTitle: 'Save now, buy later',
                        ),
                        const XMargin(10),
                        const TopHeaderFastPicksView(
                          isComingSoon: true,
                          mainTitle: 'Vehicle validity',
                          subTitle: 'VIN Check',
                        ),
                      ],
                    ),
                  ),

                  const YMargin(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NormalText(
                        text: 'swipe',
                        textColor: XColors.black().withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                      ),
                    ],
                  ),

                  const YMargin(35),

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
                                textColor: viewModel.currentViewState == CurrentView.cars ? XColors.textColor() : XColors.textColor().withOpacity(0.3),
                                fontSize: 13,
                              ),
                            ),
                            if(viewModel.busy('home-loading') == false ) ... [
                              GestureDetector(
                                onTap: () {
                                  navigate(
                                      context,
                                      const AddCarsScreen(action: 'add',),
                                      onCallback: (){
                                        viewModel.init();
                                      }
                                  );
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
                            ] else ... [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Loader(
                                    strokeWidth: 5,
                                  ),
                                ),
                              )
                            ]
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

                  if(viewModel.currentViewState == CurrentView.cars) ... [

                    BudgetCars(
                      onBudgetTypePick: (type) {

                        viewModel.resetUpdateBudgetData();

                        modalBottomSheetMenu(
                          color: Colors.white,
                          context: context,
                          child: InfoDetailsView(
                            currentIndex: viewModel.currentBudgetViewIndex,
                            infoType: InfoType.budgeting,
                          ),
                        );
                      },

                    )

                  ] else ... [

                    const SaleCars(),

                  ]

                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

class BudgetCars extends ViewModelWidget<HomeViewModel> {
  BudgetCars({
    super.key,
    this.onBudgetTypePick
  });

  Function(String? infoType)? onBudgetTypePick;

  @override
  Widget build(BuildContext context, viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if(viewModel.hasAddedCar) ... [

            CarouselSlider(
              options: CarouselOptions(
                reverse: false,
                autoPlay: false,
                clipBehavior: Clip.hardEdge,
                enableInfiniteScroll: false,
                viewportFraction: 0.98,
                height: viewModel.currentCar!.images!.isEmpty ? 150 : 165,
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
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: SizeConfig.screenWidthDp!,
                      decoration: BoxDecorators.containerDecoration(
                          hasOutline: true,
                          outlineWidth: 1,
                          radius: 26,
                          outlineColor: XColors.primaryColor().withOpacity(0.1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: [
                            const YMargin(5),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: NormalText(
                                    text: viewModel.budgetingModel!.budget![index].carName,
                                    textColor: XColors.textColor(),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    modalBottomSheetMenu(
                                      color: Colors.white,
                                      context: context,
                                      child: MoreCarAction(
                                        homeViewModel: viewModel,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecorators.containerDecoration(
                                        hasOutline: true,
                                        outlineWidth: 2,
                                        radius: 26,
                                        outlineColor: XColors.primaryColor2().withOpacity(0.2)
                                    ),
                                    child: Icon(
                                      Icons.more_vert_rounded,
                                      size: 13,
                                      color: XColors.primaryColor2(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if(viewModel.currentCar!.images!.isEmpty) ... [
                              const YMargin(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {

                                      modalBottomSheetMenu(
                                        color: Colors.white,
                                        context: context,
                                        child: UpdateCarImage(
                                          setImages: viewModel.currentCar!.images,
                                          onCompleteImageUpload: (v) async {
                                            if(v) {
                                              popView(context);
                                              await viewModel.init();
                                            }
                                          },
                                        ),
                                      );

                                    },
                                    child: Container(
                                      decoration: BoxDecorators.containerDecoration(
                                          hasOutline: true,
                                          outlineWidth: 1,
                                          radius: 32,
                                          outlineColor: Colors.purpleAccent.withOpacity(0.2)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            NormalText(
                                              text: 'Add car Images',
                                              textColor: XColors.black().withOpacity(0.5),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                            const XMargin(10),
                                            Icon(Icons.add, size: 17, color: XColors.primaryColor(),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ] else ... [

                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                  ...List.generate(viewModel.currentCar!.images!.length, (index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 90,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          viewModel.currentCar!.images![index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),)
                                ],),
                              )
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const YMargin(15),
            Container(
              decoration: BoxDecorators.containerDecoration(
                  hasOutline: true,
                  outlineWidth: 1,
                  radius: 32,
                  outlineColor: XColors.primaryColor().withOpacity(0.1)
              ),
              child: Column(children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            NormalText(
                              text: 'Spent: ',
                              textColor: XColors.textColor(),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                            const XMargin(5),
                            NormalText(
                              text: 'N${numberFormat(number: viewModel.budgetingModel!.budget![viewModel.currentBudgetViewIndex!].currentSpending!.toDouble())}',
                              textColor:
                              XColors.black(),
                              fontWeight: FontWeight.w700,
                              fontSize: 21,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => onBudgetTypePick!('budgeting'),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecorators.containerDecoration(
                                hasOutline: true,
                                outlineWidth: 1.0,
                                radius: 26,
                                outlineColor: XColors.primaryColor2().withOpacity(0.2)
                            ),
                            child: Row(
                              children: [
                                NormalText(
                                  text: 'Budget updates',
                                  textColor: XColors.textColor(),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9,
                                ),
                                const XMargin(5),
                                Container(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset('assets/images/icons/budgeting.png'
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const YMargin(2),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2, horizontal: 10
                    ),
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
              const YMargin(10),
              ...List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: GestureDetector(
                    onTap: () => onBudgetTypePick!(viewModel.totalList![index].toLowerCase()),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecorators.containerDecoration(
                        hasOutline: true,
                        outlineWidth: 1,
                        radius: 19,
                        outlineColor: XColors.primaryColor()
                            .withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  child: Image.asset('assets/images/icons/${viewModel.manageIcons![index]}'
                                  )
                                ),
                                const XMargin(20),
                                NormalText(
                                  text: viewModel.totalList![index],
                                  textColor: XColors.textColor(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ],
                            ),
                            NormalText(
                              text: viewModel.totalList![index] == 'Breakdown' || viewModel.totalList![index] == 'Mileage'
                                  ? viewModel.totalCostingAndValue![index].toString()
                                  : '₦${numberFormat(number: viewModel.totalCostingAndValue![index].toDouble())}',
                              textColor: XColors.textColor(),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Divider(thickness: 0.4, color: XColors.primaryColor().withOpacity(0.3),),
              ),
              ...List.generate(2, (i) {
                int? index = i + 3;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: GestureDetector(
                    onTap: () => onBudgetTypePick!(viewModel.totalList![index].toLowerCase()),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecorators.containerDecoration(
                        hasOutline: true,
                        outlineWidth: 1,
                        radius: 19,
                        outlineColor: XColors.primaryColor()
                            .withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset('assets/images/icons/${viewModel.manageIcons![index]}'
                                    )
                                ),
                                const XMargin(20),
                                NormalText(
                                  text: viewModel.totalList![index],
                                  textColor: XColors.textColor(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ],
                            ),
                            NormalText(
                              text: viewModel.totalList![index] == 'Breakdown' || viewModel.totalList![index] == 'Mileage'
                                  ? viewModel.totalCostingAndValue![index].toString()
                                  : '₦${numberFormat(number: viewModel.totalCostingAndValue![index].toDouble())}',
                              textColor: XColors.textColor(),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const YMargin(10),
              GestureDetector(
                onTap: () {
                  modalBottomSheetMenu(
                    color: Colors.white,
                    context: context,
                    child: GestureDetector(
                      onTap: (){
                        modalBottomSheetMenu(
                            context: context,
                            child: const ComingSoon(),
                            color: XColors.background()
                        );
                      },
                      child: const VehicleHealthView(),
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
              ),
                const YMargin(20),

            ],),
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
                      SizedBox(
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
                          navigate(context,
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

class VehicleHealthView extends StatelessWidget {
  const VehicleHealthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      color: Colors.white,
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
          const YMargin(65),
        ],
      ),
    );
  }

}

class TopHeaderFastPicksView extends StatelessWidget {

  final Function? onPickAction;
  final bool? isComingSoon;
  final String? mainTitle;
  final String? subTitle;

  const TopHeaderFastPicksView({
    super.key,
    this.isComingSoon = false,
    this.mainTitle,
    this.onPickAction,
    this.subTitle
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(isComingSoon!) {

          modalBottomSheetMenu(
              context: context,
              child: const ComingSoon(),
              color: XColors.background()
          );

        } else {

          if(onPickAction != null) {
            onPickAction!();
          }

        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 5, vertical: 5
        ),
        decoration: BoxDecorators.containerDecoration(
          hasOutline: true,
          outlineWidth: 1,
          outlineColor: XColors.primaryColor().withOpacity(0.1),
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
                    text: mainTitle ?? '',
                    textColor: isComingSoon == false ? XColors.textColor() : XColors.textColor().withOpacity(0.4),
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
                        text: subTitle ?? '',
                        textColor: isComingSoon == false ? XColors.textColor() : XColors.textColor().withOpacity(0.4),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                      // NormalText(
                      //   text: " \u2103",
                      //   textColor: XColors.textColor(),
                      //   fontSize: 17,
                      //   fontWeight: FontWeight.w600,
                      // ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SaleCars extends ViewModelWidget<HomeViewModel> {
  const SaleCars({super.key});

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return SingleChildScrollView(
      child: SizedBox(
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
                        child: SizedBox(
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

class MoreCarAction extends StatelessWidget {
  const MoreCarAction({super.key, this.homeViewModel});

  final HomeViewModel? homeViewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => homeViewModel!,
        disposeViewModel: false,
        builder: (context, model, child) {
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const YMargin(25),
                    GestureDetector(
                      onTap: (){
                        navigate(context, const ShopsScreen());
                      },
                      child: NormalText(
                        text:'Fix/service car',
                        textColor: XColors.textColor(),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const YMargin(45),
                    GestureDetector(
                      onTap: (){
                        modalBottomSheetMenu(
                          color: Colors.white,
                          context: context,
                          child: SellAddedCar(
                            homeViewModel: model,
                          ),
                        );
                      },
                      child: NormalText(
                        text:'Sell car',
                        textColor: XColors.textColor(),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const YMargin(45),
                    GestureDetector(
                      onTap: () {

                        modalBottomSheetMenu(
                          color: Colors.white,
                          context: context,
                          child: UpdateCarImage(
                            setImages: model.currentCar!.images,
                            onCompleteImageUpload: (v) async {
                              if(v) {
                                popView(context);
                                await model.init();
                              }
                            },
                          ),
                        );

                      },
                      child: NormalText(
                        text: 'Update car image',
                        textColor: XColors.textColor(),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const YMargin(45),
                    GestureDetector(
                      onTap: () {
                        navigate(
                            context,
                            CarDocumentsScreen(carId: model.currentCar!.sId,)
                        );
                      },
                      child: NormalText(
                        text: 'Manage car documents',
                        textColor: XColors.textColor(),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const YMargin(45),
                    NormalText(
                      text: 'Un-list/Delete car',
                      textColor: XColors.textColor().withOpacity(0.1),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const YMargin(25),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }
}

class SellAddedCar extends StatelessWidget {
  SellAddedCar({super.key, this.homeViewModel});

  final HomeViewModel? homeViewModel;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController saleAmountController = TextEditingController();
  final TextEditingController vinNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => homeViewModel!,
        disposeViewModel: false,
        builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              NormalText(
                text:
                    'You will be selling your car here, and it will appear in the marketplace.',
                textColor: XColors.textColor(),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              const YMargin(15),
              if(model.currentCar!.images!.isNotEmpty) ... [

                CarouselSlider(
                    options: CarouselOptions(
                        reverse: false,
                        autoPlay: false,
                        viewportFraction: 0.9,
                        height: 350,
                        enableInfiniteScroll: false,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                        scrollPhysics: const BouncingScrollPhysics()
                    ),
                    items: [
                      ...List.generate(model.currentCar!.images!.length, (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              model.currentCar!.images![index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),)
                    ]
                ),

              ] else ... [

                const YMargin(15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //model.pickImages();
                      },
                      child: Container(
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
                                text: 'Add Images (${model.addImagesList.length})',
                                textColor: XColors.black(),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                              const XMargin(10),
                              Icon(Icons.add, size: 17, color: XColors.black(),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const YMargin(5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...List.generate(
                        model.addImagesList.length,
                            (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: SizedBox(
                                width: 110,
                                height: 110,
                                child: Image.file(
                                  model.addImagesList[index],
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const YMargin(25),

              ],
              const YMargin(15),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    MainInputField(
                      label: "Valued mount",
                      controller: saleAmountController,
                      validator: (v){
                        return AnyInputValidator.emptyValidate(v, inputName: 'Amount for sale');
                      },
                      isEnabled: true,
                    ),
                    const YMargin(15),
                    MainInputField(
                      label: "VIN",
                      controller: vinNumberController,
                      validator: (v){
                        return null;
                        //return AnyInputValidator.emptyValidate(v, inputName: 'Amount for sale');
                      },
                      isEnabled: true,
                    ),
                  ],
                ),
              ),
              const YMargin(35),
              XButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()) {
                    await model.putAddedCarOnSale(
                      amount: int.parse(saleAmountController.text),
                      carId: model.currentCar!.sId,
                      onCallBack: (){
                        popView(context);
                        showSnackBar(
                            context: context,
                            message: 'Car successfully added to marketplace'
                        );
                      },
                      onErrorCallBack: (e){
                        popView(context);
                        popView(context);
                        showSnackBar(
                            context: context,
                            message: e.toString(),
                            error: true
                        );
                      }
                    );
                  }
                },
                text: 'Sell',
                height: 56,
                textColor: Colors.white,
                buttonColor: XColors.primaryColor(),
                progressColor: Colors.white,
                isLoading: model.isBusy,
                radius: 26,
                width: SizeConfig().sw(400) as double?,
              ),
              const YMargin(15),
            ],
          ),
        );
      }
    );
  }
}
