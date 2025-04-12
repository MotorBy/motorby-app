import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/auth/auth_viewmodel.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/home/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/profile_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_screen.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';

class VehicleSelectionBottomSheet extends StatelessWidget {
  const VehicleSelectionBottomSheet({Key? key, this.homeViewModel}) : super(key: key);

  final HomeViewModel? homeViewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => homeViewModel ?? HomeViewModel(),
        disposeViewModel: false,
        builder: (context, model, child) {
        return Container(
          padding: const EdgeInsets.all(16),
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
                  ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My cars',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if(homeViewModel!.hasAddedCar) ... [

                const NormalText(
                  text: 'Selecting a car will be set across all the activity within the Motorby application.',
                  fontSize: 13,
                  textColor: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 26),

              ],

              if(homeViewModel!.hasAddedCar) ... [

                SizedBox(
                  height: 140,
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(vertical: -2),
                          leading: const GetSvgImage(
                              image: 'assets/images/auto/toyota_se.svg'
                          ),
                          trailing: const Icon(Icons.circle_outlined),
                          title: NormalText(
                            text: model.budgetingModel!.budget![index].carName,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          selected: true,
                          selectedTileColor: Colors.deepPurple.withOpacity(0.1),
                          onTap: () {
                            model.onBudgetViewUpdated(index);
                            Navigator.pop(context);
                          }
                        );
                      },
                      separatorBuilder: (context, index) => const DividerWidget(),
                      itemCount: model.totalCarsAdded!
                  ),
                ),
                const SizedBox(height: 16),

              ] else ... [

                const NormalText(
                  text: 'You currently have to car added to manage, Add a car to start',
                  fontSize: 13,
                  textColor: Colors.black,
                  fontWeight: FontWeight.w500,
                ),

                const SizedBox(height: 26),

              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const NormalText(
                    text: 'Add car',
                    textColor: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: XColors.background(),
                    side: const BorderSide(width: 1, color: Colors.grey),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    navigate(context, const AddCarScreen());
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }
    );
  }
}

