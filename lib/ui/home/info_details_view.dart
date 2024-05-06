import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/home/history_screen.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/snackbar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class InfoDetailsView extends StatelessWidget {

  const InfoDetailsView({
    super.key,
    this.infoType = '',
    this.homeViewModel,
    this.currentIndex,
    this.onHistoryNav
  });

  final String? infoType;
  final int? currentIndex;
  final Function? onHistoryNav;

  final HomeViewModel? homeViewModel;

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
              if(infoType == '' || infoType == 'fueling') ... [
                Column(
                  children: [
                    const YMargin(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            model.updateBudgetTypeIndex(v: 0);
                            navigate(context, HistoryScreen(
                              homeViewModel: homeViewModel!,
                              noEmptyData: homeViewModel!.fueling!.isNotEmpty,
                            ));
                          },
                          child: NormalText(
                            text: 'View History',
                            textColor: XColors.textColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const XMargin(45),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close_rounded, size: 31,),
                        ),
                      ],
                    ),
                    const YMargin(20),
                    Row(
                      children: [
                        NormalText(
                          text: infoType!.toUpperCase(),
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w700,
                          fontSize: 23,
                        ),
                      ],
                    ),
                    const YMargin(35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NormalText(
                          text:'Fuel bought on: ${model.date}',
                          textColor: XColors.textColor(),
                          fontSize: 13,
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: model.amountInputController,
                          label: "Amount",
                          keyboard: TextInputType.number,
                          isEnabled: true,
                          onChanged: (s){
                            model.updateBudgetData(value: s, type: 'amount');
                          },
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: model.dateInputController,
                          label: "Date",
                          isEnabled: false,
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              DateTime? startPickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year - 10),
                                  lastDate: DateTime(DateTime.now().year + 10));
                              String formattedDate =
                                  '${startPickedDate!.day}-${startPickedDate.month}-${startPickedDate.year}';
                              model.date = formattedDate;
                              model.updateBudgetData(value: model.date, type: 'date');
                            },
                            child: const Icon(Icons.calendar_month_rounded, size: 21,),
                          ),
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: model.priceInputController,
                          label: "Price/liter",
                          keyboard: TextInputType.number,
                          isEnabled: true,
                          onChanged: (s){
                            model.updateBudgetData(value: s, type: 'price_per_liter');
                          },
                        ),
                      ],
                    ),
                    const YMargin(35),
                    XButton(
                      onPressed: !model.isBusy ? () {

                        if(model.priceInputController.text.isNotEmpty &&
                            model.amountInputController.text.isNotEmpty &&
                            model.dateInputController.text.isNotEmpty) {

                          model.updateToBudget(
                              type: infoType,
                              onCallBack: () {
                                popView(context);
                                showSnackBar(
                                    context: context,
                                    message: 'Successfully updated into your budget'
                                );
                              }
                          );

                        } else {


                        }

                      } : (){},
                      text: "Add",
                      height: 56,
                      textColor: Colors.white,
                      isLoading: model.isBusy,
                      buttonColor: XColors.primaryColor(),
                      progressColor: Colors.white,
                      radius: 26,
                      width: SizeConfig().sw(400) as double?,
                    ),
                    const YMargin(15),
                  ],),
              ] else if(infoType == 'servicing' || infoType == 'repairing') ... [
                Column(
                  children: [
                    const YMargin(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            if(infoType == 'servicing') {
                              model.updateBudgetTypeIndex(v: 1);
                            } else if(infoType == 'repairing') {
                              model.updateBudgetTypeIndex(v: 2);
                            }
                            navigate(context, HistoryScreen(
                              homeViewModel: homeViewModel!,
                              noEmptyData: infoType == 'servicing' ? homeViewModel!.servicing!.isNotEmpty : homeViewModel!.repairing!.isNotEmpty,
                            ));
                          },
                          child: NormalText(
                            text: 'View History',
                            textColor: XColors.textColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const XMargin(45),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close_rounded, size: 31,),
                        ),
                      ],
                    ),
                    const YMargin(20),
                    Row(
                      children: [
                        NormalText(
                          text: infoType!.toUpperCase(),
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w700,
                          fontSize: 23,
                        ),
                      ],
                    ),
                    const YMargin(35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const YMargin(15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NormalText(
                                  text:'Date: ${model.date}',
                                  textColor: XColors.textColor(),
                                  fontSize: 15,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const YMargin(15),
                        MkInputField2(
                          label: "problem",
                          controller: model.problemInputController,
                          isEnabled: true,
                          keyboard: TextInputType.number,
                          onChanged: (s){
                            model.updateBudgetData(value: s, type: 'problem');
                          },
                        ),
                        const YMargin(15),
                        MkInputField2(
                          label: "Amount",
                          controller: model.amountInputController,
                          onChanged: (s){
                            model.updateBudgetData(value: s, type: 'amount');
                          },
                          isEnabled: true,
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: model.addressInputController,
                          label: "Place fixed",
                          isEnabled: false,
                          onChanged: (s) {
                            model.updateBudgetData(value: s, type: 'location');
                          },
                          suffixIcon: GestureDetector(
                            child: Container(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.location_on_rounded, size: 21, color: XColors.textColor(),),
                                  const XMargin(20),
                                  GestureDetector(
                                    onTap: () async {
                                      DateTime? startPickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(DateTime.now().year - 10),
                                          lastDate: DateTime(DateTime.now().year + 10));
                                      String formattedDate =
                                          '${startPickedDate!.day}-${startPickedDate.month}-${startPickedDate.year}';
                                      model.date = formattedDate;
                                      model.updateBudgetData(value: model.date, type: 'date');
                                    },
                                    child: Icon(Icons.calendar_month_rounded, size: 21, color: XColors.textColor(),),
                                  ),
                                  const XMargin(10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const YMargin(35),
                    XButton(
                      onPressed: !model.isBusy ? () {

                        if(model.problemInputController.text.isNotEmpty &&
                            model.amountInputController.text.isNotEmpty &&
                            model.dateInputController.text.isNotEmpty) {

                          model.updateToBudget(
                              type: infoType,
                              onCallBack: (){
                                popView(context);
                                showSnackBar(
                                    context: context,
                                    message: 'Successfully updated into your budget'
                                );
                              }
                          );

                        } else {

                        }

                      } : (){},
                      text: "Add",
                      height: 56,
                      textColor: Colors.white,
                      buttonColor: XColors.primaryColor(),
                      progressColor: Colors.white,
                      isLoading: model.isBusy,
                      radius: 26,
                      width: SizeConfig().sw(400) as double?,
                    ),
                    const YMargin(15),
                  ],),
              ] else if(infoType == 'mileage') ... [
                Column(
                  children: [
                    const YMargin(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close_rounded, size: 31,),
                        ),
                      ],
                    ),
                    const YMargin(15),
                    Row(
                      children: [
                        NormalText(
                          text: infoType!.toUpperCase(),
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w700,
                          fontSize: 23,
                        ),
                      ],
                    ),
                    const YMargin(5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NormalText(
                          text:'Your total journey is ',
                          textColor: XColors.textColor(),
                          fontSize: 15,
                        ),
                        NormalText(
                          text: model.totalCostingAndValue![currentIndex!].toString(),
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 21,
                        ),
                        NormalText(
                          text:' miles.',
                          textColor: XColors.textColor(),
                          fontSize: 15,
                        ),
                      ],
                    ),
                    const YMargin(35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NormalText(
                          text:'Your last mile update: Monday',
                          textColor: XColors.textColor(),
                          fontSize: 13,
                        ),
                        const YMargin(15),
                        MkInputField2(
                          label: "Update miles",
                          keyboard: TextInputType.number,
                          controller: model.milesInputController,
                          isEnabled: true,
                          onChanged: (s){
                            model.updateBudgetData(value: s, type: 'miles');
                          },
                        ),
                      ],
                    ),
                    const YMargin(35),
                    XButton(
                      onPressed: !model.isBusy ? () {
                        model.updateToBudget(
                          type: infoType,
                          onCallBack: (){

                            if(model.milesInputController.text.isNotEmpty) {

                              popView(context);
                              showSnackBar(
                                  context: context,
                                  message: 'Successfully updated into your budget'
                              );

                            } else {

                            }

                          }
                        );
                      } : (){},
                      text: "Update",
                      height: 56,
                      textColor: Colors.white,
                      buttonColor: XColors.primaryColor(),
                      progressColor: Colors.white,
                      isLoading: model.isBusy,
                      radius: 26,
                      width: SizeConfig().sw(400) as double?,
                    ),
                    const YMargin(15),
                  ],),
              ] else if(infoType == 'breakdown') ... [
                Column(
                  children: [
                    const YMargin(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            model.updateBudgetTypeIndex(v: 4);
                            navigate(context, HistoryScreen(
                              homeViewModel: homeViewModel!,
                              noEmptyData: homeViewModel!.breakdowns!.isNotEmpty,
                            ));
                          },
                          child: NormalText(
                            text: 'View History',
                            textColor: XColors.textColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const XMargin(45),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close_rounded, size: 31,),
                        ),
                      ],
                    ),
                    const YMargin(20),
                    Row(
                      children: [
                        NormalText(
                          text: infoType!.toUpperCase(),
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w700,
                          fontSize: 23,
                        ),
                      ],
                    ),
                    const YMargin(5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NormalText(
                          text:'You have total of ',
                          textColor: XColors.textColor(),
                          fontSize: 15,
                        ),
                        NormalText(
                          text:model.totalCostingAndValue![currentIndex!].toString(),
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        NormalText(
                          text:' breakdowns',
                          textColor: XColors.textColor(),
                          fontSize: 15,
                        ),
                      ],
                    ),
                    const YMargin(35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NormalText(
                                  text:'Breakdown occured on : ${model.date}',
                                  textColor: XColors.textColor(),
                                  fontSize: 15,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const YMargin(15),
                        MkInputField2(
                          label: "Cause",
                          controller: model.problemInputController,
                          isEnabled: true,
                          onChanged: (s){
                            model.updateBudgetData(value: s, type: 'cause');
                          },
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: model.addressInputController,
                          label: "Place fixed",
                          isEnabled: true,
                          onChanged: (s) {
                            model.updateBudgetData(value: s, type: 'break_down');
                          },
                          suffixIcon: GestureDetector(
                            child: Container(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.location_on_rounded, size: 21, color: XColors.textColor(),),
                                  const XMargin(20),
                                  GestureDetector(
                                    onTap: () async {
                                      DateTime? startPickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(DateTime.now().year - 10),
                                          lastDate: DateTime(DateTime.now().year + 10));
                                      String formattedDate =
                                          '${startPickedDate!.day}-${startPickedDate.month}-${startPickedDate.year}';
                                      model.date = formattedDate;
                                      model.updateBudgetData(value: model.date, type: 'date');
                                    },
                                      child: Icon(Icons.calendar_month_rounded, size: 21, color: XColors.textColor(),),
                                  ),
                                  const XMargin(10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const YMargin(35),
                    XButton(
                      onPressed: !model.isBusy ? () {

                        if(model.problemInputController.text.isNotEmpty &&
                            model.dateInputController.text.isNotEmpty) {

                          model.updateToBudget(
                              type: infoType,
                              onCallBack: (){
                                popView(context);
                                showSnackBar(
                                    context: context,
                                    message: 'Successfully updated into your budget'
                                );
                              }
                          );

                        } else {

                        }

                      } : (){},
                      text: "Add",
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
              ]
            ],
          ),
        );
      }
    );
  }

}