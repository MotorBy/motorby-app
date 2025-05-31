import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_auto_drive/ui/home/history_screen.dart';
import 'package:mobile_auto_drive/ui/home/info_details_action/info_details_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/search_address_map.dart';
import 'package:mobile_auto_drive/utils/circular_paint.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/snackbar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class InfoDetailsView extends StatelessWidget {

  const InfoDetailsView({
    super.key,
    this.infoType = InfoType.empty,
    this.infoDetailsViewModel,
    this.currentIndex,
    this.onHistoryNav,
    this.onBudgetAction,
    this.onPermissionAction
  });

  final InfoType? infoType;
  final int? currentIndex;
  final Function? onHistoryNav;
  final Function? onBudgetAction;
  final Function? onPermissionAction;

  final InfoDetailsViewModel? infoDetailsViewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InfoDetailsViewModel>.reactive(
        viewModelBuilder: () => infoDetailsViewModel ?? InfoDetailsViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) => model.initializeTotalCostingAndValue(),
        builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if(infoType == InfoType.empty || infoType == InfoType.fueling) ... [

                FuelBudgetView(
                  infoType: infoType,
                  infoDetailsViewModel: viewModel,
                  onBudgetAction: onBudgetAction,
                )

              ] else if(infoType == InfoType.servicing || infoType == InfoType.repairing) ... [

                ServiceRepairBudgetView(
                  infoType: infoType,
                  infoDetailsViewModel: viewModel,
                  onBudgetAction: onBudgetAction,
                ),

              ] else if(infoType == InfoType.mileage) ... [

                MileageInputView(
                  infoType: infoType,
                  infoDetailsViewModel: viewModel,
                  currentIndex: currentIndex,
                  onBudgetAction: onBudgetAction,
                ),

              ] else if(infoType == InfoType.breakdown) ... [

                BreakdownInputView(
                  infoType: infoType,
                  infoDetailsViewModel: viewModel,
                  currentIndex: currentIndex,
                  onBudgetAction: onBudgetAction,
                ),

              ] else if(infoType == InfoType.fuelUpdate) ... [

                FuelPricingInputView(
                  infoDetailsViewModel: viewModel,
                  onBudgetAction: onBudgetAction,
                ),

              ] else if(infoType == InfoType.weatherView) ... [

                WeatherInfoView(
                  infoDetailsViewModel: viewModel,
                ),

              ] else if(infoType == InfoType.locationSetup) ... [

                PermissionLocationGuide(
                  infoDetailsViewModel: viewModel,
                  onPermissionAction: onPermissionAction,
                ),

              ] else if(infoType == InfoType.budgeting) ... [

                BudgetingInfoView(
                  infoDetailsViewModel: viewModel,
                  currentIndex: currentIndex,
                  onBudgetAction: onBudgetAction,
                )

              ] else if(infoType == InfoType.reminder) ... [

                ReminderInputView(
                  infoDetailsViewModel: viewModel,
                  onBudgetAction: onBudgetAction,
                )

              ]
            ],
          ),
        );
      }
    );
  }

}

class FuelBudgetView extends ViewModelWidget<InfoDetailsViewModel> {
  const FuelBudgetView({
    super.key,
    this.infoDetailsViewModel,
    this.infoType = InfoType.fueling,
    this.onBudgetAction
  });

  final InfoDetailsViewModel? infoDetailsViewModel;
  final InfoType? infoType;
  final Function? onBudgetAction;

