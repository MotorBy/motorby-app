import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/sales/sales_details_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/sales/sales_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/shimmer_loader.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class CarSalesScreen extends StatelessWidget {
  const CarSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesViewModel>.reactive(
        viewModelBuilder: () => SalesViewModel(),
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
          floatingActionButton: !isBusiness ? XButton(
            onPressed: () {
              navigate(context, const AddCarsScreen(action: 'sell',));
            },
            text: 'New sale',
            isLoading: model.isBusy,
            buttonColor: XColors.primaryColor(),
            width: 120,
          ) : null,
          body: RefreshIndicator(
            onRefresh: () {
              return model.reloadSales();
            },
            child: SingleChildScrollView(
                child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const YMargin(10),

                            if(model.salesListModel == null && model.hasError) ... [

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                                child: NormalText(
                                  text: 'No car sales under this make, try another make.',
                                  textColor: XColors.black(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),

                            ],

                            ...List.generate(
                              model.salesListModel != null ? model.salesListModel!.payload!.length : 6,
                                  (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    model.setCurrentSale(model.salesListModel!.payload![index]);
                                    navigate(context, CarSaleDetailScreen(salesViewModel: model,));
                                  },
                                  child: Shimmer(
                                    child: ShimmerLoading(
                                      isLoading: model.busy('sales-loading') || model.salesListModel == null,
                                      child: _buildItem(
                                          isLoading: model.busy('sales-loading') || model.salesListModel == null,
                                          currentSaleIndex: index,
                                          viewModel: model
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const YMargin(10),
                          ],
                        ),
                      )
            ),
          ),
        );
      }
    );
  }

  Widget _buildItem({
    bool? isLoading = false,
    SalesViewModel? viewModel,
    int? currentSaleIndex
  }) {
    if (isLoading!) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 154,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 180,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 60,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    viewModel!.salesListModel!.payload![currentSaleIndex!].images![0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const YMargin(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: '${viewModel.salesListModel!.payload![currentSaleIndex].carDetails!.carMake!}  ${viewModel.salesListModel!.payload![currentSaleIndex].carDetails!.carModel!}  ${viewModel.salesListModel!.payload![currentSaleIndex].carDetails!.carYear!}',
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
            const YMargin(15),
            Row(
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
                      text: viewModel.salesListModel!.payload![currentSaleIndex].carDetails!.gear,
                      textColor: XColors.black(),
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
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
                      text: viewModel.salesListModel!.payload![currentSaleIndex].carDetails!.seats.toString(),
                      textColor: XColors.black(),
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
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
                      text: viewModel.salesListModel!.payload![currentSaleIndex].carDetails!.mileage.toString(),
                      textColor: XColors.black(),
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ],
                ),
              ],
            ),
            const YMargin(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NormalText(
                  text: 'N ${amtFormatter(viewModel.salesListModel!.payload![currentSaleIndex].salesDetails!.amountForSale)}',
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


}

class CarListItem extends ViewModelWidget<SalesViewModel> {
  const CarListItem({super.key, this.currentSaleIndex});

  final int? currentSaleIndex;

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      decoration: BoxDecorators.containerDecoration(
          hasOutline: true,
          outlineWidth: 1,
          outlineColor: Colors.black.withOpacity(0.05)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 0.9,
              child: Image.network(
                viewModel.salesListModel!.payload![currentSaleIndex!].images![0],
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    color: Colors.black12.withOpacity(0.1),
                  );
                },
              ),
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
          const YMargin(5),
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
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
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
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
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
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
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
