import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/report_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class BudgetSummaryView extends StatefulWidget {
  const BudgetSummaryView({super.key, this.currentBudgetIndex});

  final int? currentBudgetIndex;

  @override
  State<BudgetSummaryView> createState() => _BudgetSummaryViewState();
}

class _BudgetSummaryViewState extends State<BudgetSummaryView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportViewModel>.reactive(
        viewModelBuilder: () => ReportViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) {
          model.setBudgetData(currentIndex: widget.currentBudgetIndex ?? 0);
        },
        builder: (context, model, child) {

          String currentSpending = model.budgetingModel != null &&
              model.budgetingModel!.budget!.isNotEmpty ? amtFormatter(model.budgetingModel!.budget?[widget.currentBudgetIndex ?? 0].currentSpending!) : "0";

          String totalBudget = model.budgetingModel != null &&
              model.budgetingModel!.budget!.isNotEmpty ? amtFormatter(model.budgetingModel!.budget?[widget.currentBudgetIndex ?? 0].budget!) : "0";

          return ContainerWidget(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            backgroundColor: XColors.white(),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalText(
                      text: 'Budget Statistics',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                NormalText(
                  text: 'Your current expenses',
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  textColor: XColors.black().withOpacity(0.8),
                ),
                const YMargin(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              '\u20A6',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: XColors.black(),
                                  fontWeight: FontWeight.w600),
                            ),
                            NormalText(
                              text: currentSpending,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              textColor: XColors.black(),
                            ),
                          ],
                        ),
                        Text(
                          '/',
                          style: TextStyle(
                              fontSize: 19,
                              color: XColors.black(),
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            Text(
                              '\u20A6',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: XColors.black(),
                                  fontWeight: FontWeight.w600),
                            ),
                            NormalText(
                              text: totalBudget,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              textColor: XColors.black(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {

                        if(model.budgetingModel != null && model.budgetingModel!.budget!.isEmpty) {

                          FloatingSnackBar.show(
                              context,
                              'Add a new car to continue with budget activities',
                              isError: true
                          );

                        } else {

                          modalBottomSheetMenu(
                            color: Colors.white,
                            context: context,
                            child: InfoDetailsView(
                              infoType: InfoType.budgeting,
                              onBudgetAction: () {
                                model.setBudgetData();
                                FloatingSnackBar.show(
                                    context,
                                    'Car budget successfully updated',
                                    isError: false
                                );
                              },
                              currentIndex: 0,
                            ),
                          );

                        }

                      },
                      child: NormalText(
                        text: 'update',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        textColor: XColors.primaryColor(),
                      ),
                    ),
                  ],
                ),
                const YMargin(10),
                _buildCategoryDistribution(
                  fueling: model.getCostingAndValue(currentIndex: widget.currentBudgetIndex ?? 0)[0].toDouble(),
                  servicing: model.getCostingAndValue(currentIndex: widget.currentBudgetIndex ?? 0)[1].toDouble(),
                  repairing: model.getCostingAndValue(currentIndex: widget.currentBudgetIndex ?? 0)[2].toDouble(),
                  total: double.parse(totalBudget.replaceAll(',', '')),
                  spent: double.parse(currentSpending.replaceAll(',', '')),
                ),
                const YMargin(6),
              ],
            ),
          );
        }
    );
  }

  Widget _buildCategoryDistribution({
    double? fueling,
    double? servicing,
    double? repairing,
    double? expenses,
    double? total,
    double? spent}) {

    final categories = [
      {'name': 'Fuel', 'value': fueling ?? 0.0, 'color': XColors.primaryColor()},
      {'name': 'Services', 'value': servicing ?? 0.0, 'color': Colors.green},
      {'name': 'Repair', 'value': repairing ?? 0.0, 'color': Colors.red},
    ];

    final totalSpent = spent ?? 0;
    final totalBudget = total ?? 100000.0;
    final remainingBudget = totalBudget - totalSpent;

    print(remainingBudget);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Colors.grey[100],
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              ...categories.map((category) {
                final percentage = (category['value'] as double) / totalBudget;
                final flex = percentage > 0 ? (percentage * 100).round() : 0;
                return Expanded(
                  flex: flex,
                  child: Container(color: category['color'] as Color?),
                );
              }).toList(),
              if (remainingBudget > 0) ... [
                Expanded(
                  flex: ((remainingBudget / totalBudget) * 100).round(),
                  child: Container(color: Colors.grey[300]),
                ),
              ]
            ],
          ),
        ),
        const YMargin(16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            ...categories.map((category) => _buildLegendItem(
              name: category['name'] as String,
              color: category['color'] as Color?,
              value: category['value'] as double,
              percentage: category['value'] != 0.0 ? (category['value'] as double) / totalBudget * 100 : 0.0,
            ),
            ),
            if (remainingBudget > 0)
              _buildLegendItem(
                name: 'Remaining',
                color: Colors.grey[300],
                value: remainingBudget,
                percentage: remainingBudget / totalBudget * 100,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required String name,
    required Color? color,
    required double value,
    required double percentage,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        NormalText(
          text: '$name (${percentage.toStringAsFixed(1)}%)',
          fontSize: 11,
          textColor: XColors.black(),
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}