  @override
  Widget build(BuildContext context, InfoDetailsViewModel viewModel) {
    return Column(
      children: [
        const YMargin(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                navigate(context, HistoryScreen(
                  infoDetailsViewModel: viewModel,
                  budgetHistoryType: "Fueling",
                ));
              },
              child: NormalText(
                text: 'View History',
                textColor: XColors.textColor(),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const XMargin(45),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.close_rounded, size: 31,),
            ),
          ],
        ),
        const YMargin(20),
        Row(
          children: [
            NormalText(
              text: infoType!.toValue().toUpperCase(),
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ],
        ),
        const YMargin(35),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              text:'Fuel bought on: ${viewModel.date}',
              textColor: XColors.textColor(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const YMargin(15),
            GestureDetector(
              onTap: () async {

                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchAddressMap(
                      viewModel: null,
                    ),
                  ),
                );

                if(result != null) {

                  viewModel.updateCurrentInputAddress(
                      address: result,
                      addressType: 'gas_station'
                  );

                }

              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: XColors.highlightColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: XColors.primaryColor()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        viewModel.addressInput['address'] ?? 'Enter gas station location',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const YMargin(15),
            MainInputField(
              controller: viewModel.amountInputController,
              label: "Amount",
              keyboard: TextInputType.number,
              isEnabled: true,
              onChanged: (s){
                viewModel.updateBudgetData(value: s, type: 'amount');
              },
            ),
            const YMargin(15),
            MainInputField(
              controller: viewModel.dateInputController,
              label: "Date",
              isEnabled: false,
              suffixIcon: GestureDetector(
                onTap: () async {
                  DateTime? startPickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 10),
                      lastDate: DateTime(DateTime.now().year + 10));
                  String formattedDate =
                      '${startPickedDate!.day}-${startPickedDate.month}-${startPickedDate.year}';
                  viewModel.date = formattedDate;
                  viewModel.updateBudgetData(value: viewModel.date, type: 'date');
                },
                child: const Icon(Icons.calendar_month_rounded, size: 21,),
              ),
            ),
            const YMargin(15),
            MainInputField(
              controller: viewModel.priceInputController,
              label: "Price/liter",
              keyboard: TextInputType.number,
              isEnabled: true,
              onChanged: (s){
                viewModel.updateBudgetData(value: s, type: 'price_per_liter');
              },
            ),
          ],
        ),
        const YMargin(35),
        XButton(
          onPressed: !viewModel.isBusy ? () {

            if(viewModel.priceInputController.text.isNotEmpty &&
                viewModel.amountInputController.text.isNotEmpty &&
                viewModel.dateInputController.text.isNotEmpty &&
                viewModel.addressInput['address'] != null) {

              viewModel.updateToBudget(
                  type: infoType!.toValue().toString(),
                  onCallBack: () {
                    popView(context);
                    onBudgetAction!.call();
                  }
              );

            } else {

              FloatingSnackBar.show(
                  context,
                  'Make sure all inputs are complete',
                  isError: true
              );

            }

          } : (){},
          text: "Add",
          height: 56,
          textColor: Colors.white,
          isLoading: viewModel.isBusy,
          buttonColor: XColors.primaryColor(),
          progressColor: Colors.white,
          radius: 26,
          width: SizeConfig().sw(400) as double?,
        ),
        const YMargin(15),
      ],
    );
  }

}

class ServiceRepairBudgetView extends ViewModelWidget<InfoDetailsViewModel> {
  const ServiceRepairBudgetView({
    super.key,
    this.infoDetailsViewModel,
    this.infoType = InfoType.servicing,
    this.onBudgetAction
  });

  final InfoDetailsViewModel? infoDetailsViewModel;
  final InfoType? infoType;
  final Function? onBudgetAction;