class NewHomeScreen extends StatelessWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) => model.init(
            onErrorLogout: () {
              navigateReplace(context, SignInScreen());
            },
            onPermissionCallBack: () {

              if(model.currentPosition == null &&
                  model.locationDeclined == false) {

                modalBottomSheetMenu(
                  color: Colors.white,
                  isDismissible: false,
                  context: context,
                  child: InfoDetailsView(
                    homeViewModel: model,
                    infoType: 'location_setup',
                  ),
                );

              }
            }
        ),
        builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: XColors.background(),
            leading:  Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: GestureDetector(
                onTap: (){
                navigate(context, const NewProfileScreen());
                },
                child: const GetSvgImage(image: 'assets/images/user_.svg')),
            ),
            title: NormalText(
              text: 'Hey ${viewModel.userModel != null ? viewModel.userModel!.payload!.user!.fullname : ""}',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            centerTitle: false,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: GetSvgImage(image: 'assets/images/motorby_bell.svg'),
              )
            ],
          ),
          backgroundColor: XColors.background(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if(viewModel.currentCar != null) ... [

                      // Vehicle Selection Card
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity: const VisualDensity(horizontal: -4),
                        title: Row(
                          children: [
                            Image.asset('assets/images/toyota-logo.png',
                                height: 24),
                            const SizedBox(width: 2),
                            NormalText(
                              text: viewModel.budgetingModel!.budget![0].carName,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            const XMargin(10),
                            Icon(
                              Icons.expand_less_rounded,
                              color: XColors.black(),
                              size: 30,
                            )
                          ],
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) =>
                                VehicleSelectionBottomSheet(homeViewModel: viewModel,),
                          );
                        },
                      ),

                    ] else ... [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity: const VisualDensity(horizontal: -4),
                        title: Row(
                          children: [
                            // Image.asset('assets/images/toyota-logo.png',
                            //     height: 24),
                            const SizedBox(width: 2),
                            const NormalText(
                              text: 'Add a car',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            const XMargin(10),
                            Icon(
                              Icons.expand_less_rounded,
                              color: XColors.black(),
                              size: 30,
                            )
                          ],
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) =>
                                VehicleSelectionBottomSheet(homeViewModel: viewModel,),
                          );
                        },
                      ),
                    ],

                    const YMargin(14),
                    // Fuel Price Card
                    ContainerWidget(
                      backgroundColor: XColors.highlightColor(),
                      borderRadius: BorderRadius.circular(8),
                      child: ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10),
                        visualDensity: const VisualDensity(vertical: -3),
                        dense: true,
                        title: NormalText(
                          text: 'Average fuel price in your location:',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: XColors.black(),
                        ),
                        trailing: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NormalText(
                              text: '₦',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            NormalText(
                              text: ' 1,150',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            XMargin(12),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                    const YMargin(14),
                    // Insurance Card
                    Stack(
                      children: [
                        const GetPngImage(
                            image: 'assets/images/motorby_toyo.png'),
                        Positioned(
                          top: 35,
                          left: 14,
                          child: GestureDetector(
                            onTap: () {
                              navigate(context, const InsuranceScreen());
                            },
                            child: const AbsorbPointer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Car Insurance',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Request quote',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(Icons.chevron_right,
                                          color: Colors.white),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    const YMargin(16),

                    InfoBox(homeViewModel: viewModel,),

                    const YMargin(16),

                    // Reminder Card
                    ContainerWidget(
                      elevation: 0.2,
                      height: 200,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      borderRadius: BorderRadius.circular(16),
                      backgroundColor: XColors.white(),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NormalText(
                            text: 'Reminders',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            textColor: XColors.black(),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            height: 1,
                            width: double.infinity,
                            color: const Color(0xFFD0D5DD),
                          ),
                          Expanded(
                            child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {},
                                    leading: const GetSvgImage(
                                        image:
                                        'assets/images/water-drop.svg'),
                                    dense: true,
                                    visualDensity:
                                    const VisualDensity(horizontal: -1),
                                    title: NormalText(
                                      text: 'Oil change',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      textColor: XColors.black(),
                                    ),
                                    trailing: const Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        NormalText(
                                          text: '3:00PM',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        NormalText(
                                          text: '23/04/2024',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                const DividerWidget(),
                                itemCount: 4),
                          )
                        ],
                      ),
                    ),

                    const YMargin(16),

                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    super.key,
    this.margin,
  });
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 12),
      height: 1,
      width: double.infinity,
      color: const Color(0xFFD0D5DD),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({super.key, this.homeViewModel});

  final HomeViewModel? homeViewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => homeViewModel ?? HomeViewModel(),
        disposeViewModel: false,
        builder: (context, model, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [

                  ///weather tile
                  ContainerWidget(
                    elevation: 0.2,
                    onTap: (){

                      modalBottomSheetMenu(
                        color: Colors.white,
                        context: context,
                        child: InfoDetailsView(
                          homeViewModel: model,
                          infoType: 'weather_view',
                        ),
                      );

                    },
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: const Color(0xFFF0E8F8),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const NormalText(
                          text: 'Weather',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        const YMargin(12),
                        NormalText(
                          text: '${model.currentWeatherValue} \u2103',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                  const YMargin(16),

                  ///Map tile
                  Stack(
                    children: [
                      ///Map section view
                      ContainerWidget(
                        elevation: 0.2,
                        height: 302,
                        borderRadius: BorderRadius.circular(16),
                        backgroundColor: Colors.black26,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: GoogleMap(
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(6.5244, 3.3792), // Default to Lagos coordinates
                              zoom: 12.0,
                            ),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            mapType: MapType.normal,
                            onMapCreated: (GoogleMapController controller) {
                              MapViewModel().setMapController(controller);
                            },
                          ),
                        ),
                      ),

                      ///Button to navigate to map view
                      Positioned(
                          bottom: 30,
                          right: 0,
                          left: 0,
                          child: Column(
                            children: [
                              const GetSvgImage(image: 'assets/images/expand.svg'),
                              const YMargin(60),
                              ContainerWidget(
                                onTap: () {
                                  navigate(context, const MapScreen());
                                },
                                backgroundColor: const Color(0xFFF0E8F8),
                                borderRadius: BorderRadius.circular(40),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8
                                ),
                                child: NormalText(
                                  text: 'View map',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  textColor: XColors.black(),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
            const XMargin(16),
            Expanded(
              child: Column(
                children: [

                  ///checklist tile
                  ContainerWidget(
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.2),
                          builder: (context) {
                            return ChecklistScreenDialogue(
                              carId: model.hasAddedCar ? model.currentCar!.sId : null,
                              homeViewModel: homeViewModel,
                            );
                          });
                    },
                    elevation: 0.2,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: const Color(0xFFF0E8F8),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const NormalText(
                              text: 'Checklist',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            const YMargin(12),
                            NormalText(
                              text: homeViewModel!.checkListDataModel != null
                                  ? '${homeViewModel!.checkListDataModel!.payload!.items!.where((item) => item.isChecked == true).length}/${homeViewModel!.checkListDataModel!.payload!.items!.length}'
                                  : '0/0',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                        const CircularProgressIndicator(
                          value: 0.8,
                          color: Colors.deepPurple,
                          strokeWidth: 8,
                          backgroundColor: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  const YMargin(16),

                  ///Mileage tile
                  ContainerWidget(
                    elevation: 0.2,
                    padding: const EdgeInsets.only(top: 16),
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: const Color(0xFFF0E8F8),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const NormalText(
                          text: 'Mileage',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        const YMargin(12),
                        NormalText(
                          text: model.hasAddedCar ? model.currentCar!.details!.mileage.toString() : "0",
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        const YMargin(21),
                        ContainerWidget(
                          elevation: 0.2,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                          backgroundColor: XColors.highlightColor(),
                          width: 70,
                          child: const Center(
                            child: NormalText(
                              text: 'Update',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const YMargin(11),
                      ],
                    ),
                  ),
                  const YMargin(16),

                  ///Expenditures tile
                  ContainerWidget(
                    elevation: 0.2,
                    padding: const EdgeInsets.only(top: 16),
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: const Color(0xFFF0E8F8),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const NormalText(
                          text: 'Expenditures',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        const YMargin(12),
                        NormalText(
                          text: model.hasAddedCar ? '₦ ${numberFormat(number: model.budgetingModel!.budget![model.currentBudgetViewIndex!].currentSpending!.toDouble())}' : "₦ 0",
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        const YMargin(21),
                        ContainerWidget(
                          elevation: 0.2,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                          backgroundColor: XColors.highlightColor(),
                          width: 100,
                          child: const Center(
                            child: NormalText(
                              text: 'View report',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const YMargin(11),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}
