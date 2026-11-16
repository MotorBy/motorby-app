import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/add/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/community/community_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/history_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_list_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_selector_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/ui/new_ui/drive/drive_mode_screen.dart';
import 'package:mobile_auto_drive/utils/brand.dart';
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

                            if(model.getCurrentCar() == null) {
                              FloatingSnackBar.show(
                                  context,
                                  "Add a new car to continue",
                                  isError: true
                              );
                              return;
                            }

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

                            if(model.getCurrentCar() == null) {
                              FloatingSnackBar.show(
                                  context,
                                  "Add a new car to continue",
                                  isError: true
                              );
                              return;
                            }

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

                              if(model.getCurrentCar() == null) {
                                FloatingSnackBar.show(
                                    context,
                                    "Add a new car to continue",
                                    isError: true
                                );
                                return;
                              }

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
                          label: 'Add a car',
                          value: model.addedCarsCount,
                          onTap: () {
                            navigate(context, const AddCarsScreen());
                          },
                        ),
                        _buildActionItem(
                          context,
                          svgImage: 'assets/images/reminder_action.svg',
                          iconColor: Colors.white,
                          iconBgColor: const Color(0xFF004D1F),
                          label: 'Reminders',
                          value: '${model.totalReminderSet} reminder(s)',
                          onTap: () {
                            navigate(context, const InfoDetailsView(
                              infoType: InfoType.reminder,
                              isFromQuickActions: true,
                            ));
                          },
                        ),
                      ],
                    ),
                  ),

                  const YMargin(14),
                  _DriveButton(model: model),
                  const YMargin(14),

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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const YMargin(6),
              NormalText(
                text: value,
                fontSize: 11,
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

/// Starts drive mode for the selected car, or, while a drive is on, shows it
/// is live and jumps back to it.
class _DriveButton extends StatelessWidget {
  const _DriveButton({required this.model});

  final QuickActionsViewModel model;

  Future<void> _onTap(BuildContext context) async {
    final navigator = Navigator.of(context);
    final problem = await model.startDriving();
    if (problem != null) {
      if (context.mounted) FloatingSnackBar.show(context, problem, isError: true);
      return;
    }
    navigator.pop();
    navigator.push(MaterialPageRoute(builder: (_) => const DriveModeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final driving = model.isDriving;
    final starting = model.isStartingDrive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: starting ? null : () => _onTap(context),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: driving ? const [Color(0xFF0E9F6E), Brand.success] : const [Brand.deepPurple, Brand.orchid],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: starting
                    ? const Padding(
                        padding: EdgeInsets.all(13),
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                      )
                    : Icon(driving ? Icons.navigation_rounded : Icons.play_arrow_rounded,
                        color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.driveTitle,
                        style: Brand.text(size: 16, weight: FontWeight.w700, color: Colors.white)),
                    if(model.isDriving) ... [

                      const SizedBox(height: 2),
                      Text(model.driveSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Brand.text(size: 12, color: Colors.white.withOpacity(0.85))),

                    ]
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