  @override
  Widget build(BuildContext context, InfoDetailsViewModel viewModel) {
    return Column(
      children: [
        const YMargin(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {

                navigate(context, HistoryScreen(
                  infoDetailsViewModel: viewModel,
                  budgetHistoryType: infoType == InfoType.servicing ? "Servicing" : "Repairing",
                ));

              },
              child: NormalText(
                text: 'View History',
                textColor: XColors.textColor(),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const XMargin(45),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.close_rounded, size: 31,),
            ),
          ],
        ),
        const YMargin(20),
        Row(
          children: [
            NormalText(
              text: infoType!.toValue().toUpperCase(),
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w700,
              fontSize: 23,
            ),
          ],
        ),
        const YMargin(35),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const YMargin(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      text:'Date: ${viewModel.date}',
                      textColor: XColors.textColor(),
                      fontSize: 15,
                    ),
                  ],
                ),
              ],
            ),
            const YMargin(15),
            MainInputField(
              label: "problem",
              controller: viewModel.problemInputController,
              isEnabled: true,
              onChanged: (s){
                viewModel.updateBudgetData(value: s, type: 'problem');
              },
            ),
            const YMargin(15),
            GestureDetector(
              onTap: () {
                listHelperPicker(
                  context: context,
                  title: "Select Damage Severity",
                  listString: ["Minor", "Moderate", "Major", "None"],
                  selected: (value) {
                    viewModel.updateBudgetData(otherData: {
                      "severity" : value
                    });
                  }
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: XColors.highlightColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: XColors.primaryColor()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Select damage severity ${viewModel.budgetData['severity'] != null ? ' (${viewModel.budgetData['severity']})' : ""}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const YMargin(15),
            GestureDetector(
              onTap: () {
                listHelperPicker(
                  context: context,
                  title: "Rate Post-Service Improvement",
                  listString: ["Good", "Better", "Best"],
                  selected: (value) {
                    viewModel.updateBudgetData(otherData: {
                      "improvement" : value
                    });
                  }
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: XColors.highlightColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: XColors.primaryColor()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Rate service improvement ${viewModel.budgetData['improvement'] != null ? ' (${viewModel.budgetData['improvement']})' : ""}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const YMargin(15),
            GestureDetector(
              onTap: () async {

                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchAddressMap(
                      viewModel: null,
                    ),
                  ),
                );

                if(result != null) {

                  viewModel.updateCurrentInputAddress(
                      address: result,
                      addressType: infoType == InfoType.servicing ? 'service_shop' : 'repair_shop'
                  );

                }

              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: XColors.highlightColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: XColors.primaryColor()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        viewModel.addressInput['address'] ?? (infoType == InfoType.servicing ? 'Enter service shop location' : 'Enter repair shop location'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const YMargin(15),
            MainInputField(
              label: "Amount",
              controller: viewModel.amountInputController,
              keyboard: TextInputType.number,
              onChanged: (s){
                viewModel.updateBudgetData(value: s, type: 'amount');
              },
              isEnabled: true,
            ),
            const YMargin(15),
            MainInputField(
              controller: viewModel.addressInputController,
              label: infoType == InfoType.servicing ?  "Date of servicing" : "Date of repair",
              //isEnabled: false,
              onChanged: (s) {
                viewModel.updateBudgetData(value: s, type: 'location');
              },
              suffixIcon: GestureDetector(
                child: Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          DateTime? startPickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 10),
                              lastDate: DateTime(DateTime.now().year + 10));
                          String formattedDate =
                              '${startPickedDate!.day}-${startPickedDate.month}-${startPickedDate.year}';
                          viewModel.date = formattedDate;
                          viewModel.updateBudgetData(value: viewModel.date, type: 'date');
                        },
                        child: Icon(Icons.calendar_month_rounded, size: 21, color: XColors.textColor(),),
                      ),
                      const XMargin(10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const YMargin(35),
        XButton(
          onPressed: !viewModel.isBusy ? () {

            if(viewModel.problemInputController.text.isNotEmpty &&
                viewModel.amountInputController.text.isNotEmpty &&
                viewModel.dateInputController.text.isNotEmpty &&
                viewModel.addressInput['address'] != null) {

              viewModel.updateToBudget(
                  type: infoType!.toValue(),
                  onCallBack: (){
                    popView(context);
                    onBudgetAction!.call();
                  }
              );

            } else {

              FloatingSnackBar.show(
                  context,
                  'Make sure all inputs are complete',
                  isError: true
              );

            }

          } : (){},
          text: "Add",
          height: 56,
          textColor: Colors.white,
          buttonColor: XColors.primaryColor(),
          progressColor: Colors.white,
          isLoading: viewModel.isBusy,
          radius: 26,
          width: SizeConfig().sw(400) as double?,
        ),
        const YMargin(15),
      ],);
  }

}

class ReminderInputView extends ViewModelWidget<InfoDetailsViewModel> {
  const ReminderInputView({
    super.key,
    this.infoDetailsViewModel,
    this.onBudgetAction
  });

  final InfoDetailsViewModel? infoDetailsViewModel;
  final Function? onBudgetAction;

  @override
  Widget build(BuildContext context, InfoDetailsViewModel viewModel) {
    return Column(
      children: [
        const YMargin(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const XMargin(45),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.close_rounded, size: 31,),
            ),
          ],
        ),
        const YMargin(20),
        Row(
          children: [
            NormalText(
              text: 'CUSTOM REMINDER',
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ],
        ),
        const YMargin(35),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                listHelperPicker(
                  context: context,
                  title: "Select Reminder Category",
                  listString: ["Maintenance", "Changes", "Repairs", "Budget", "Trips", "Breakdown", "Fueling", "Service", "Insurance", "Other"],
                  selected: (value) {
                    viewModel.updateBudgetData(otherData: {
                      "category" : value
                    });
                  }
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: XColors.highlightColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.category, color: XColors.primaryColor()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        viewModel.budgetData['category'] ?? 'Select reminder category',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const YMargin(15),
            MainInputField(
              controller: viewModel.titleInputController,
              label: "Reminder Title",
              isEnabled: true,
              onChanged: (s){
                viewModel.updateBudgetData(otherData: {
                  "title" : s
                });
              },
            ),
            const YMargin(15),
            MainInputField(
              controller: viewModel.descriptionInputController,
              label: "Description",
              maxLines: 3,
              isEnabled: true,
              onChanged: (s){
                viewModel.updateBudgetData(otherData: {
                  "description" : s
                });
              },
            ),
            const YMargin(15),
            MainInputField(
              controller: viewModel.dateInputController,
              label: "Date & Time",
              isEnabled: false,
              suffixIcon: Container(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        DateTime? startPickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 10));
                        if (startPickedDate != null) {
                          final isoString = startPickedDate.toUtc().toIso8601String();
                          final displayDate = '${startPickedDate.year}-${startPickedDate.month.toString().padLeft(2, '0')}-${startPickedDate.day.toString().padLeft(2, '0')}';
                          viewModel.date = displayDate;
                          viewModel.updateBudgetData(otherData: {
                            "due_date" : isoString
                          });
                          final dueTime = viewModel.budgetData['due_time'] ?? '';
                          final formattedDateTime = '$displayDate${dueTime.isNotEmpty ? ', $dueTime' : ''}';
                          viewModel.dateInputController.text = formattedDateTime;
                        }
                      },
                      child: Icon(Icons.calendar_month_rounded, size: 21, color: XColors.textColor()),
                    ),
                    const XMargin(30),
                    GestureDetector(
                      onTap: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          final displayTime = selectedTime.format(context);
                          if (viewModel.budgetData['due_date'] != null) {
                            final dueDate = DateTime.parse(viewModel.budgetData['due_date']);
                            final combinedDateTime = DateTime(
                              dueDate.year,
                              dueDate.month,
                              dueDate.day,
                              selectedTime.hour,
                              selectedTime.minute
                            );
                            final isoString = combinedDateTime.toUtc().toIso8601String();
                            viewModel.updateBudgetData(otherData: {
                              "due_date": dueDate.toIso8601String(),
                              "due_time": displayTime
                            });
                            final formattedDateTime = '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}, $displayTime';
                            viewModel.dateInputController.text = formattedDateTime;
                          }
                        }
                      },
                      child: Icon(Icons.access_time_rounded, size: 21, color: XColors.textColor()),
                    ),
                  ],
                ),
              ),
            ),
            const YMargin(15),
            GestureDetector(
              onTap: () {
                listHelperPicker(
                  context: context,
                  title: "Select Reminder Frequency",
                  listString: ["Daily", "Weekly", "Monthly"],
                  selected: (value) {
                    viewModel.updateBudgetData(otherData: {
                      "frequency" : value
                    });
                  }
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: XColors.highlightColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.repeat, color: XColors.primaryColor()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Select reminder frequency ${viewModel.budgetData['frequency'] != null ? ' (${viewModel.budgetData['frequency']})' : ""}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const YMargin(35),
        XButton(
          onPressed: !viewModel.isBusy ? () {
            if(viewModel.titleInputController.text.isNotEmpty &&
                viewModel.descriptionInputController.text.isNotEmpty &&
                viewModel.dateInputController.text.isNotEmpty &&
                viewModel.budgetData['frequency'] != null &&
                viewModel.budgetData['category'] != null) {

              viewModel.createReminder(
                  budgetId: null,
                  title: viewModel.titleInputController.text,
                  description: viewModel.descriptionInputController.text,
                  dueDate: viewModel.budgetData['due_date'],
                  dueTime: viewModel.budgetData['due_time'],
                  frequency: viewModel.budgetData['frequency'].toLowerCase(),
                  category: viewModel.budgetData['category'],
                  onCallBack: (){
                    popView(context);
                    onBudgetAction!.call();
                  },
                  onErrorCallBack: (e) {
                      FloatingSnackBar.show(
                        context,
                        e,
                        isError: true
                    );
                  }
              );

            } else {
              FloatingSnackBar.show(
                  context,
                  'Make sure all inputs are complete',
                  isError: true
              );
            }
          } : (){},
          text: "Set Reminder",
          height: 56,
          textColor: Colors.white,
          buttonColor: XColors.primaryColor(),
          progressColor: Colors.white,
          isLoading: viewModel.isBusy,
          radius: 26,
          width: SizeConfig().sw(400) as double?,
        ),
        const YMargin(15),
      ],
    );
  }
}

