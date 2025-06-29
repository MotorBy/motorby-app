import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_selector_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/profile_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/budget_summary_view.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class NewHomeRevampScreen extends StatefulWidget {
  const NewHomeRevampScreen({Key? key}) : super(key: key);

  @override
  State<NewHomeRevampScreen> createState() => _NewHomeRevampScreenState();
}

class _NewHomeRevampScreenState extends State<NewHomeRevampScreen> with AutomaticKeepAliveClientMixin {
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
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: GestureDetector(
                onTap: () {
                  navigate(context, const NewProfileScreen());
                },
                child: const GetSvgImage(image: 'assets/images/user_.svg'),
              ),
            ),
            title: NormalText(
              text: 'Hey ${viewModel.userModel != null ? viewModel.userModel!.payload!.user!.fullname : ""}',
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            centerTitle: false,
            actions: const [],
          ),
          backgroundColor: XColors.background(),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await viewModel.init(
                  onErrorLogout: () {
                    navigateReplace(context, SignInScreen());
                  },
                  onPermissionCallBack: () {}
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const YMargin(24),

                    _buildWeatherSection(
                        viewModel,
                        onGuideClick: () {

                          modalBottomSheetMenu(
                            color: Colors.white,
                            context: context,
                            height: 550,
                            child: const InfoDetailsView(
                              infoType: InfoType.weatherView,
                            ),
                          );

                        }
                    ),
                    const YMargin(8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: ContainerWidget(
                          elevation: 0.2,
                          borderRadius: BorderRadius.circular(16),
                          backgroundColor: XColors.white(),
                          width: double.infinity,
                          child: Column(
                            children: [

                              const YMargin(8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12,),
                                child: CarSelectorView(
                                    cars: viewModel.budgetingModel?.budget != null ? viewModel.budgetingModel!.budget! : [],
                                    currentCar: viewModel.currentCar != null ? '${viewModel.currentCar!.carMake} ${viewModel.currentCar!.carModel} ${viewModel.currentCar!.carYear}' : null,
                                    allowStyling: false,
                                    onCarSelected: ({Budget? budget, int? index}) {
                                      viewModel.onBudgetViewUpdated(index);
                                    }
                                ),
                              ),

                              ///current car body details
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                                child: ContainerWidget(
                                  backgroundColor: XColors.secondaryColor().withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (viewModel.budgetingModel?.budget != null && viewModel.budgetingModel!.budget!.isNotEmpty &&
                                              viewModel.budgetingModel!.budget![viewModel.currentBudgetViewIndex ?? 0].carId != null) {
                                            navigate(context,
                                              CarDetailsScreen(
                                                carData: viewModel.budgetingModel!.budget![viewModel.currentBudgetViewIndex ?? 0].carId!,
                                                budget: viewModel.budgetingModel!.budget![viewModel.currentBudgetViewIndex ?? 0],
                                                currentBudgetIndex: viewModel.currentBudgetViewIndex ?? 0,
                                              ),
                                            );
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            NormalText(
                                              text: 'View details',
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              textColor: XColors.primaryColor(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const YMargin(10),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const GetSvgImage(
                                            image: 'assets/images/car_place_holder.svg',
                                            width: 60,
                                            height: 60,
                                          ),
                                          const XMargin(18),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const NormalText(
                                                        text: 'Checklist',
                                                        fontSize: 12,
                                                        textColor: Colors.grey,
                                                      ),
                                                      const XMargin(8),
                                                      NormalText(
                                                        text: viewModel.hasAddedCar
                                                            ? '${viewModel.currentBudget!.checklistData!.items!.where((item) => item.isChecked == true).length}/${viewModel.currentBudget!.checklistData!.items!.length}'
                                                            : '0/0',
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ],
                                                  ),
                                                  const YMargin(5),
                                                  Row(
                                                    children: [
                                                      const NormalText(
                                                        text: 'Last traveled',
                                                        fontSize: 12,
                                                        textColor: Colors.grey,
                                                      ),
                                                      const XMargin(8),
                                                      NormalText(
                                                        text: '${viewModel.lastDistance} ${viewModel.totalMileageUnit}',
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ],
                                                  ),
                                                  const YMargin(5),
                                                  Row(
                                                    children: [
                                                      const NormalText(
                                                        text: 'Mileage',
                                                        fontSize: 12,
                                                        textColor: Colors.grey,
                                                      ),
                                                      const XMargin(8),
                                                      NormalText(
                                                        text: '${viewModel.totalMileage} ${viewModel.totalMileageUnit}',
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const YMargin(24),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: BudgetSummaryView(
                                  currentBudgetIndex: viewModel.currentBudgetViewIndex,
                                ),
                              ),
                        ],
                      )),
                    ),

                    const YMargin(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: ContainerWidget(
                        elevation: 0.2,
                        borderRadius: BorderRadius.circular(16),
                        backgroundColor: XColors.white(),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  NormalText(
                                    text: 'Recent budget',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor: XColors.black(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              height: 1,
                              width: double.infinity,
                              color: const Color(0xFFD0D5DD).withOpacity(0.5),
                            ),
                            if(viewModel.lastBudget != null && viewModel.lastBudgetModel != null) ... [

                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Wrap(
                                  runAlignment: WrapAlignment.center,
                                  children: [
                                    NormalText(
                                      text: "${viewModel.lastBudgetModel?.isFutureBudget == false ? 'You Spent ' : 'You will be spending'} an amount of ",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textColor: XColors.black(),
                                    ),
                                    Text(
                                      '\u20A6',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: XColors.black(),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    NormalText(
                                      text: amtFormatter(viewModel.lastBudgetModel?.price).toString(),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      textColor: XColors.black(),
                                    ),
                                    NormalText(
                                      text: " on ",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textColor: XColors.black(),
                                    ),
                                    NormalText(
                                      text: viewModel.lastBudgetModel?.budgetType,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textColor: XColors.black(),
                                    ),
                                    NormalText(
                                      text: " in ${viewModel.lastBudgetModel?.date}.",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textColor: XColors.black(),
                                    )
                                  ]
                                ),
                              )

                            ] else ... [

                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: NormalText(
                                    text: 'No budgets yet',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    textColor: XColors.black(),
                                  ),
                                ),
                              )

                            ]

                          ],
                        ),
                      ),
                    ),

                    const YMargin(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: ContainerWidget(
                        elevation: 0.2,
                        borderRadius: BorderRadius.circular(16),
                        backgroundColor: XColors.white(),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  NormalText(
                                    text: 'Reminders',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor: XColors.black(),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      navigate(context, const InfoDetailsView(
                                        infoType: InfoType.reminder,
                                        isFromQuickActions: true,
                                      ));
                                    },
                                    child: NormalText(
                                      text: 'New',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      textColor: XColors.primaryColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              height: 1,
                              width: double.infinity,
                              color: const Color(0xFFD0D5DD).withOpacity(0.5),
                            ),
                            ReminderListView(
                              reminders: viewModel.getReminderLists(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherSection(HomeViewModel viewModel, {Function? onGuideClick}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: ContainerWidget(
        backgroundColor: XColors.secondaryColor().withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NormalText(
                  text: '${viewModel.currentWeatherValue}°C',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                const XMargin(8),
                const GetSvgImage(image: 'assets/images/bi_cloud-sun.svg'),
                const XMargin(24),
                NormalText(
                  text: '${viewModel.currentWeatherDescription}',
                  fontSize: 14,
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                onGuideClick?.call();
              },
              child: NormalText(
                text: 'Drive guide',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                textColor: XColors.primaryColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

}