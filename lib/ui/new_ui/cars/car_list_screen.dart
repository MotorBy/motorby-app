import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/components/coming_soon_view.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/cars/update_car_image_view.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/ui/marketplace/shops/shops_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/documents/car_documents_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/snackbar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class CarsListScreen extends StatelessWidget {
  const CarsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (model) => model.getBudgetData(),
        builder: (context, viewModel, child) => Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: 'Your cars',
            actions: [
              ContainerWidget(
                onTap: (){
                  navigate(context, const AddCarsScreen());
                },
                borderColor: XColors.primaryColor2(),
                hasBorder: true,
                borderThickness: 2,
                borderRadius: BorderRadius.circular(21),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: const NormalText(
                  text: 'Add new car',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const XMargin(10)
            ]
          ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [

                    if(viewModel.hasAddedCar == false) ... [

                      const NormalText(text: "No cars added")

                    ] else ... [

                      ...List.generate(
                        viewModel.totalCarsAdded!,
                            (index) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: SizeConfig.screenWidthDp!,
                            decoration: BoxDecorators.containerDecoration(
                                hasOutline: true,
                                outlineWidth: 2,
                                radius: 26,
                                outlineColor: XColors.primaryColor().withOpacity(0.1),
                            ),
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
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          modalBottomSheetMenu(
                                            color: Colors.white,
                                            context: context,
                                            height: 400,
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
                                  const YMargin(10),
                                  if(viewModel.budgetingModel!.budget![index].carId!.images!.isEmpty) ... [

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
                                                setImages: viewModel.budgetingModel!.budget![index].carId!.images,
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
                                          ...List.generate(
                                            viewModel.budgetingModel!.budget![index].carId!.images!.length,
                                                (imgIndex) => Padding(
                                            padding: const EdgeInsets.all(3.0),
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
                                                  viewModel.budgetingModel!.budget![index].carId!.images![imgIndex],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),)
                                        ],
                                      ),
                                    )
                                  ],
                                  const YMargin(8),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ],),
              ),
            ),
        )
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
                    // GestureDetector(
                    //   onTap: (){
                    //     //navigate(context, const ShopsScreen());
                    //   },
                    //   child: NormalText(
                    //     text:'Fix/service car',
                    //     textColor: XColors.textColor(),
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    // const YMargin(45),
                    // GestureDetector(
                    //   onTap: (){
                    //     modalBottomSheetMenu(
                    //       color: Colors.white,
                    //       context: context,
                    //       child: SellAddedCar(
                    //         homeViewModel: model,
                    //       ),
                    //     );
                    //   },
                    //   child: NormalText(
                    //     text:'Sell car',
                    //     textColor: XColors.textColor(),
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
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
                        navigate(context,
                            AddCarsScreen(
                              action: "edit",
                              currentCar: model.currentCar,
                            )
                        );
                      },
                      child: NormalText(
                        text: 'Edit car',
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

