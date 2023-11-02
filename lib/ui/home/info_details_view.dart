import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/home/history_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class InfoDetailsView extends StatefulWidget {
  InfoDetailsView({super.key, this.infoType});

  String? infoType = '';

  @override
  State<InfoDetailsView> createState() => _InfoDetailsViewState();
}

class _InfoDetailsViewState extends State<InfoDetailsView> {
  final TextEditingController _amountInputController = TextEditingController();

  final TextEditingController _dateInputController = TextEditingController();

  var dataView = {

    "fueling": {
      "total_amount": "200,000",
      "last_amount": "10,000",
      "last_update": "16-09-2023"
    },
    "servicing": {
      "total_amount": "200,000",
      "last_amount": "10,000",
      "last_update": "16-09-2023"
    },
    "repairing": {
      "total_amount": "200,000",
      "last_amount": "10,000",
      "last_update": "16-09-2023"
    },
    "breakdowns": {
      "total": "2",
      "last_update": "16-09-2023"
    },
    "hours": {
      "total": "20 hrs",
      "last_update": "16-09-2023"
    },
    "distance": {
      "total": "120 km",
      "last_update": "16-09-2023"
    }

  };

  String? date = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [

          if(widget.infoType == '' || widget.infoType == 'fueling') ... [
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
                      text: widget.infoType!.toUpperCase(),
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
                      text:'Fuel bought on $date: ',
                      textColor: XColors.textColor(),
                      fontSize: 13,
                    ),
                    const YMargin(15),
                    MkInputField2(
                      controller: _amountInputController,
                      label: "Amount",
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
                          setState(() {
                            date = formattedDate;
                          });
                        },
                        child: const Icon(Icons.calendar_month_rounded, size: 21,),
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
          ] else if(widget.infoType == 'servicing') ... [
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
                      text: widget.infoType!.toUpperCase(),
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
                      text:'last servicing on $date: Tuesday',
                      textColor: XColors.textColor(),
                      fontSize: 13,
                    ),
                    const YMargin(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NormalText(
                          text:'Engine servicing',
                          textColor: XColors.textColor(),
                          fontSize: 15,
                        ),
                        NormalText(
                          text:'N 5,000',
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ],
                    ),
                  ],
                ),
                const YMargin(35),
                XButton(
                  onPressed: () {
                    navigate(context, const HistoryScreen());
                  },
                  text: "View History",
                  height: 56,
                  textColor: Colors.white,
                  buttonColor: XColors.primaryColor(),
                  progressColor: Colors.white,
                  radius: 26,
                  width: SizeConfig().sw(400) as double?,
                ),
                const YMargin(15),
              ],),
          ] else if(widget.infoType == 'repairing') ... [
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
                      text: widget.infoType!.toUpperCase(),
                      textColor: XColors.textColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: 23,
                    ),
                  ],
                ),
                const YMargin(5),
                Row(
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
                      text:'last repair on $date: Tuesday',
                      textColor: XColors.textColor(),
                      fontSize: 13,
                    ),
                    const YMargin(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NormalText(
                          text:'Oil pump repair',
                          textColor: XColors.textColor(),
                          fontSize: 15,
                        ),
                        NormalText(
                          text:'N 10,000',
                          textColor: XColors.textColor(),
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ],
                    ),
                  ],
                ),
                const YMargin(35),
                XButton(
                  onPressed: () {

                  },
                  text: "View History",
                  height: 56,
                  textColor: Colors.white,
                  buttonColor: XColors.primaryColor(),
                  progressColor: Colors.white,
                  radius: 26,
                  width: SizeConfig().sw(400) as double?,
                ),
                const YMargin(15),
              ],),
          ] else if(widget.infoType == 'mileage') ... [
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
                      text: widget.infoType!.toUpperCase(),
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
          ] else if(widget.infoType == 'breakdown') ... [
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
                      text: widget.infoType!.toUpperCase(),
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
                      text:'Current breakdown on $date: ',
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
                                  setState(() {
                                    date = formattedDate;
                                  });
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
}