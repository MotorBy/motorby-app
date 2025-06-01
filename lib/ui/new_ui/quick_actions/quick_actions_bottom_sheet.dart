import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/community/community_screen.dart';
import 'package:mobile_auto_drive/ui/home/history_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/marketplace_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_list_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_selector_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'quick_actions_viewmodel.dart';

class QuickActionsBottomSheet extends StatelessWidget {
  const QuickActionsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuickActionsViewModel>.reactive(
        viewModelBuilder: () => QuickActionsViewModel(),
        onViewModelReady: (model) => model.init(),
        builder: (context, model, child) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: XColors.background(),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleText(
                          text: 'Your Quick actions',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        GestureDetector(
                          onTap: () {
                            popView(context);
                          },
                          child: TitleText(
                            text: 'Close',
                            fontSize: 13,
                            textColor: XColors.primaryColor2().withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Car selection section
                  CarSelectorView(
                      cars: model.getBudgetData(),
                      currentCar: model.getCurrentCar() != null
                          ? '${model.getCurrentCar()!.carMake} ${model.getCurrentCar()!.carModel} ${model.getCurrentCar()!.carYear}'
                          : null,
                      onCarSelected: ({Budget? budget, int? index}) {
                        if (budget != null) {
                          model.setCurrentCar(budget.carId);
                        }
                      },
                  ),

                  // Action buttons grid
                  Padding(
                    padding: const EdgeInsets.only(top: 14, bottom: 24),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 9,
                      crossAxisSpacing: 9,
                      children: [
                        _buildActionItem(
                          context,
                          svgImage: 'assets/images/repairs_action_icon.svg',
                          iconColor: const Color(0xFF5C6D35),
                          iconBgColor: const Color(0xFFE8F0D5),
                          label: 'Repairs',
                          value: model.repairsSpent,
                          onTap: () {
                            navigate(context, const HistoryScreen(
                              budgetHistoryType: "Repairing",
                            ));
                          },
                        ),
                        _buildActionItem(
                          context,
                          svgImage: 'assets/images/fuel_action_icon.svg',
                          iconColor: const Color(0xFFB8A727),
                          iconBgColor: const Color(0xFFF9F6D9),
                          label: 'Fueling',
                          value: model.fuelingSpent,
                          onTap: () {
                            navigate(context, const HistoryScreen(
                              budgetHistoryType: "Fueling",
                            ));
                          },
                        ),
                        _buildActionItem(context,
                            svgImage: 'assets/images/servicing_action_icon.svg',
                            iconColor: const Color(0xFF1F2A00),
                            iconBgColor: const Color(0xFFE8F0D5),
                            label: 'Servicing',
                            value: model.servicingSpent, onTap: () {
                          navigate(context, const HistoryScreen(
                            budgetHistoryType: "Servicing",
                          ));
                        }),
                        _buildActionItem(
                          context,
                          svgImage: 'assets/images/map_action_icon.svg',
                          iconColor: Colors.white,
                          iconBgColor: Colors.purple,
                          label: 'Map',
                          value: model.savedLocationsCount,
                          onTap: () {
                            navigate(context, const MapScreen(isFromQuickActions: true,));
                          },
                        ),
                        _buildActionItem(
                          context,
                          svgImage: 'assets/images/car_action_icon.svg',
                          iconColor: Colors.white,
                          iconBgColor: const Color(0xFFCDAEA7),
                          label: 'Cars',
                          value: model.addedCarsCount,
                          onTap: () {
                            navigate(context, const CarsListScreen());
                          },
                        ),
                        _buildActionItem(
                          context,
                          svgImage: 'assets/images/reminder_action.svg',
                          iconColor: Colors.white,
                          iconBgColor: const Color(0xFF004D1F),
                          label: 'Reminder',
                          value: '${model.totalReminderSet} reminder(s)',
                          onTap: () {
                            navigate(context, const ReminderScreen(isFromQuickActions: true,));
                          },
                        ),
                      ],
                    ),
                  ),

                  // Additional action buttons
                  _buildFullWidthButton(
                    context,
                    label: 'Enter community',
                    onTap: () {
                      navigate(context, const CommunityScreen());
                    },
                  ),
                  const YMargin(6),
                  _buildFullWidthButton(
                    context,
                    label: 'Marketplace',
                    onTap: () {

                      FloatingSnackBar.show(
                          context,
                          backgroundColor: XColors.primaryColor(),
                          'Marketplace is coming soon',
                      );

                    },
                  ),
                  const YMargin(6),
                  _buildFullWidthButton(
                    context,
                    label: 'Vin checks',
                    onTap: () {

                      FloatingSnackBar.show(
                        context,
                        backgroundColor: XColors.primaryColor(),
                        'Vin checks is coming soon',
                      );

                    },
                  ),
                ],
              ),
        ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    IconData? icon,
    String? svgImage,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ContainerWidget(
        elevation: 0.2,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        backgroundColor: XColors.white(),
        child: Center(
          child: Column(
            children: [
              const YMargin(5),
              Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: icon != null
                          ? Icon(
                              icon,
                              color: iconColor,
                              size: 24,
                            )
                          : svgImage != null
                              ? GetSvgImage(image: svgImage)
                              : Icon(
                                  Icons.circle,
                                  color: iconColor,
                                  size: 24,
                                ),
                    ),
                  ),
                  const YMargin(6),
                  NormalText(
                    text: label,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const YMargin(8),
              NormalText(
                text: value,
                fontSize: 12,
                textColor: XColors.textColor(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ContainerWidget(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        backgroundColor: XColors.white(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NormalText(
              text: label,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: XColors.primaryColor()),
          ],
        ),
      ),
    );
  }
}
