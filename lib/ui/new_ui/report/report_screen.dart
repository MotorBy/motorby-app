import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
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
        backgroundColor: XColors.background(),
        appBar: AppBar(
          title: const NormalText(
            text: 'Report',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: false,
          backgroundColor: Color(0xFFFEF7FF),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DividerWidget(
                margin: EdgeInsets.zero,
              ),
              const YMargin(24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildTabSelector(model),
              ),
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
    );
  }

  Widget _buildTabSelector(ReportViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
      decoration: BoxDecoration(
        color: Color(0XFFF4EFFB),
        
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
          padding: const EdgeInsets.symmetric(vertical: 8),
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