class MileageInputView extends ViewModelWidget<InfoDetailsViewModel> {
  const MileageInputView({
    super.key,
    this.infoDetailsViewModel,
    this.infoType = InfoType.mileage,
    this.currentIndex,
    this.onBudgetAction
  });

  final InfoDetailsViewModel? infoDetailsViewModel;
  final InfoType? infoType;
  final int? currentIndex;
  final Function? onBudgetAction;

  @override
  Widget build(BuildContext context, InfoDetailsViewModel viewModel) {
    return Column(
      children: [
        const YMargin(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {

                navigate(context, HistoryScreen(
                  infoDetailsViewModel: viewModel,
                  budgetHistoryType: 'Mileage',
                ));

              },
              child: NormalText(
                text: 'View History',
                textColor: XColors.textColor(),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const XMargin(45),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.close_rounded, size: 31,),
            ),
          ],
        ),
        const YMargin(15),
        Row(
          children: [
            NormalText(
              text: infoType!.toValue().toUpperCase(),
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ],
        ),
        const YMargin(35),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const YMargin(15),
            GestureDetector(
              onTap: () async {

                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchAddressMap(
                      viewModel: null,
                    ),
                  ),
                );

                if(result != null) {

                  viewModel.updateCurrentInputAddress(
                      address: result,
                      addressType: 'mileage'
                  );

                }

              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: XColors.highlightColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: XColors.primaryColor()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        viewModel.addressInput['address'] ?? ('Enter current destination address'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const YMargin(15),
            const YMargin(15),
            const NormalText(
              text: 'Current fuel gauge',
              textColor: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            const YMargin(10),
            Row(
              children: [
                Radio<String>(
                  value: 'full',
                  groupValue: viewModel.budgetData['current_fuel_gauge'] ?? '',
                  onChanged: (value) {
                    viewModel.updateBudgetData(otherData: {
                      'current_fuel_gauge': value
                    });
                  },
                ),
                const Text('Full'),
                const XMargin(20),
                Radio<String>(
                  value: 'mid',
                  groupValue: viewModel.budgetData['current_fuel_gauge'] ?? '',
                  onChanged: (value) {
                    viewModel.updateBudgetData(otherData: {
                      'current_fuel_gauge': value
                    });
                  },
                ),
                const Text('Mid'),
                const XMargin(20),
                Radio<String>(
                  value: 'empty',
                  groupValue: viewModel.budgetData['current_fuel_gauge'] ?? '',
                  onChanged: (value) {
                    viewModel.updateBudgetData(otherData: {
                      'current_fuel_gauge': value
                    });
                  },
                ),
                const Text('Empty'),
              ],
            ),
            const YMargin(15),
            MainInputField(
              label: "Odometer reading",
              keyboard: TextInputType.number,
              controller: viewModel.milesInputController,
              isEnabled: true,
              onChanged: (s){
                viewModel.updateBudgetData(value: s, type: 'miles');
              },
            ),
          ],
        ),
        const YMargin(35),
        XButton(
          onPressed: !viewModel.isBusy ? () {
            viewModel.updateToBudget(
                type: infoType!.toValue(),
                onCallBack: (){
                  popView(context);
                  onBudgetAction!.call();
                }
            );
          } : (){},
          text: "Update",
          height: 56,
          textColor: Colors.white,
          buttonColor: XColors.primaryColor(),
          progressColor: Colors.white,
          isLoading: viewModel.isBusy,
          radius: 26,
          width: SizeConfig().sw(400) as double?,
        ),
        const YMargin(15),
      ],);
  }

}

