import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class AddCarsScreen extends StatefulWidget {
  AddCarsScreen({super.key});

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

  bool isBusinessOrForSale = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
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
                            text: 'Add Images (4)',
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
                ],
              ),
              const YMargin(5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        width: 110,
                          height: 110,
                          child: Image.asset('assets/images/car_placeholder.jpeg', fit: BoxFit.cover,)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                          width: 110,
                          height: 110,
                          child: Image.asset('assets/images/car_placeholder.jpeg', fit: BoxFit.cover,)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                          width: 110,
                          height: 110,
                          child: Image.asset('assets/images/car_placeholder.jpeg', fit: BoxFit.cover,)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                          width: 110,
                          height: 110,
                          child: Image.asset('assets/images/car_placeholder.jpeg', fit: BoxFit.cover,)
                      ),
                    ),
                  )
                ],),
              ),
              const YMargin(15),
              MkInputField2(
                controller: _carMakeController,
                label: "Make",
                suffixIcon: GestureDetector(
                  onTap: () {
                    listHelperPicker(
                      context: context,
                      height: 500,
                      title: 'Car make',
                      listString: [
                        "Audi",
                        "Chevrolet",
                        "Cadillac",
                        "Acura",
                        "BMW",
                        "Chrysler",
                        "Ford",
                        "INFINITI",
                        "GMC",
                        "Honda",
                        "Hyundai",
                        "Jeep",
                        "Genesis",
                        "Dodge",
                        "Jaguar",
                        "Kia",
                        "Land Rover",
                        "Lexus",
                        "Mercedes-Be",
                        "Mitsubishi",
                        "Lincoln",
                        "MAZDA",
                        "Nissan",
                        "Porsche",
                        "Subaru",
                        "Toyota",
                        "Volkswagen",
                        "Volvo",
                        "Maserati",
                        "Tesla",
                        "Aston Marti",
                        "Bentley",
                        "Ferrari",
                        "Lamborghini",
                        "Lotus",
                        "McLaren",
                        "Rolls-Royce",
                        "smart",
                        "Scion",
                        "SRT",
                        "Suzuki",],
                      selected: (s) {
                        _carMakeController.text = s!;
                        setState(() {});
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
              ),
              const YMargin(15),
              MkInputField2(
                controller: _carYearController,
                label: "Year",
                isEnabled: true,
                suffixIcon: GestureDetector(
                  onTap: (){
                    listHelperPicker(
                      context: context,
                      title: 'Car Year',
                      listString: [
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
                        setState(() {});
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
                isEnabled: true,
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
                        setState(() {});
                      },
                    );
                  },
                    child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21,),
                ),
              ),
              if(!isBusinessOrForSale) ... [
                const YMargin(15),
                MkInputField2(
                  controller: _carAmtBoughtController,
                  label: "Amount bought",
                  isEnabled: true,
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

                            setState(() {});
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
                            text: 'Set',
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
                            setState(() {});
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
                            text: '0',
                            textColor: XColors.black(),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){

                      },
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            child:
                            Image.asset('assets/images/icons/odometer.png'),
                          ),
                          const XMargin(5),
                          NormalText(
                            text: '0',
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                            setState(() {});
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
                            text: 'Set',
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
                          title: 'Air condition',
                          listString: [
                            "Ok",],
                          selected: (s) {
                            setState(() {});
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
                            text: 'set',
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
                            "6 - 10",
                            "11 - 15",
                            "15 - 20",
                            "21 - above"],
                          selected: (s) {
                            setState(() {});
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
                            text: 'Set',
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
              ),
              if(isBusinessOrForSale) ... [
                const YMargin(15),
                MkInputField2(
                  controller: _vinController,
                  label: "VIN number",
                  isEnabled: true,
                  keyboard: TextInputType.number,
                ),
                const YMargin(15),
                MkInputField2(
                  controller: _mileageController,
                  label: "Selling price",
                  isEnabled: true,
                  keyboard: TextInputType.number,
                ),
                const YMargin(15),
                Row(
                  children: [
                    Expanded(
                      child: MkInputField2(
                        controller: _mileageController,
                        label: "Color",
                        isEnabled: true,
                        keyboard: TextInputType.number,
                      ),
                    ),
                    const XMargin(10),
                    Expanded(
                      child: MkInputField2(
                        controller: _mileageController,
                        label: "Unit(s)",
                        isEnabled: true,
                        keyboard: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
              const YMargin(35),
              XButton(
                onPressed: () {

                },
                text: isBusinessOrForSale ? "Set for Sale" : "Add Vehicle",
                height: 56,
                textColor: Colors.white,
                buttonColor: XColors.primaryColor(),
                progressColor: Colors.white,
                radius: 26,
                width: SizeConfig().sw(400) as double?,
              ),
              const YMargin(15),
          ],),
        ),
      ),
    );
  }
}