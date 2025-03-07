import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/report_viewmodel.dart';

class ExpenditureReportView extends StatelessWidget {
  final ReportViewModel model;

  const ExpenditureReportView({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBudgetHeader(),
          const SizedBox(height: 16),
          _buildExpenseProgressBar(),
          const SizedBox(height: 16),
          _buildCategoryDistribution(),
          const SizedBox(height: 32),
          _buildExpenseCardsGrid(),
        ],
      ),
    );
  }

  Widget _buildBudgetHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Budget Statistics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: model.selectedTimeFrame,
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
        const Text(
          'Your weekly expenses',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
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