class BreakdownInputView extends ViewModelWidget<InfoDetailsViewModel> {
  const BreakdownInputView({
    super.key,
    this.infoDetailsViewModel,
    this.infoType = InfoType.breakdown,
    this.currentIndex,
    this.onBudgetAction
  });

  final InfoDetailsViewModel? infoDetailsViewModel;
  final InfoType? infoType;
  final int? currentIndex;
  final Function? onBudgetAction;

  @override
  Widget build(BuildContext context, InfoDetailsViewModel viewModel) {
    return Column(
      children: [
        const YMargin(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                navigate(context, HistoryScreen(
                  infoDetailsViewModel: viewModel,
                  budgetHistoryType: "Breakdown",
                ));
              },
              child: NormalText(
                text: 'View History',
                textColor: XColors.textColor(),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const XMargin(45),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.close_rounded, size: 31,),
            ),
          ],
        ),
        const YMargin(20),
        Row(
          children: [
            NormalText(
              text: infoType!.toValue().toUpperCase(),
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ],
        ),
        const YMargin(5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NormalText(
              text:'You have total of ',
              textColor: XColors.textColor(),
              fontSize: 15,
            ),
            NormalText(
              text:viewModel.totalCostingAndValue![currentIndex!].toString(),
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            NormalText(
              text:' breakdowns',
              textColor: XColors.textColor(),
              fontSize: 15,
            ),
          ],
        ),
        const YMargin(35),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      text:'Breakdown occurred on : ${viewModel.date}',
                      textColor: XColors.textColor(),
                      fontSize: 15,
                    ),
                  ],
                ),
              ],
            ),
            const YMargin(15),
            MainInputField(
              label: "Cause",
              controller: viewModel.problemInputController,
              isEnabled: true,
              onChanged: (s){
                viewModel.updateBudgetData(value: s, type: 'cause');
              },
            ),
            const YMargin(15),
            MainInputField(
              controller: viewModel.addressInputController,
              label: "Place fixed",
              isEnabled: true,
              onChanged: (s) {
                viewModel.updateBudgetData(value: s, type: 'break_down');
              },
              suffixIcon: GestureDetector(
                child: Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.location_on_rounded, size: 21, color: XColors.textColor(),),
                      const XMargin(20),
                      GestureDetector(
                        onTap: () async {
                          DateTime? startPickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 10),
                              lastDate: DateTime(DateTime.now().year + 10));
                          String formattedDate =
                              '${startPickedDate!.day}-${startPickedDate.month}-${startPickedDate.year}';
                          viewModel.date = formattedDate;
                          viewModel.updateBudgetData(value: viewModel.date, type: 'date');
                        },
                        child: Icon(Icons.calendar_month_rounded, size: 21, color: XColors.textColor(),),
                      ),
                      const XMargin(10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const YMargin(35),
        XButton(
          onPressed: !viewModel.isBusy ? () {

            if(viewModel.problemInputController.text.isNotEmpty &&
                viewModel.dateInputController.text.isNotEmpty) {

              viewModel.updateToBudget(
                  type: infoType!.toValue(),
                  onCallBack: (){
                    popView(context);
                    showSnackBar(
                        context: context,
                        message: 'Successfully updated into your budget'
                    );
                  }
              );

            } else {

            }

          } : (){},
          text: "Add",
          height: 56,
          textColor: Colors.white,
          buttonColor: XColors.primaryColor(),
          progressColor: Colors.white,
          isLoading: viewModel.isBusy,
          radius: 26,
          width: SizeConfig().sw(400) as double?,
        ),
        const YMargin(15),
      ],
    );
  }

}

