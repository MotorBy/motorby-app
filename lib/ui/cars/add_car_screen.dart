import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class AddCarsScreen extends StatefulWidget {
  const AddCarsScreen({super.key, this.action = 'add'});

  final String? action;

  @override
  State<AddCarsScreen> createState() => _AddCarsScreenState();
}

class _AddCarsScreenState extends State<AddCarsScreen> {

  final TextEditingController _carMakeController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _carYearController = TextEditingController();
  final TextEditingController _caTypeController = TextEditingController();
  final TextEditingController _carAmtBoughtController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddCarViewModel>.reactive(
        viewModelBuilder: () => AddCarViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) => model.init(initAction: widget.action, dataSetup: (){}),
        builder: (context, model, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const YMargin(45),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          model.pickImages();
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
                                  text: 'Add Images (${4 - model.addImagesList.length})',
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
                                      child: Container(
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
                    const YMargin(15),
                  MkInputField2(
                    controller: _carMakeController,
                    isEnabled: false,
                    label: "Make",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        listHelperPicker(
                          context: context,
                          height: 500,
                          title: 'Car make',
                          listString: carMakeDataList!,
                          selected: (s) {
                            _carMakeController.text = s!;
                            model.updateSetCarData(data: s, dataType: 'make');
                          },
                        );
                      },
                        child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21,),
                    ),
                  ),
                  const YMargin(15),
                  MkInputField2(
                    controller: _carModelController,
                    label: "Model",
                    isEnabled: true,
                    onChanged: (s){
                      model.updateSetCarData(data: s, dataType: 'model');
                    },
                  ),
                  const YMargin(15),
                  MkInputField2(
                    controller: _carYearController,
                    label: "Year",
                    isEnabled: false,
                    suffixIcon: GestureDetector(
                      onTap: (){
                        listHelperPicker(
                          context: context,
                          title: 'Car Year',
                          listString: [
                            "2025",
                            "2024",
                            "2023",
                            "2022",
                            "2021",
                            "2020",
                            "2019",
                            "2018",
                            "2017",
                            "2016",
                            "2015",
                            "2014",
                            "2013",
                            "2012",
                            "2011",
                            "2010",
                            "2009",
                            "2008",
                            "2007",
                            "2006",
                            "2005",
                            "2004",
                            "2003",
                            "2002",
                            "2001",
                            "2000",
                            "1999",
                            "1998"],
                          selected: (s) {
                            _carYearController.text = s!;
                            model.updateSetCarData(data: s, dataType: 'year');
                          },
                        );
                      },
                        child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21,),
                    ),
                  ),
                  const YMargin(15),
                  MkInputField2(
                    controller: _caTypeController,
                    label: "Grade type",
                    isEnabled: false,
                    suffixIcon: GestureDetector(
                      onTap: (){
                        listHelperPicker(
                          height: 220,
                          context: context,
                          title: 'Grade Type',
                          listString: [
                            "Nigerian Used",
                            "Brand New",
                            "UK Used",],
                          selected: (s) {
                            _caTypeController.text = s!;
                            model.updateSetCarData(data: s, dataType: 'grade');
                          },
                        );
                      },
                        child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21,),
                    ),
                  ),
                  if(!model.isBusinessOrForSale) ... [
                    const YMargin(15),
                    MkInputField2(
                      controller: _carAmtBoughtController,
                      label: "Amount bought",
                      keyboard: TextInputType.number,
                      isEnabled: true,
                      onChanged: (s){
                        model.updateSetCarData(data: s, dataType: 'amount');
                      },
                    ),
                  ],
                  const YMargin(35),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            listHelperPicker(
                              height: 220,
                              context: context,
                              title: 'Gear type',
                              listString: [
                                "Automatic",
                                "Manual",],
                              selected: (s) {
                                model.updateSetCarData(data: s, dataType: 'gear');
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child:
                                Image.asset('assets/images/icons/gearbox.png'),
                              ),
                              const XMargin(5),
                              NormalText(
                                text: model.gear ?? 'Set',
                                textColor: XColors.black(),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            listHelperPicker(
                              height: 220,
                              context: context,
                              title: 'Seats',
                              listString: [
                                "1",
                                "2",
                                "3",
                                "4",
                                "5"],
                              selected: (s) {
                                model.updateSetCarData(data: s, dataType: 'seats');
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child: Image.asset('assets/images/icons/seat.png'),
                              ),
                              const XMargin(5),
                              NormalText(
                                text: model.seats ?? '0',
                                textColor: XColors.black(),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            listHelperPicker(
                              height: 220,
                              context: context,
                              title: 'Air bags',
                              listString: [
                                "1",
                                "2",
                              ],
                              selected: (s) {
                                model.updateSetCarData(data: s, dataType: 'air_bag');
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child:
                                Image.asset('assets/images/icons/airbag.png'),
                              ),
                              const XMargin(5),
                              NormalText(
                                text: model.airBag ?? 'Set',
                                textColor: XColors.black(),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const YMargin(35),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                            listHelperPicker(
                              height: 220,
                              context: context,
                              title: 'Air condition',
                              listString: [
                                "Ok", 'None'],
                              selected: (s) {
                                model.updateSetCarData(data: s, dataType: 'air_conditioner');
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child: Image.asset('assets/images/icons/aircondition.png'),
                              ),
                              const XMargin(5),
                              NormalText(
                                text: model.airConditioner ?? 'set',
                                textColor: XColors.black(),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            listHelperPicker(
                              height: 220,
                              context: context,
                              title: 'Working Speakers',
                              listString: [
                                "5",
                                "6",
                                "11",
                                "15",
                                "21"],
                              selected: (s) {
                                model.updateSetCarData(data: s, dataType: 'speakers');
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child:
                                Image.asset('assets/images/icons/speaker.png'),
                              ),
                              const XMargin(5),
                              NormalText(
                                text: model.speakers ?? 'Set',
                                textColor: XColors.black(),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const YMargin(15),
                  MkInputField2(
                    controller: _mileageController,
                    label: "Mileage",
                    isEnabled: true,
                    keyboard: TextInputType.number,
                    onChanged: (s){
                      model.updateSetCarData(data: s, dataType: 'mileage');
                    },
                  ),
                  if(model.isBusinessOrForSale) ... [
                    const YMargin(15),
                    MkInputField2(
                      controller: _vinController,
                      label: "VIN number",
                      isEnabled: true,
                      onChanged: (s){
                        model.updateSetCarData(data: s, dataType: 'vin_number');
                      },
                    ),
                    const YMargin(15),
                    MkInputField2(
                      //controller: ,
                      label: "Selling price",
                      isEnabled: true,
                      keyboard: TextInputType.number,
                      onChanged: (s){
                        model.updateSetCarData(data: s, dataType: 'selling price');
                      },
                    ),
                    const YMargin(15),
                    Row(
                      children: [
                        Expanded(
                          child: MkInputField2(
                            //controller: _mileageController,
                            label: "Color",
                            isEnabled: true,
                            keyboard: TextInputType.text,
                            onChanged: (s){
                              model.updateSetCarData(data: s, dataType: 'color');
                            },
                          ),
                        ),
                        const XMargin(10),
                        Expanded(
                          child: MkInputField2(
                            //controller: _mileageController,
                            label: "Unit(s)",
                            isEnabled: true,
                            keyboard: TextInputType.number,
                            onChanged: (s){
                              model.updateSetCarData(data: s, dataType: 'units');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  const YMargin(35),
                  XButton(
                    onPressed: () {
                      //model.uploadFilesToCloud();
                      model.uploadCar(
                        onCallBack: (){
                          popView(context);
                        },
                        onErrorCallBack: (){

                        }
                      );
                    },
                    text: model.isBusinessOrForSale ? "Set for Sale" : "Add Vehicle",
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
            ),
          ),
        );
      }
    );
  }
}