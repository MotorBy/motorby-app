import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_selector_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/buy_insurance_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/claim_screeen.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
        viewModelBuilder: () => InsuranceViewModel(),
        disposeViewModel: false,
        onViewModelReady:(model) async => await model.getInsuranceProducts(),
        builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const GetSvgImage(
                  image: 'assets/images/arrow_back.svg',
                  boxFit: BoxFit.scaleDown,
                )),
            centerTitle: false,
            backgroundColor: XColors.highlightColor().withOpacity(0.1),
            title: const NormalText(
              text: 'Car Insurance',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: XColors.background(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const YMargin(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: NormalText(
                    text: 'Protect your car with comprehensive coverage',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: XColors.black(),
                  ),
                ),
                const YMargin(36),
                ContainerWidget(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                  backgroundColor: XColors.white(),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        dense: true,
                        visualDensity: const VisualDensity(horizontal: -4),
                        title: CarSelectorView(
                            cars: model.getBudgetData(),
                            currentCar: model.getCurrentCar() != null ? '${model.getCurrentCar()!.carMake} ${model.getCurrentCar()!.carModel} ${model.getCurrentCar()!.carYear}' : null,
                            onCarSelected: (car){

                            }
                        ),
                        trailing: ContainerWidget(
                          onTap: (){
                            navigate(context, const ClaimScreen());
                          },
                          borderColor: XColors.primaryColor2(),
                          hasBorder: true,
                          borderThickness: 2,
                          borderRadius: BorderRadius.circular(21),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: const NormalText(
                            text: 'Claim',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ContainerWidget(
                        onTap: (){

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) =>
                            const InsuranceQuoteBottomSheet(),
                          );

                        },
                        borderColor: XColors.primaryColor2(),
                        hasBorder: true,
                        borderThickness: 2,
                        borderRadius: BorderRadius.circular(21),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: const NormalText(
                          text: 'Request quote',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const YMargin(16),
                    ],
                  ),
                ),
                const YMargin(32),
                ContainerWidget(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  backgroundColor: const Color(0xFFF3F3FA),
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const NormalText(
                            text: 'Current Purchased ',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          const YMargin(18),
                          const NormalText(
                            text: 'Comprehensive Party Insurance',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          const YMargin(7),
                          Row(
                            children: [
                              NormalText(
                                text: 'By ',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textColor: XColors.black(),
                              ),
                              NormalText(
                                text: 'Leadway Insurance Ltd.',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                textColor: XColors.black(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierColor: Colors.black.withOpacity(0.2),
                              builder: (context) {
                                return const ViewDetailsDialogue();
                              });
                        },
                        child: NormalText(
                          text: 'View Details ',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          textColor: XColors.primaryColor2(),
                        ),
                      ),
                    ],
                  ),
                ),
                const YMargin(32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      child: NormalText(
                        text: 'Available Insurance ',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const YMargin(20),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                          itemCount: model.insuranceList.length,
                          scrollDirection: Axis.horizontal,
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final insurance=model.insuranceList[index];
                            return ContainerWidget(
                              onTap: (){},
                              width: 310,
                              margin: const EdgeInsets.symmetric(horizontal: 16.0),
                              borderRadius: BorderRadius.circular(16),
                              backgroundColor: XColors.secondaryColor(),
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NormalText(
                                    text:insurance.name!.toUpperCase(),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const YMargin(10),
                                  NormalText(
                                    text: insurance.type,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const YMargin(15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            '₦',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                          ),
                                          NormalText(
                                              text: insurance.cost,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700),
                                        ],
                                      ),
                                      ContainerWidget(
                                        onTap: (){
                                          navigate(context, const BuyInsuranceScreen());
                                        },
                                        backgroundColor: XColors.white(),
                                        borderRadius: BorderRadius.circular(8),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        child: NormalText(
                                          text: 'Buy Now',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          textColor: XColors.primaryColor2(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    const YMargin(62),
                    const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          child: NormalText(
                            text: 'Your Certification Of Insurance',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          child: NormalText(
                              text: 'Here’s what you need to prove that you have a policy with comprehensive party insurance',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        YMargin(26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GetSvgImage(
                                image: 'assets/images/material-symbols_download.svg'),
                            NormalText(
                              text: 'Download certificate',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              textColor: Colors.green,
                            )
                          ],
                        ),
                      ],
                    ),
                    const YMargin(50),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class ViewDetailsDialogue extends StatelessWidget {
  const ViewDetailsDialogue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
      viewModelBuilder: () => InsuranceViewModel(),
      builder: (context, viewModel, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
                height: 420,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const NormalText(
                          text: 'View Details',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const YMargin(20),
                    SizedBox(
                      height: 320,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -2),
                              onTap: () {},
                              leading: NormalText(
                                text: viewModel.viewDetails[index],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              title: NormalText(
                                text: viewModel.viewDetailsValue[index],
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const DividerWidget(
                                margin: EdgeInsets.symmetric(vertical: 10),
                              ),
                          itemCount: viewModel.viewDetails.length),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class InsuranceQuoteBottomSheet extends StatelessWidget {
  const InsuranceQuoteBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
        viewModelBuilder: () => InsuranceViewModel(),
        builder: (context, model, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 720,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                  height: 4,
                  width: 40,
                  color: const Color(0xFFD0D5DD),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const NormalText(
                      text: 'Request quote',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 490,
                  child: ListView(
                    children: [
                      buildField(context, model, 'Vehicle make', 'BMW',
                          TextEditingController(text: model.selectedVehicle),
                          () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) =>
                              const VehicleMakeListBottomSheet(),
                        );
                      },
                          true,
                          const GetSvgImage(
                              image: 'assets/images/icon_down.svg',
                              boxFit: BoxFit.scaleDown)),
                      const YMargin(15),
                      buildField(context, model, 'Model', 'BMW',
                          TextEditingController(text: model.selectedModel), () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => const ModelListBottomSheet(),
                        );
                      },
                          true,
                          const GetSvgImage(
                              image: 'assets/images/icon_down.svg',
                              boxFit: BoxFit.scaleDown)),
                      const YMargin(15),
                      buildField(context, model, 'Engine Type ', '5.0L',
                          TextEditingController(text: model.selectedEngine),
                          () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => const EngineTableBottomSheet(),
                        );
                      },
                          true,
                          const GetSvgImage(
                              image: 'assets/images/icon_down.svg',
                              boxFit: BoxFit.scaleDown)),
                      const YMargin(15),
                      buildField(
                          context,
                          model,
                          'Year of Manufacture ',
                          'Type here',
                          model.manufacture,
                          () {},
                          false,
                          const SizedBox.shrink()),
                      const YMargin(15),
                      buildField(
                          context,
                          model,
                          'Vehicle Type',
                          'Type here',
                          model.vehicleType,
                          () {},
                          false,
                          const SizedBox.shrink()),
                      const YMargin(15),
                      buildField(
                          context,
                          model,
                          'Registration Number',
                          'Type here',
                          model.registrationNumber,
                          () {},
                          false,
                          const SizedBox.shrink()),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: XColors.primaryColor2(),
                      foregroundColor: XColors.primaryColor2(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const NormalText(
                      text: 'Get My Quote',
                      textColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
  }
}

class VehicleMakeListBottomSheet extends StatelessWidget {
  const VehicleMakeListBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
        viewModelBuilder: () => InsuranceViewModel(),
        builder: (context, model, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 720,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                  height: 4,
                  width: 40,
                  color: const Color(0xFFD0D5DD),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const NormalText(
                      text: 'Vehicle Make',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                    height: 600,
                    child: ListView.separated(
                      itemCount: model.vehicle.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            model.updateSelectedVehicle(
                                model.vehicle[index], index);
                          },
                          leading: ContainerWidget(
                            height: 30,
                            width: 30,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: XColors.white(),
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: model.selectedVehicleIndex != index
                                    ? const Color(0xFFD0D5DD)
                                    : XColors.primaryColor2(),
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 2,
                              backgroundColor:
                                  model.selectedVehicleIndex != index
                                      ? const Color(0xFFD0D5DD)
                                      : XColors.primaryColor2(),
                            ),
                          ),
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                          ),
                          title: NormalText(text: model.vehicle[index]),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const DividerWidget(),
                    )),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
  }
}

class ModelListBottomSheet extends StatelessWidget {
  const ModelListBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
        viewModelBuilder: () => InsuranceViewModel(),
        builder: (context, model, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 720,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                  height: 4,
                  width: 40,
                  color: const Color(0xFFD0D5DD),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const NormalText(
                      text: 'Model',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                    height: 600,
                    child: ListView.separated(
                      itemCount: model.model.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            model.updateSelectedModel(
                                model.model[index], index);
                          },
                          leading: ContainerWidget(
                            height: 30,
                            width: 30,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: XColors.white(),
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: model.selectedModelIndex != index
                                    ? const Color(0xFFD0D5DD)
                                    : XColors.primaryColor2(),
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 2,
                              backgroundColor: model.selectedModelIndex != index
                                  ? const Color(0xFFD0D5DD)
                                  : XColors.primaryColor2(),
                            ),
                          ),
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          title: NormalText(text: model.model[index]),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const DividerWidget(),
                    )),
              ],
            ),
          );
        });
  }
}

