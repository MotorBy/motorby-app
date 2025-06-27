import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/report_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class BudgetTilesView extends StatelessWidget {
  const BudgetTilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportViewModel>.reactive(
        viewModelBuilder: () => ReportViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) => model.setBudgetData(currentIndex: 0),
        builder: (context, model, child) {

          final List<String> budgetIcon = [
            'assets/images/budget_icons/fuel.png',
            'assets/images/budget_icons/service.png',
            'assets/images/budget_icons/repairs.png',
            'assets/images/budget_icons/wallet.png'
          ];

          final List<String> budgetTopic = [
            'Fueling',
            'Servicing',
            'Repair',
            'Remaining'
          ];

          final List<String> budgetSubTopic = [
            amtFormatter(model.totalCostingAndValue![0]),
            amtFormatter(model.totalCostingAndValue![1]),
            amtFormatter(model.totalCostingAndValue![2]),
            amtFormatter(model.currentSetBudget! - model.currentTotalSpent!),
          ];

          return Column(children: [

          const YMargin(14),
          SizedBox(
            height: 350,
            child: GridView.builder(
              itemCount: budgetIcon.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 18,
                mainAxisExtent: 150,
              ),
              itemBuilder: (context, index) {
                return ContainerWidget(
                  backgroundColor: XColors.secondaryColor().withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  onTap: () {

                    if(model.budgetingModel != null && model.budgetingModel!.budget!.isEmpty) {
                      FloatingSnackBar.show(
                          context,
                          'Add a new car to continue with budget activities',
                          isError: true
                      );
                      return;
                    }

                    InfoType? infoType;

                    if(index == 0) {
                      infoType = InfoType.fueling;
                    } else if(index == 1) {
                      infoType = InfoType.servicing;
                    } else if(index == 2) {
                      infoType = InfoType.repairing;
                    } else if(index == 3) {
                      infoType = InfoType.budgeting;
                    }

                    modalBottomSheetMenu(
                      color: Colors.white,
                      context: context,
                      child: InfoDetailsView(
                        infoType: infoType!,
                        currentIndex: 0,
                        onBudgetAction: () {

                          model.setBudgetData();
                          FloatingSnackBar.show(
                              context,
                              'Successfully updated',
                              isError: false
                          );

                        },
                      ),
                    );

                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GetPngImage(
                          allowSolid: true,
                          allowPadding: true,
                          image: budgetIcon[index],
                          height: 24,
                          width: 24,
                        ),
                      ),
                      const YMargin(7),
                      Center(
                        child: NormalText(
                          text: budgetTopic[index],
                          fontSize: 14,
                          textColor: XColors.primaryColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\u20A6',
                            style: TextStyle(
                                fontSize: 16,
                                color: XColors.black(),
                                fontWeight: FontWeight.w600),
                          ),
                          NormalText(
                            text: budgetSubTopic[index],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],);
      }
    );
  }
}