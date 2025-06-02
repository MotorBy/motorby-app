import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/ui/home/info_details_action/info_details_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import 'package:mobile_auto_drive/ui/new_ui/map/directions_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HistoryScreen extends StatelessWidget {
  Widget _getHistoryTypeIcon() {
    switch (budgetHistoryType) {
      case 'Fueling':
        return const GetPngImage(
          allowSolid: true,
          allowPadding: true,
          image: "assets/images/budget_icons/fuel.png",
          height: 24,
          width: 24,
        );
      case 'Servicing':
        return const GetPngImage(
          allowSolid: true,
          allowPadding: true,
          image: "assets/images/budget_icons/service.png",
          height: 24,
          width: 24,
        );
      case 'Repairing':
        return const GetPngImage(
          allowSolid: true,
          allowPadding: true,
          image: "assets/images/budget_icons/repairs.png",
          height: 24,
          width: 24,
        );
      case 'Breakdown':
        return Icon(
          Icons.car_repair,
          color: XColors.primaryColor(),
          size: 24,
        );
      case 'Mileage':
        return Icon(
          Icons.speed,
          color: XColors.primaryColor(),
          size: 24,
        );
      default:
        return Icon(
          Icons.history,
          color: XColors.primaryColor(),
          size: 24,
        );
    }
  }

  String _getEntryCount(InfoDetailsViewModel model) {
    int count = 0;
    switch (budgetHistoryType) {
      case 'Fueling':
        count = model.fueling?.length ?? 0;
        model.updateBudgetTypeIndex(v: 0);
        break;
      case 'Servicing':
        count = model.servicing?.length ?? 0;
        model.updateBudgetTypeIndex(v: 1);
        break;
      case 'Repairing':
        count = model.repairing?.length ?? 0;
        model.updateBudgetTypeIndex(v: 2);
        break;
      case 'Breakdown':
        count = model.breakdowns?.length ?? 0;
        model.updateBudgetTypeIndex(v: 4);
        break;
      case 'Mileage':
        count = model.mileageData?.length ?? 0;
        model.updateBudgetTypeIndex(v: 3);
        break;
    }
    return '$count ${count == 1 ? 'Entry' : 'Entries'}';
  }

  const HistoryScreen({
    super.key,
    this.infoDetailsViewModel,
    this.budgetHistoryType
  });

  final InfoDetailsViewModel? infoDetailsViewModel;
  final String? budgetHistoryType;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InfoDetailsViewModel>.reactive(
        viewModelBuilder: () => infoDetailsViewModel ?? InfoDetailsViewModel(),
        onViewModelReady: (model) {
          model.initializeTotalCostingAndValue();
        },
        disposeViewModel: false,
        builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: 'Budget History',
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [

                  if(_getEntryCount.call(model) == '0') ... [

                    const EmptyView(),

                  ] else ... [

                    ///Top header section
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: XColors.highlightColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: XColors.primaryColor().withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NormalText(
                                    text: budgetHistoryType ?? '',
                                    textColor: XColors.primaryColor(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const YMargin(4),
                                  NormalText(
                                    text: 'History Overview',
                                    textColor: XColors.textColor().withOpacity(0.6),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              _getHistoryTypeIcon(),
                            ],
                          ),
                          const YMargin(20),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(budgetHistoryType != 'Mileage') ... [

                                      NormalText(
                                        text: 'Total Amount',
                                        textColor: XColors.textColor().withOpacity(0.6),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),

                                      const YMargin(8),
                                      NormalText(
                                        text: budgetHistoryType != 'Breakdown' && budgetHistoryType != 'Mileage' ?
                                        '₦${numberFormat(number: model.totalCostingAndValue![model.currentBudgetTypeIndex!].toDouble())}'
                                            : model.totalCostingAndValue![model.currentBudgetTypeIndex!].toString(),
                                        textColor: XColors.textColor(),
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                      ),

                                    ] else ... [

                                      NormalText(
                                        text: 'Current mileage',
                                        textColor: XColors.textColor().withOpacity(0.6),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),

                                      const YMargin(8),
                                      NormalText(
                                        text: '${model.totalCostingAndValue![model.currentBudgetTypeIndex!]}mph',
                                        textColor: XColors.textColor(),
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                      ),

                                    ],

                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: XColors.primaryColor().withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.history,
                                      color: XColors.primaryColor(),
                                      size: 16,
                                    ),
                                    const XMargin(6),
                                    NormalText(
                                      text: _getEntryCount(model),
                                      textColor: XColors.primaryColor(),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const YMargin(25),

                  ],

                  if(budgetHistoryType == "Fueling") ... [

                    ...List.generate(model.fueling!.length, (index) {
                      return HistoryListView(
                        body: 'Bought fuel for',
                        price: '₦${numberFormat(number: model.fueling![index].price!.toDouble())}',
                        date: model.fueling![index].date,
                        location: model.fueling![index].fuelStationName,
                        address: model.fueling![index].gasStationAddress,
                        latitude: model.fueling![index].gasStationLocation?.lat,
                        longitude: model.fueling![index].gasStationLocation?.lng,
                        shopName: model.fueling![index].fuelStationName,
                      );
                    }),

                  ]
                  else if (budgetHistoryType == "Servicing") ... [

                    ...List.generate(model.servicing!.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: HistoryListView(
                          body: model.servicing![index].condition,
                          price: '₦${numberFormat(number: model.servicing![index].price!.toDouble())}',
                          date: model.servicing![index].date ?? '',
                          location: model.servicing![index].shopName,
                          address: model.servicing![index].shopAddress,
                          latitude: model.servicing![index].shopLocation?.lat,
                          longitude: model.servicing![index].shopLocation?.lng,
                          shopName: model.servicing![index].shopName,
                        ),
                      );
                    }),

                  ]
                  else if (budgetHistoryType == "Repairing") ... [

                    ...List.generate(model.repairing!.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: HistoryListView(
                          body: model.repairing![index].condition,
                          price: '₦${numberFormat(number: model.repairing![index].price!.toDouble())}',
                          date: model.repairing![index].date ?? '',
                          location: model.repairing![index].shopName,
                          address: model.repairing![index].shopAddress,
                          latitude: model.repairing![index].shopLocation?.lat,
                          longitude: model.repairing![index].shopLocation?.lng,
                          shopName: model.repairing![index].shopName,
                        ),
                      );
                    }),

                  ]
                  else if (budgetHistoryType == "Breakdown") ... [

                    ...List.generate(model.breakdowns!.length, (index) {
                      return HistoryListView(
                        body: 'Had breakdown',
                        price: '',
                        date: model.breakdowns![index].date,
                        location: model.breakdowns![index].location,
                        address: model.breakdowns![index].address,
                        latitude: model.breakdowns![index].breakdownLocation?.lat,
                        longitude: model.breakdowns![index].breakdownLocation?.lng,
                      );
                    }),
                  ]
                  else if (budgetHistoryType == "Mileage") ... [

                    ...List.generate(model.mileageData!.length, (index) {
                      return HistoryListView(
                        body: 'Mileage update at fuel level: ${model.mileageData![index].currentFuelGauge ?? "N/A"} \nWith destination address',
                        price: '${model.mileageData![index].odometerReading}mph' ?? 'N/A',
                        date: model.mileageData![index].inputDate.toString(),
                        location: model.mileageData![index].destinationAddress,
                        address: model.mileageData![index].destinationAddress,
                        latitude: model.mileageData![index].destinationLocation?.lat,
                        longitude: model.mileageData![index].destinationLocation?.lng,
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

class HistoryListView extends StatelessWidget {
  const HistoryListView({
    super.key, 
    this.body, 
    this.price, 
    this.date,
    this.location,
    this.latitude,
    this.longitude,
    this.shopName,
    this.address,
  });

  final String? body;
  final String? price;
  final String? date;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? shopName;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      text: date != null ? formatDate(date!) : '',
                      textColor: XColors.textColor().withOpacity(0.6),
                      fontSize: 10,
                    ),
                    const YMargin(10),
                    NormalText(
                      text: body,
                      textColor: XColors.textColor(),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    if (location != null) ...[                      
                      const YMargin(5),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: XColors.highlightColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: XColors.primaryColor()),
                            const XMargin(8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (shopName != null)
                                        NormalText(
                                          text: shopName!,
                                          textColor: XColors.textColor(),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      if (address != null) const YMargin(4),
                                      NormalText(
                                        text: shopName != null ? address!.isEmpty ? '' : address!.replaceAll('${shopName!}, ', '') : address!,
                                        textColor: XColors.textColor(),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // if (latitude != null && longitude != null)
                            //   IconButton(
                            //     icon: Icon(Icons.directions, color: XColors.primaryColor()),
                            //     onPressed: () {
                            //
                            //       navigate(context, DirectionsScreen(
                            //         destination: LatLng(latitude!, longitude!),
                            //         destinationAddress: location!,destinationName: '',
                            //       ));
                            //
                            //     },
                            //     iconSize: 20,
                            //     padding: EdgeInsets.zero,
                            //     constraints: const BoxConstraints(),
                            //   ),
                        ],
                      ),
                      )],
                  ],
                ),
              ),
              const XMargin(8),
              NormalText(
                text: price,
                textColor: XColors.textColor(),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: Divider(thickness: 0.4, color: XColors.primaryColor2().withOpacity(0.3),),
          ),
        ],
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: NormalText(
      text: 'No entries made yet for this section',
      textColor: XColors.textColor(),
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),);
  }

}