class EngineTableBottomSheet extends StatelessWidget {
  const EngineTableBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
        viewModelBuilder: () => InsuranceViewModel(),
        builder: (context, model, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 720,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                  height: 4,
                  width: 40,
                  color: const Color(0xFFD0D5DD),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const NormalText(
                      text: 'Engine Type',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                    height: 600,
                    child: ListView.separated(
                      itemCount: model.engineType.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            model.updateSelectedEngine(
                                model.engineType[index], index);
                          },
                          leading:
                           ContainerWidget(
                            height: 30,
                            width: 30,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: XColors.white(),
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: model.selectedEngineIndex != index
                                    ? const Color(0xFFD0D5DD)
                                    : XColors.primaryColor2(),
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 2,
                              backgroundColor:
                                  model.selectedEngineIndex != index
                                      ? const Color(0xFFD0D5DD)
                                      : XColors.primaryColor2(),
                            ),
                          ),
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                          ),
                          title: NormalText(text: model.engineType[index]),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const DividerWidget(),
                    )),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
  }
}



Widget buildField(
    BuildContext context,
    InsuranceViewModel model,
    String title,
    String label,
    TextEditingController controller,
    Function() function,
    bool isReadOnly,
    Widget? suffixIcon,
    
    [int? maxLine,Color? background]
    
    ) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      NormalText(
        text: title,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      const SizedBox(height: 8),
      TextFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1, color: Color(0xFFD0D5DD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1, color: Color(0xFFD0D5DD)),
          ),
          hintText: label,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 1,
              color: Color(0xFFD0D5DD),
            ),
          ),
          filled: true,
          fillColor:background ?? XColors.white(),
        ),
        maxLines:maxLine ,
        readOnly: isReadOnly,
        controller: controller,
        onTap: function,
      ),
    ],
  );
}

