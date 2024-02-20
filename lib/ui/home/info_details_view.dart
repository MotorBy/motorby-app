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
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class InfoDetailsView extends StatelessWidget {

  InfoDetailsView({
    super.key,
    this.infoType = '',
    this.homeViewModel
  });

  final TextEditingController _amountInputController = TextEditingController();
  final TextEditingController _dateInputController = TextEditingController();
  final TextEditingController _priceInputController = TextEditingController();
  final TextEditingController _addressInputController = TextEditingController();

  final String? infoType;

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
                    const YMargin(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            navigate(context, const HistoryScreen());
                          },
                          child: NormalText(
                            text: 'View History',
                            textColor: XColors.textColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
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
                          text:'You have spent total of ',
                          textColor: XColors.textColor(),
                          fontSize: 15,
                        ),
                        NormalText(
                          text:'N100,000 ',
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ],
                    ),
                    const YMargin(35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NormalText(
                          text:'Fuel bought on ${model.date}: ',
                          textColor: XColors.textColor(),
                          fontSize: 13,
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: _amountInputController,
                          label: "Amount",
                          isEnabled: true,
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: _dateInputController,
                          label: "Date",
                          isEnabled: true,
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
                            },
                            child: const Icon(Icons.calendar_month_rounded, size: 21,),
                          ),
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: _priceInputController,
                          label: "Price/liter",
                          keyboard: TextInputType.number,
                          isEnabled: true,
                        ),
                      ],
                    ),
                    const YMargin(35),
                    XButton(
                      onPressed: () {

                      },
                      text: "Add",
                      height: 56,
                      textColor: Colors.white,
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
                    const YMargin(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            navigate(context, const HistoryScreen());
                          },
                          child: NormalText(
                            text: 'View History',
                            textColor: XColors.textColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
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
                    const YMargin(5),
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
                          text:'You have spent total of ',
                          textColor: XColors.textColor(),
                          fontSize: 15,
                        ),
                        NormalText(
                          text:'N100,000 ',
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
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
                                  text:'Condition',
                                  textColor: XColors.textColor(),
                                  fontSize: 15,
                                ),
                                const YMargin(4),
                                NormalText(
                                  text:'Date',
                                  textColor: XColors.textColor(),
                                  fontSize: 15,
                                ),
                              ],
                            ),
                            NormalText(
                              text:'N 0',
                              textColor: XColors.textColor(),
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ],
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: _amountInputController,
                          label: "Condition",
                          isEnabled: true,
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: _amountInputController,
                          label: "Amount",
                          isEnabled: true,
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: _addressInputController,
                          label: "Location",
                          isEnabled: true,
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
                      onPressed: () {

                      },
                      text: "Add",
                      height: 56,
                      textColor: Colors.white,
                      buttonColor: XColors.primaryColor(),
                      progressColor: Colors.white,
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
                          text:'173,000',
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
                          controller: _amountInputController,
                          label: "Update miles",
                          isEnabled: true,
                        ),
                      ],
                    ),
                    const YMargin(35),
                    XButton(
                      onPressed: () {

                      },
                      text: "Update",
                      height: 56,
                      textColor: Colors.white,
                      buttonColor: XColors.primaryColor(),
                      progressColor: Colors.white,
                      radius: 26,
                      width: SizeConfig().sw(400) as double?,
                    ),
                    const YMargin(15),
                  ],),
              ] else if(infoType == 'breakdown') ... [
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
                          text:'You have total of',
                          textColor: XColors.textColor(),
                          fontSize: 15,
                        ),
                        NormalText(
                          text:' 2 ',
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        NormalText(
                          text:'breakdowns',
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
                          text:'Current breakdown on ${model.date}: ',
                          textColor: XColors.textColor(),
                          fontSize: 13,
                        ),
                        const YMargin(15),
                        MkInputField2(
                          controller: _amountInputController,
                          label: "Location",
                          isEnabled: true,
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
                      onPressed: () {

                      },
                      text: "Add",
                      height: 56,
                      textColor: Colors.white,
                      buttonColor: XColors.primaryColor(),
                      progressColor: Colors.white,
                      radius: 26,
                      width: SizeConfig().sw(400) as double?,
                    ),
                    const YMargin(15),
                  ],),
              ]

            ],
          ),
        );
      }
    );
  }

}