class FuelPricingInputView extends ViewModelWidget<InfoDetailsViewModel> {

  const FuelPricingInputView({
    super.key,
    this.infoDetailsViewModel,
    this.onBudgetAction
  });

  final InfoDetailsViewModel? infoDetailsViewModel;
  final Function? onBudgetAction;

  @override
  Widget build(BuildContext context, InfoDetailsViewModel viewModel) {
    return Column(
      children: [
        const YMargin(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const XMargin(45),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.close_rounded, size: 31,),
            ),
          ],
        ),
        const YMargin(20),
        Column(
          children: [
            NormalText(
              text:'Current fuel price in your city:',
              textColor: XColors.textColor(),
              fontSize: 13,
            ),
            NormalText(
              text: 'N${viewModel.currentFuelPrice}/ltr',
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w700,
              fontSize: 23,
            ),
          ],
        ),
        const YMargin(35),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              text:'You can update the fuel price in your city from any close petrol station around you and earn points. Make sure the price must be reasonably similar',
              textAlign: TextAlign.center,
              textColor: XColors.textColor(),
              fontSize: 13,
            ),
            const YMargin(55),
            GestureDetector(
              onTap: () async {

                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchAddressMap(
                      viewModel: null,
                    ),
                  ),
                );

                if(result != null) {
                  viewModel.updateCurrentInputAddress(
                      address: result,
                  );
                }

              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: XColors.highlightColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: XColors.primaryColor()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        viewModel.addressInput['address'] ?? ('Enter current gas station location'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const YMargin(15),
            MainInputField(
              controller: viewModel.priceInputController,
              label: "Price/liter",
              keyboard: TextInputType.number,
              isEnabled: true,
            ),
            const YMargin(15),
          ],
        ),
        const YMargin(35),
        XButton(
          onPressed: !viewModel.isBusy ? () {

            if(viewModel.priceInputController.text.isNotEmpty && viewModel.addressInput["address"] != null) {

              viewModel.updateCurrentFuelPrice(
                  petrolStation: viewModel.addressInput["address"],
                  city: viewModel.cityInputController.text,
                  lat: viewModel.addressInput["lat"],
                  lng: viewModel.addressInput["lng"],
                  state: viewModel.addressInput["state"],
                  price: int.parse(viewModel.priceInputController.text),
                  onCallBack: () {
                    popView(context);
                    showSnackBar(
                        context: context,
                        message: 'Successfully updated fuel price in ${viewModel.cityInputController.text} at ${viewModel.priceInputController.text}'
                    );
                  },
                  onErrorCallBack: (e) {

                  }
              );

            } else {

              FloatingSnackBar.show(
                  context,
                  'Make sure all inputs are complete',
                  isError: true
              );

            }

          } : (){},
          text: "Update",
          height: 56,
          textColor: Colors.white,
          isLoading: viewModel.isBusy,
          buttonColor: XColors.primaryColor(),
          progressColor: Colors.white,
          radius: 26,
          width: SizeConfig().sw(400) as double?,
        ),
        const YMargin(15),
      ],);
  }

}

