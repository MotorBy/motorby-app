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

class ExpenditureReportView extends StatelessWidget {
  final ReportViewModel model;
  final BuildContext? ctxt;

  const ExpenditureReportView({
    Key? key,
    required this.model,
    this.ctxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final List<String> budgetIcon = [
      'assets/images/fuel_guage.png',
      'assets/images/servicng-icon.png',
      'assets/images/repaair-icon.png',
      'assets/images/expenses.png'
    ];

    final List<String> budgetTopic = [
      'Fueling',
      'Servicing',
      'Repair',
      'Expenses'
    ];

    final List<String> budgetSubTopic = [
      amtFormatter(model.totalCostingAndValue![0]),
      amtFormatter(model.totalCostingAndValue![1]),
      amtFormatter(model.totalCostingAndValue![2]),
      amtFormatter(0),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBudgetHeader(
              currentSpending: model.budgetingModel != null ?
              amtFormatter(model.budgetingModel!.budget![model.currentCarBudgetIndex].currentSpending!) : "0",
              totalBudget: model.budgetingModel != null ?
              amtFormatter(model.budgetingModel!.budget![model.currentCarBudgetIndex].budget!) : "0"
          ),
          const YMargin(24),
          SizedBox(
            height: 280,
            child: GridView.builder(
                itemCount: budgetIcon.length,
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 18,
                    mainAxisExtent: 118,
                ),
                itemBuilder: (context, index) {
                  return ContainerWidget(
                    backgroundColor: XColors.containerColor(),
                    borderRadius: BorderRadius.circular(16),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    onTap: () {

                      InfoType? infoType;

                      if(index == 0) {
                        infoType = InfoType.fueling;
                      } else if(index == 1) {
                        infoType = InfoType.servicing;
                      } else if(index == 2) {
                        infoType = InfoType.repairing;
                      } else if(index == 3) {

                      }

                      modalBottomSheetMenu(
                        color: Colors.white,
                        context: ctxt!,
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
                          alignment: Alignment.centerRight,
                          child: GetPngImage(image: budgetIcon[index]),
                        ),
                        Center(
                          child: NormalText(
                            text: budgetTopic[index],
                            fontSize: 14,
                            textColor: XColors.primaryColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const YMargin(10),
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
        ],
      ),
    );
  }

  Widget _buildBudgetHeader({String? currentSpending, String? totalBudget}) {

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
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              // DropdownButton<String>(
              //   value: model.selectedTimeFrame,
              //   icon: const Padding(
              //     padding: EdgeInsets.only(left: 10.0),
              //     child: GetSvgImage(image: 'assets/images/arrow_down.svg'),
              //   ),
              //   items: ['This week', 'This month', 'This year']
              //       .map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   onChanged: (value) => model.setTimeFrame(value!),
              // ),
            ],
          ),
          NormalText(
            text: 'Your current expenses',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: XColors.black().withOpacity(0.8),
          ),
          const YMargin(24),
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

                  modalBottomSheetMenu(
                    color: Colors.white,
                    context: ctxt!,
                    child: InfoDetailsView(
                      infoType: InfoType.budgeting,
                      onBudgetAction: () {
                        model.setBudgetData();
                        FloatingSnackBar.show(
                            ctxt!,
                            'Car budget successfully updated',
                            isError: false
                        );
                      },
                      currentIndex: 0,
                    ),
                  );

                },
                child: NormalText(
                  text: 'update',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  textColor: XColors.primaryColor(),
                ),
              ),
            ],
          ),
          const YMargin(36),
          _buildCategoryDistribution(
            fueling: model.totalCostingAndValue![0].toDouble(),
            servicing: model.totalCostingAndValue![1].toDouble(),
            repairing: model.totalCostingAndValue![2].toDouble(),
            total: model.currentSetBudget!.toDouble(),
            spent: model.currentTotalSpent!.toDouble(),
          ),
          const YMargin(6),
        ],
      ),
    );
  }

  Widget _buildCategoryDistribution({double? fueling, double? servicing, double? repairing, double? expenses, double? total, double? spent}) {
    final categories = [
      {'name': 'Fuel', 'value': fueling ?? 0.0, 'color': Colors.purple[200]},
      {'name': 'Services', 'value': servicing ?? 0.0, 'color': Colors.grey[300]},
      {'name': 'Repair', 'value': repairing ?? 0.0, 'color': Colors.pink[100]},
      {'name': 'Other Expenses', 'value': expenses ?? 0.0, 'color': Colors.blue[100]},
    ];

    final totalSpent = spent ?? 0;
    final totalBudget = total ?? 100000.0; // This should come from your model
    final remainingBudget = totalBudget - totalSpent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
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
              if (remainingBudget > 0)
                Expanded(
                  flex: ((remainingBudget / totalBudget) * 100).round(),
                  child: Container(color: Colors.grey[300]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            ...categories.map((category) => _buildLegendItem(
                  name: category['name'] as String,
                  color: category['color'] as Color?,
                  value: category['value'] as double,
                  percentage: (category['value'] as double) / totalBudget * 100,
                ),
            ),
            if (remainingBudget > 0)
              _buildLegendItem(
                name: 'Remaining',
                color: Colors.grey[50],
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
        Text(
          '$name (${percentage.toStringAsFixed(1)}%)',
          style: TextStyle(
            fontSize: 12,
            color: XColors.black().withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

}

class ReportSummary extends StatelessWidget {
  const ReportSummary({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFF7D1CD),
            radius: 4,
          ),
          const XMargin(2),
          NormalText(
            text: title,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            textColor: XColors.black(),
          ),
        ],
      ),
    );
  }
}
