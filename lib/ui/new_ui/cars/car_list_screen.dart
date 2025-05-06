import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/cars/update_car_image_view.dart';
import 'package:mobile_auto_drive/ui/home/home_screen.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
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
            body: Padding(
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
                                const YMargin(19),
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
        )
    );
  }
}
