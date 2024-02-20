import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/marketplace_viewmodel.dart';
import 'package:mobile_auto_drive/ui/marketplace/sales/sales_details_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class CarSalesScreen extends StatelessWidget {
  const CarSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketplaceViewModel>.reactive(
        viewModelBuilder: () => MarketplaceViewModel(),
        onViewModelReady: (model) async => await model.getAllSales(),
        disposeViewModel: false,
        builder: (context, model, child) {
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
                child: Image.asset('assets/images/auto/${model.carMake!.toLowerCase()}_logo.jpeg'),
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
          floatingActionButton: !isBusiness ? GestureDetector(
            onTap: (){
              navigate(context, const AddCarsScreen(action: 'sell',));
            },
            child: Container(
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
            ),
          ) : null,
          body: RefreshIndicator(
            onRefresh: () {
              return model.reloadSales();
            },
            child: SingleChildScrollView(
                child: !model.isBusy
                    ? Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const YMargin(10),

                            if(model.salesListModel!.payload!.isNotEmpty) ... [
                              ...List.generate(
                                model.salesListModel!.payload!.length,
                                    (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      navigate(
                                          context, const CarSaleDetailScreen());
                                    },
                                    child: CarListItem(currentSaleIndex: index,),
                                  ),
                                ),
                              ),
                            ] else ... [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
                                child: NormalText(
                                  text: 'No car sales under this make, try another make.',
                                  textColor: XColors.black(),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ],

                            const YMargin(60),
                          ],
                        ),
                      )
                    : Container(
                      height: SizeConfig.screenHeightDp! - 100,
                      child: const Center(child: Loader(bgProgressColor: Colors.black,))
                ),
              ),
          ),
          );
      }
    );
  }
}

class CarListItem extends ViewModelWidget<MarketplaceViewModel> {
  const CarListItem({super.key, this.currentSaleIndex});

  final int? currentSaleIndex;

  @override
  Widget build(BuildContext context, viewModel) {
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
              child: Image.network(viewModel.salesListModel!.payload![currentSaleIndex!].images![0], fit: BoxFit.cover,),
            ),
          ),
          const YMargin(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: '${viewModel.salesListModel!.payload![currentSaleIndex!].carDetails!.carMake!}  ${viewModel.salesListModel!.payload![currentSaleIndex!].carDetails!.carModel!}  ${viewModel.salesListModel!.payload![currentSaleIndex!].carDetails!.carYear!}',
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
                      text: viewModel.salesListModel!.payload![currentSaleIndex!].carDetails!.gear,
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
                      text: viewModel.salesListModel!.payload![currentSaleIndex!].carDetails!.seats.toString(),
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
                      text: viewModel.salesListModel!.payload![currentSaleIndex!].carDetails!.mileage.toString(),
                      textColor: XColors.black(),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const YMargin(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NormalText(
                text: 'N ${amtFormatter(viewModel.salesListModel!.payload![currentSaleIndex!].salesDetails!.amountForSale)}',
                textColor: XColors.black(),
                fontWeight: FontWeight.w600,
                fontSize: 18,
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
