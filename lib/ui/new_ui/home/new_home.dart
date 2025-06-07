import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/auth/auth_viewmodel.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_selector_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/profile_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/report_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_screen.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) => model.init(
            onErrorLogout: () {
              navigateReplace(context, SignInScreen());
            },
            onPermissionCallBack: () {

              if(model.currentPosition == null && model.locationDeclined == false) {

                modalBottomSheetMenu(
                  color: Colors.white,
                  isDismissible: false,
                  context: context,
                  height: 450,
                  child: InfoDetailsView(
                    infoType: InfoType.locationSetup,
                    onPermissionAction: () {
                      model.getLocationUpdate();
                    },
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
              // Padding(
              //   padding: EdgeInsets.only(right: 16.0),
              //   child: GetSvgImage(image: 'assets/images/motorby_bell.svg'),
              // )
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

                    // Vehicle Selection Card
                    CarSelectorView(
                        cars: viewModel.budgetingModel?.budget != null ? viewModel.budgetingModel!.budget! : [],
                        currentCar: viewModel.currentCar != null ? '${viewModel.currentCar!.carMake} ${viewModel.currentCar!.carModel} ${viewModel.currentCar!.carYear}' : null,
                        allowStyling: false,
                        onCarSelected: ({Budget? budget, int? index}) {
                          viewModel.onBudgetViewUpdated(index);
                        }
                    ),

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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const NormalText(
                              text: '₦',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            NormalText(
                              text: '${viewModel.currentFuelPrice}/ltr',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            const XMargin(12),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () {

                          modalBottomSheetMenu(
                            color: Colors.white,
                            context: context,
                            child: const InfoDetailsView(
                              infoType: InfoType.fuelUpdate,
                            ),
                          );

                        },
                      ),
                    ),
                    const YMargin(14),
                    // Insurance Card
                    Stack(
                      children: [
                        GetPngImage(
                          image: 'assets/images/motorby_toyo.png',
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                        ),
                        Positioned(
                          top: 45,
                          bottom: 25,
                          left: 14,
                          right: 14,
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
                                      fontSize: 20,
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
                      height: viewModel.getReminderLists().isNotEmpty ? null : 150,
                      borderRadius: BorderRadius.circular(16),
                      backgroundColor: XColors.white(),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: NormalText(
                              text: 'Reminders',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              textColor: XColors.black(),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            height: 1,
                            width: double.infinity,
                            color: const Color(0xFFD0D5DD),
                          ),
                          ReminderListView(
                            reminders: viewModel.getReminderLists(),
                          ),
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
                    onTap: () {

                      modalBottomSheetMenu(
                        color: Colors.white,
                        context: context,
                        height: 550,
                        child: const InfoDetailsView(
                          infoType: InfoType.weatherView,
                        ),
                      );

                    },
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: XColors.secondaryColor().withOpacity(0.3),
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
                        const YMargin(6),
                        NormalText(
                          text: '${model.currentWeatherValue} \u2103',
                          fontSize: 22,
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
                        elevation: 0.3,
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
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: XColors.secondaryColor().withOpacity(0.3),
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
                              text: homeViewModel!.hasAddedCar
                                  ? '${homeViewModel!.currentBudget!.checklistData!.items!.where((item) => item.isChecked == true).length}/${homeViewModel!.currentBudget!.checklistData!.items!.length}'
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
                    padding: const EdgeInsets.only(top: 16),
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: XColors.secondaryColor().withOpacity(0.3),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const NormalText(
                          text: 'Mileage(km)',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        const YMargin(12),
                        NormalText(
                          text: model.hasAddedCar ? '${model.budgetingModel?.budget![model.currentBudgetViewIndex!].mileage ?? "0"}' : "0",
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
                    padding: const EdgeInsets.only(top: 16),
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: XColors.secondaryColor().withOpacity(0.3),
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
                          text: model.hasAddedCar ? '₦ ${numberFormat(number: (model.budgetingModel?.budget?[model.currentBudgetViewIndex!].currentSpending ?? 0).toDouble())}' : '₦ 0',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        const YMargin(21),
                        ContainerWidget(
                          onTap: (){
                            navigate(context, ReportScreen(
                              isFromQuickActions: true,
                              currentIndex: model.currentBudgetViewIndex,
                            ));
                          },
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