class PermissionLocationGuide extends ViewModelWidget<InfoDetailsViewModel> {
  const PermissionLocationGuide({
    super.key,
    this.infoDetailsViewModel,
    this.onPermissionAction
  });

  final InfoDetailsViewModel? infoDetailsViewModel;
  final Function? onPermissionAction;

  @override
  Widget build(BuildContext context, InfoDetailsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const YMargin(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            NormalText(
              text: 'Close',
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            const XMargin(5),
            GestureDetector(
              onTap: (){
                viewModel.promoteLocationPermission(willDecline: true);
                Navigator.pop(context);
              },
              child: const Icon(Icons.close_rounded, size: 31,),
            ),
          ],
        ),
        const YMargin(20),
        Container(
            width: 65,
            height: 65,
            child: Image.asset('assets/images/icons/location-map.png'
            )
        ),
        Row(
          children: [
            NormalText(
              text: 'Location Permission',
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w700,
              fontSize: 23,
            ),
          ],
        ),
        const YMargin(25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              text: viewModel.permissionLocationStatement,
              textColor: XColors.textColor(),
              maxLines: 5,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ],
        ),
        const YMargin(35),
        XButton(
          onPressed: () {
            popView(context);
            viewModel.promoteLocationPermission();
            onPermissionAction?.call();
          },
          text: "Continue",
          height: 56,
          textColor: Colors.white,
          buttonColor: XColors.primaryColor(),
          progressColor: Colors.white,
          isLoading: viewModel.isBusy,
          radius: 26,
          width: SizeConfig().sw(400) as double?,
        ),
        const YMargin(15),
      ],
    );
  }

}

class WeatherInfoView extends ViewModelWidget<InfoDetailsViewModel> {
  const WeatherInfoView({
    super.key,
    this.infoDetailsViewModel,
  });

  final InfoDetailsViewModel? infoDetailsViewModel;

  @override
  Widget build(BuildContext context, InfoDetailsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const YMargin(20),
        Container(
            width: 65,
            height: 65,
            child: Image.asset('assets/images/icons/weather-icon.png'
            )
        ),
        const YMargin(25),
        NormalText(
          text: 'Current Weather Info',
          textColor: XColors.textColor(),
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        NormalText(
          text: '${viewModel.currentWeatherDescription}',
          textColor: XColors.textColor().withOpacity(0.2),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        const YMargin(15),
        NormalText(
          text: '${viewModel.currentWeatherValue} \u2103',
          textColor: XColors.textColor(),
          fontWeight: FontWeight.w700,
          fontSize: 26,
        ),
        const YMargin(25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              text: viewModel.weatherGuideDescription,
              textColor: XColors.textColor(),
              maxLines: 5,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ],
        ),
        const YMargin(35),
        XButton(
          onPressed: (){
            popView(context);
          },
          text: "Close",
          height: 56,
          textColor: Colors.white,
          buttonColor: XColors.primaryColor(),
          progressColor: Colors.white,
          isLoading: viewModel.isBusy,
          radius: 26,
          width: SizeConfig().sw(400) as double?,
        ),
        const YMargin(15),
      ],
    );
  }

}

