import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/report_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class ExpenditureReportView extends StatelessWidget {
  final ReportViewModel model;

  const ExpenditureReportView({
    Key? key,
    required this.model,
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
      '100,030,409.50',
      '100,030,409.50',
      '100,030,409.50',
      '100,030,409.50'
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBudgetHeader(),
            const SizedBox(height: 32),
            SizedBox(
              height: 300,
              child: GridView.builder(
                  itemCount: budgetIcon.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 18,
                      mainAxisExtent: 118),
                  itemBuilder: (context, index) {
                    return ContainerWidget(
                      backgroundColor: XColors.containerColor(),
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GetPngImage(image: budgetIcon[index]),
                          ),
                          Center(
                            child: NormalText(text: budgetTopic[index],fontSize: 14,fontWeight: FontWeight.w400,),
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
                              NormalText(text: budgetSubTopic[index],fontSize: 14,fontWeight: FontWeight.w600,)
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetHeader() {
    return ContainerWidget(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      backgroundColor: XColors.white(),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const NormalText(
                text: 'Budget Statistics',
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              DropdownButton<String>(
                value: model.selectedTimeFrame,
                icon: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: GetSvgImage(image: 'assets/images/arrow_down.svg'),
                ),
                items: ['This week', 'This month', 'This year']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => model.setTimeFrame(value!),
              ),
            ],
          ),
          const SizedBox(height: 8),
          NormalText(
            text: 'Your weekly expenses',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            textColor: XColors.black().withOpacity(0.8),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 20,
            child: ListView.builder(
              itemBuilder: (context, index) {
                final List<String> summary = [
                  'Refuel',
                  'Services',
                  'Repair',
                  'Expenses'
                ];
                return ReportSummary(
                  title: summary[index],
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: 4,
            ),
          ),
          const YMargin(14),
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
                text: '100,000.00',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textColor: XColors.black(),
              ),
            ],
          ),
          const YMargin(14),
          ContainerWidget(
            backgroundColor: XColors.background(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    minHeight: 40,
                    color: XColors.primaryColor2(),
                    backgroundColor: XColors.primaryColor2(),
                    borderRadius: BorderRadius.circular(8),
                    value: 0.6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Text(
                        '\u20A6',
                        style: TextStyle(
                            fontSize: 14,
                            color: XColors.black(),
                            fontWeight: FontWeight.w600),
                      ),
                      NormalText(
                        text: '36,000.00',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        textColor: XColors.black(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const YMargin(16),
          _buildCategoryDistribution()
        ],
      ),
    );
  }

  Widget _buildExpenseProgressBar() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildCategoryDistribution() {
    return Column(
      children: [
        Container(
          height: 30,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(color: Colors.purple[200]),
              ),
              Expanded(
                flex: 2,
                child: Container(color: Colors.grey[300]),
              ),
              Expanded(
                flex: 2,
                child: Container(color: Colors.pink[100]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Refuel'),
            Text('Services'),
            Text('Repair'),
          ],
        ),
      ],
    );
  }

  Widget _buildExpenseCardsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildExpenseCard(
          'Fueling',
          '₦100,030,409.50',
          Icons.local_gas_station,
        ),
        _buildExpenseCard(
          'Servicing',
          '₦100,030,409.50',
          Icons.build,
        ),
        _buildExpenseCard(
          'Repair',
          '₦100,030,409.50',
          Icons.build_circle,
        ),
        _buildExpenseCard(
          'Expenses',
          '₦100,030,409.50',
          Icons.account_balance_wallet,
        ),
      ],
    );
  }

  Widget _buildExpenseCard(String title, String amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
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
            fontWeight: FontWeight.w400,
            textColor: XColors.black().withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
