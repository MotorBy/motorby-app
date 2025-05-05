import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_auto_drive/ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'maintenance':
        return Icons.build;
      case 'changes':
        return Icons.swap_horiz;
      case 'repairs':
        return Icons.build_circle;
      case 'budget':
        return Icons.account_balance_wallet;
      case 'trips':
        return Icons.directions_car;
      case 'breakdown':
        return Icons.car_repair;
      case 'fueling':
        return Icons.local_gas_station;
      case 'service':
        return Icons.miscellaneous_services;
      case 'insurance':
        return Icons.security;
      default:
        return Icons.more_horiz;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReminderViewModel>.reactive(
        viewModelBuilder: () => ReminderViewModel(),
        onViewModelReady: (model) => model.initialize(),
        builder: (context, model, child) {

          if (model.isBusy) {
            return const Center(child: Loader());
          }

          if (model.hasError) {
            return Center(child: Text(model.error.toString()));
          }

          if (model.reminders.isEmpty) {
            return Scaffold(
              backgroundColor: XColors.background(),
                appBar: appBarHeader(
                    hasOnBack: false,
                    context: context,
                    appBarTitle: 'Reminder',
                    centerTitle: false,
                    actions: [

                      GestureDetector(
                        onTap: () {

                          modalBottomSheetMenu(
                            color: Colors.white,
                            isDismissible: false,
                            context: context,
                            height: 700,
                            child: InfoDetailsView(
                              infoType: InfoType.reminder,
                              onBudgetAction: () {
                                model.initialize();
                              },
                            ),
                          );

                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 2,
                            radius: 26,
                            outlineColor:
                            XColors.primaryColor(),
                          ),
                          child: NormalText(
                            text: 'Create Reminder',
                            textColor: XColors.textColor(),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const XMargin(10),
                    ]
                ),
                body: const Center(child: Text('No reminders found')
                )
            );
          }

          return Scaffold(
            backgroundColor: XColors.background(),
            appBar: appBarHeader(
            hasOnBack: false,
            context: context,
            appBarTitle: 'Reminder',
            centerTitle: false,
            actions: [

              GestureDetector(
                onTap: () {

                  modalBottomSheetMenu(
                    color: Colors.white,
                    isDismissible: false,
                    context: context,
                    height: 700,
                    child: InfoDetailsView(
                      infoType: InfoType.reminder,
                      onBudgetAction: () {
                        model.initialize();
                      },
                    ),
                  );

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecorators.containerDecoration(
                    hasOutline: true,
                    outlineWidth: 2,
                    radius: 26,
                    outlineColor:
                    XColors.primaryColor(),
                  ),
                  child: NormalText(
                    text: 'Create Reminder',
                    textColor: XColors.textColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              const XMargin(10),
            ]
          ),
          body: ContainerWidget(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            borderRadius: BorderRadius.circular(16),
            backgroundColor: XColors.white(),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ...List.generate(model.reminders.length, (index) {
                    final reminder = model.reminders[index];
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {},
                          leading: Icon(
                            _getCategoryIcon(reminder.metadata?.category ?? ''),
                            color: XColors.primaryColor(),
                            size: 20,
                          ),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(horizontal: -4),
                          title: NormalText(
                            text: reminder.title ?? '',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textColor: XColors.black(),
                          ),
                          subtitle: NormalText(
                            text: reminder.description ?? '',
                            fontSize: 13,
                            textColor: XColors.textColor().withOpacity(0.6),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              NormalText(
                                text: reminder.dueTime != null
                                    ? DateFormat('h:mm a').format(reminder.dueTime!)
                                    : '--:--',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              NormalText(
                                text: reminder.dueDate != null
                                    ? DateFormat('dd/MM/yyyy').format(reminder.dueDate!)
                                    : '--/--/----',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                        if(model.reminders.length - 1 != index) ... [
                          const DividerWidget(),
                          const YMargin(16),
                        ]
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          );
      }
    );
  }
}