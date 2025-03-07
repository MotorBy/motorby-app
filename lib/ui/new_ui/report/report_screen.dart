import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'report_viewmodel.dart';
import 'expenditure_report_view.dart';
import 'mileage_report_view.dart';
import 'add_mileage_log_sheet.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportViewModel>.reactive(
      viewModelBuilder: () => ReportViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFFF8F2FF),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: const AddMileageLogSheet(),
              ),
            );
          },
          backgroundColor: const Color(0xFF7B61FF),
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Report',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTabSelector(model),
                const SizedBox(height: 24),
                Expanded(
                  child: model.selectedTab == 0
                      ? ExpenditureReportView(model: model)
                      : MileageReportView(model: model),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector(ReportViewModel model) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTabButton(
            title: 'Expenditure',
            isSelected: model.selectedTab == 0,
            onTap: () => model.setSelectedTab(0),
          ),
          _buildTabButton(
            title: 'Mileage',
            isSelected: model.selectedTab == 1,
            onTap: () => model.setSelectedTab(1),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
