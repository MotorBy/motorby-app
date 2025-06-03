import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class AddCarsScreen extends StatefulWidget {
  const AddCarsScreen({super.key, this.action = 'add', this.currentCar});

  final String? action;
  final CarId? currentCar;

  @override
  State<AddCarsScreen> createState() => _AddCarsScreenState();
}

class _AddCarsScreenState extends State<AddCarsScreen> {

  Widget _buildFeatureItem({
    required BuildContext context,
    required String icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Container(
              height: 24,
              width: 24,
              child: Image.asset(icon),
            ),
            const YMargin(8),
            NormalText(
              text: label,
              fontSize: 12,
              textColor: Colors.grey[600]!,
            ),
            const YMargin(4),
            NormalText(
              text: value,
              textColor: XColors.black(),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _carMakeController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _carYearController = TextEditingController();
  final TextEditingController _caTypeController = TextEditingController();
  final TextEditingController _carAmtBoughtController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _chassisNumberController = TextEditingController();
  final TextEditingController _engineNumberController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();
  
  bool _showAdvancedFields = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.action == 'edit' && widget.currentCar != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _prefillCarData(widget.currentCar!);
      });
    }
  }

  void _prefillCarData(CarId car) {
    _carMakeController.text = car.carMake ?? '';
    _carModelController.text = car.carModel ?? '';
    _carYearController.text = car.carYear?.toString() ?? '';
    _caTypeController.text = car.type ?? '';
    _carAmtBoughtController.text = car.amountBought?.toString() ?? '';
    _mileageController.text = car.details?.mileage?.toString() ?? '';
    _vinController.text = car.vinNumber ?? '';
    _chassisNumberController.text = car.chassisNumber ?? '';
    _engineNumberController.text = car.engineNumber ?? '';
    _registrationNumberController.text = car.registrationNumber ?? '';
    
    // if (car.chassisNumber != null || car.engineNumber != null || car.registrationNumber != null) {
    //
    // }

    setState(() {
      _showAdvancedFields = true;
    });

  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddCarViewModel>.reactive(
        viewModelBuilder: () => AddCarViewModel(),
        disposeViewModel: false,
        onViewModelReady:(model) => model.init(
          initAction: widget.action,
          dataSetup: () {
            if (widget.action == 'edit' && widget.currentCar != null) {
              model.updateSetCarData(data: widget.currentCar!.carMake ?? '', dataType: 'make');
              model.updateSetCarData(data: widget.currentCar!.carModel ?? '', dataType: 'model');
              model.updateSetCarData(data: widget.currentCar!.carYear?.toString() ?? '', dataType: 'year');
              model.updateSetCarData(data: widget.currentCar!.type ?? '', dataType: 'grade');
              model.updateSetCarData(data: widget.currentCar!.amountBought?.toString() ?? '', dataType: 'amount');
              model.updateSetCarData(data: widget.currentCar!.details?.mileage?.toString() ?? '', dataType: 'mileage');
              model.updateSetCarData(data: widget.currentCar!.vinNumber ?? '', dataType: 'vin_number');
              model.updateSetCarData(data: widget.currentCar!.chassisNumber ?? '', dataType: 'chassis_number');
              model.updateSetCarData(data: widget.currentCar!.engineNumber ?? '', dataType: 'engine_number');
              model.updateSetCarData(data: widget.currentCar!.registrationNumber ?? '', dataType: 'registration_number');
              model.updateSetCarData(data: widget.currentCar!.details?.gear ?? '', dataType: 'gear');
              model.updateSetCarData(data: widget.currentCar!.details?.seats?.toString() ?? '', dataType: 'seats');
              model.updateSetCarData(data: widget.currentCar!.details?.airBag?.toString() ?? '', dataType: 'air_bag');
              model.updateSetCarData(data: widget.currentCar!.details?.airConditioner ?? '', dataType: 'air_conditioner');
              model.updateSetCarData(data: widget.currentCar!.details?.speakers?.toString() ?? '', dataType: 'speakers');
            }
          }
        ),
        builder: (context, model, child) {
        return Scaffold(
          backgroundColor: XColors.background(),
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: widget.action == 'edit' ? 'Edit Car' : 'New Car',
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildImageUploader(model),
                    const YMargin(15),
                    MainInputField(
                      controller: _carMakeController,
                      isEnabled: false,
                      validator: (s) {
                        return AnyInputValidator.emptyValidate(s, inputName: 'car make');
                      },
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
                    MainInputField(
                      controller: _carModelController,
                      label: "Model",
                      validator: (s) {
                        return AnyInputValidator.emptyValidate(s, inputName: 'car model');
                      },
                      isEnabled: true,
                      onChanged: (s){
                        model.updateSetCarData(data: s, dataType: 'model');
                      },
                    ),
                    const YMargin(15),
                    MainInputField(
                      controller: _carYearController,
                      label: "Year",
                      isEnabled: false,
                      validator: (s) {
                        return AnyInputValidator.emptyValidate(s, inputName: 'car year');
                      },
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
                    MainInputField(
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
                              "Foreign Used",],
                            selected: (s) {
                              _caTypeController.text = s!;
                              model.updateSetCarData(data: s, dataType: 'grade');
                            },
                          );
                        },
                        child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21,),
                      ),
                    ),
                    const YMargin(15),
                    MainInputField(
                      controller: _carAmtBoughtController,
                      label: "Car cost (Amount bought)",
                      keyboard: TextInputType.number,
                      validator: (s) {
                        return AnyInputValidator.emptyValidate(s, inputName: 'amount');
                      },
                      isEnabled: true,
                      onChanged: (s){
                        model.updateSetCarData(data: s, dataType: 'amount');
                      },
                    ),
                    const YMargin(15),
                    MainInputField(
                      label: "Color",
                      isEnabled: true,
                      keyboard: TextInputType.text,
                      onChanged: (s){
                        model.updateSetCarData(data: s, dataType: 'color');
                      },
                    ),
                    ///cars details section
                    const YMargin(25),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const NormalText(
                              text: 'Car Features',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textColor: Colors.black87,
                            ),
                            const YMargin(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildFeatureItem(
                                  context: context,
                                  icon: 'assets/images/icons/gearbox.png',
                                  label: 'Transmission',
                                  value: model.gear ?? 'Select type',
                                  onTap: () {
                                    listHelperPicker(
                                      height: 220,
                                      context: context,
                                      title: 'Transmission Type',
                                      listString: ["Automatic", "Manual"],
                                      selected: (s) {
                                        model.updateSetCarData(data: s, dataType: 'gear');
                                      },
                                    );
                                  },
                                ),
                                _buildFeatureItem(
                                  context: context,
                                  icon: 'assets/images/icons/seat.png',
                                  label: 'Seats',
                                  value: model.seats ?? 'Select total',
                                  onTap: () {
                                    listHelperPicker(
                                      height: 220,
                                      context: context,
                                      title: 'Number of Seats',
                                      listString: ["1", "2", "3", "4", "5"],
                                      selected: (s) {
                                        model.updateSetCarData(data: s, dataType: 'seats');
                                      },
                                    );
                                  },
                                ),
                                _buildFeatureItem(
                                  context: context,
                                  icon: 'assets/images/icons/airbag.png',
                                  label: 'Airbags',
                                  value: model.airBag ?? 'Select total',
                                  onTap: () {
                                    listHelperPicker(
                                      height: 220,
                                      context: context,
                                      title: 'Number of Airbags',
                                      listString: ["1", "2"],
                                      selected: (s) {
                                        model.updateSetCarData(data: s, dataType: 'air_bag');
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            const YMargin(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildFeatureItem(
                                  context: context,
                                  icon: 'assets/images/icons/aircondition.png',
                                  label: 'AC Status',
                                  value: model.airConditioner ?? 'Select status',
                                  onTap: () {
                                    listHelperPicker(
                                      height: 220,
                                      context: context,
                                      title: 'Air Conditioning Status',
                                      listString: ["Ok", "None"],
                                      selected: (s) {
                                        model.updateSetCarData(data: s, dataType: 'air_conditioner');
                                      },
                                    );
                                  },
                                ),
                                _buildFeatureItem(
                                  context: context,
                                  icon: 'assets/images/icons/speaker.png',
                                  label: 'Speakers',
                                  value: model.speakers ?? 'Select total',
                                  onTap: () {
                                    listHelperPicker(
                                      height: 220,
                                      context: context,
                                      title: 'Number of Working Speakers',
                                      listString: ["5", "6", "11", "15", "21"],
                                      selected: (s) {
                                        model.updateSetCarData(data: s, dataType: 'speakers');
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const YMargin(15),
                    MainInputField(
                      controller: _mileageController,
                      label: "Mileage",
                      isEnabled: true,
                      validator: (s) {
                        return AnyInputValidator.emptyValidate(s, inputName: 'Mileage');
                      },
                      keyboard: TextInputType.number,
                      onChanged: (s){
                        model.updateSetCarData(data: s, dataType: 'mileage');
                      },
                    ),
                    if(model.isBusinessOrForSale) ... [
                      const YMargin(15),
                      MainInputField(
                        controller: _vinController,
                        label: "VIN number",
                        isEnabled: true,
                        onChanged: (s){
                          model.updateSetCarData(data: s, dataType: 'vin_number');
                        },
                      ),
                      const YMargin(15),
                      MainInputField(
                        //controller: ,
                        label: "Selling price",
                        isEnabled: true,
                        keyboard: TextInputType.number,
                        validator: (s) {
                          return AnyInputValidator.emptyValidate(s, inputName: 'Selling price');
                        },
                        onChanged: (s){
                          model.updateSetCarData(data: s, dataType: 'selling price');
                        },
                      ),
                      const YMargin(15),
                      Row(
                        children: [
                          Expanded(
                            child: MainInputField(
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
                    const YMargin(25),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showAdvancedFields = !_showAdvancedFields;
                        });
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const NormalText(
                              text: 'Advance (for Insurance needs)',
                              textColor: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            Icon(
                              _showAdvancedFields ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_showAdvancedFields) ...[
                      const YMargin(15),
                      MainInputField(
                        controller: _chassisNumberController,
                        label: "Chassis Number",
                        isEnabled: true,
                        onChanged: (s){
                          model.updateSetCarData(data: s, dataType: 'chassis_number');
                        },
                      ),
                      const YMargin(15),
                      MainInputField(
                        controller: _engineNumberController,
                        label: "Engine Number",
                        isEnabled: true,
                        onChanged: (s){
                          model.updateSetCarData(data: s, dataType: 'engine_number');
                        },
                      ),
                      const YMargin(15),
                      MainInputField(
                        controller: _registrationNumberController,
                        label: "Registration Number",
                        isEnabled: true,
                        onChanged: (s){
                          model.updateSetCarData(data: s, dataType: 'registration_number');
                        },
                      ),
                      const YMargin(15),
                      MainInputField(
                        controller: _chassisNumberController,
                        label: "Vin number",
                        isEnabled: true,
                        onChanged: (s){
                          model.updateSetCarData(data: s, dataType: 'vin_number');
                        },
                      ),
                    ],
                    const YMargin(35),
                    XButton(
                      onPressed: () {

                        if(_formKey.currentState!.validate()) {
                          model.uploadCar(
                              onCallBack: () {
                                Navigator.pop(context, true);
                              },
                              onErrorCallBack: () {
                                Navigator.pop(context, false);
                              }
                          );
                        }

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
          ),
        );
      }
    );
  }

  Widget _buildImageUploader(AddCarViewModel model) {
    final PageController _pageController =
    PageController(viewportFraction: 0.8);

    if (model.addImagesList.isNotEmpty) {
      return SizedBox(
        height: 250,
        child: ListView.builder(
            controller: _pageController,
            itemCount: model.addImagesList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        width: 250,
                        height: 250,
                        child: Image.file(
                          model.addImagesList[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: ContainerWidget(
                        onTap:()=> model.removeCarByIndex(index),
                        decoration:const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle,),
                        padding: const EdgeInsets.all(2),
                        height: 26,
                        width: 26,
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
        ),
      );
    }
    return Container(
        width: double.infinity,
        height: 250,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF4EFFB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GetSvgImage(image: 'assets/images/file_uploadfile.svg'),
            const YMargin(16),
            GestureDetector(
              onTap: (){
                model.pickImages();
              },
              child: const NormalText(
                text: 'Click to upload',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const NormalText(
              text: 'PNG, JPG (max. 800×400px)',
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Color(0xFFD0D5DD),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: NormalText(
                      text: 'OR',
                      fontSize: 14,
                      textColor: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Color(0xFFD0D5DD),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: model.browseFiles,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A1CAC),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: NormalText(
                text: 'Browse Files',
                textColor: XColors.white(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
    );
  }

}