class BudgetingInfoView extends ViewModelWidget<InfoDetailsViewModel> {
  const BudgetingInfoView({
    super.key,
    this.infoDetailsViewModel,
    this.infoType = InfoType.budgeting,
    this.currentIndex,
    this.onBudgetAction
  });

  final InfoDetailsViewModel? infoDetailsViewModel;
  final Function? onBudgetAction;
  final InfoType? infoType;
  final int? currentIndex;

  @override
  Widget build(BuildContext context, InfoDetailsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const YMargin(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.close_rounded, size: 31,),
            ),
          ],
        ),
        const YMargin(5),
        Row(
          children: [
            NormalText(
              text: 'Budget Info',
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w700,
              fontSize: 23,
            ),
          ],
        ),
        const YMargin(35),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              text:'Current budget for:',
              textColor: XColors.textColor(),
              fontSize: 13,
            ),
            NormalText(
              text: viewModel.budgetingModel!.budget![currentIndex!].carName,
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ],
        ),
        const YMargin(55),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalText(
                  text:'Spent: ',
                  textColor: XColors.textColor().withOpacity(0.6),
                  fontSize: 11,
                ),
                NormalText(
                  text: '₦${amtFormatter(viewModel.currentTotalSpent!)}',
                  textColor: XColors.textColor(),
                  fontWeight: FontWeight.w700,
                  fontSize: 21,
                ),
                const YMargin(35),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      text:'from total of: ',
                      textColor: XColors.textColor().withOpacity(0.6),
                      fontSize: 11,
                    ),
                    NormalText(
                      text: '₦${amtFormatter(viewModel.currentSetBudget)}',
                      textColor: XColors.textColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 100,
              width: 100,
              color: Colors.white,
              child: CustomPaint(
                painter: CircularPaint(
                    bgColor: XColors.textColor().withOpacity(0.1),
                    width: 15,
                    lineColor: viewModel.currentTotalSpent!/viewModel.currentSetBudget > 0.6 ? Colors.red : XColors.primaryColor(),
                    percent: viewModel.currentSetBudget != 0 ? (viewModel.currentTotalSpent!/viewModel.currentSetBudget) : 0
                ),
                child: Center(
                  child: NormalText(
                    text:'${viewModel.currentSetBudget != 0 ? ((viewModel.currentTotalSpent!/viewModel.currentSetBudget) * 100).toInt() : 0}%',
                    fontWeight: FontWeight.w700,
                    textColor: XColors.textColor(),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
        const YMargin(45),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                NormalText(
                  text: viewModel.budgetInputController.text.isNotEmpty ? 'Your budget will be increased to  ' : 'Increase your budget of  ',
                  textColor: XColors.textColor(),
                  fontSize: 13,
                ),
                NormalText(
                  text:"₦${amtFormatter(viewModel.currentSetBudget + int.parse(viewModel.budgetInputController.text.isEmpty ? '0' : viewModel.budgetInputController.text))}",
                  textColor: XColors.textColor(),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            const YMargin(15),
            MainInputField(
              label: "Increase budget",
              keyboard: TextInputType.number,
              controller: viewModel.budgetInputController,
              isEnabled: true,
              onChanged: (s){
                viewModel.updateBudgetData(value: s, type: 'budgeting');
              },
            ),
          ],
        ),
        const YMargin(35),
        XButton(
          onPressed: !viewModel.isBusy ? () {
            viewModel.updateToBudget(
                type: 'budgeting',
                onCallBack: () {

                  popView(context);
                  onBudgetAction!.call();

                  if(viewModel.milesInputController.text.isNotEmpty) {

                    popView(context);
                    showSnackBar(
                        context: context,
                        message: 'Successfully updated into your budget'
                    );

                  } else {

                  }

                }
            );
          } : (){},
          text: "Update",
          height: 56,
          textColor: Colors.white,
          buttonColor: XColors.primaryColor(),
          progressColor: Colors.white,
          isLoading: viewModel.isBusy,
          radius: 26,
          width: SizeConfig().sw(400) as double?,
        ),
        const YMargin(15),
      ],);
  }

}