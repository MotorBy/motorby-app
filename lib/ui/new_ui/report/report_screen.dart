import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_selector_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'report_viewmodel.dart';
import 'expenditure_report_view.dart';
import 'mileage_report_view.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportViewModel>.reactive(
      viewModelBuilder: () => ReportViewModel(),
      onViewModelReady: (model) => model.setBudgetData(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: XColors.background(),
        appBar: appBarHeader(
          hasOnBack: false,
          context: context,
          appBarTitle: 'Report',
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CarSelectorView(
                    cars: model.getBudgetData(),
                    currentCar: model.getCurrentCar() != null ? '${model.getCurrentCar()!.carMake} ${model.getCurrentCar()!.carModel} ${model.getCurrentCar()!.carYear}' : null,
                    onCarSelected: ({Budget? budget, int? index}) {
                      model.setBudgetData(currentIndex: index!);
                    }
                ),
              ),
              const YMargin(14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildTabSelector(model),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: model.selectedTab == 0
                    ? ExpenditureReportView(model: model, ctxt: context,)
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
        color: const Color(0XFFF4EFFB),
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
