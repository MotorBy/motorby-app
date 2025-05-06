import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/services/checklist_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'checklist_viewmodel.dart';

class ChecklistScreen extends StatelessWidget {
  final String carId;
  const ChecklistScreen({Key? key, required this.carId,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChecklistViewModel>.reactive(
      viewModelBuilder: () => ChecklistViewModel(),
      onViewModelReady: (model) => model.initializeChecklist(carId),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: appBarHeader(
          hasOnBack: true,
          context: context,
          appBarTitle: 'Checklist settings',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: XButton(
              onPressed: viewModel.updatingChecklistItems!.isNotEmpty
                  ? () => viewModel.updateChecklist(
                  carId,
                  onCallBack: () {
                    FloatingSnackBar.show(
                        context,
                        'Checklist updated successfully',
                        isError: false
                    );
                  },
                onErrorCallback: (e) {
                    FloatingSnackBar.show(context, e!);
                }
              ) : null,
              text: 'Update checklist',
              textColor: Colors.white,
              buttonColor: viewModel.updatingChecklistItems!.isNotEmpty ? Colors.deepPurple : Colors.grey,
              isLoading: viewModel.isBusy || viewModel.busy("updatingChecklistItems"),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Set frequency',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          PopupMenuButton<String>(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    viewModel.selectedFrequency,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.keyboard_arrow_down),
                                ],
                              ),
                            ),
                            onSelected: (String value) {
                              viewModel.updateFrequency(carId, value);
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'daily',
                                child: Text('Daily'),
                              ),
                              const PopupMenuItem(
                                value: 'weekly',
                                child: Text('Weekly'),
                              ),
                              const PopupMenuItem(
                                value: 'monthly',
                                child: Text('Monthly'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'You will get reminders ${viewModel.selectedFrequency} for the activated checklist below',
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                if(viewModel.isBusy) ... [

                  const Center(child: Loader())

                ] else ... [

                  // Edit Checklist Section
                  const Text(
                    'Edit checklist',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Update your car checks here',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.checkListDataModel!.payload!.items!.length,
                    separatorBuilder: (context, index) => _buildDivider(),
                    itemBuilder: (context, index) => _buildChecklistItem(
                      context,
                      viewModel,
                      viewModel.checkListDataModel!.payload!.items![index].isChecked!,
                      viewModel.checkListDataModel!.payload!.items![index].item!,
                    ),
                  ),

                  const SizedBox(height: 62),

                ],

              ],
            ),
          ),
        ),
      ),
    );
  }

  ///checklist item build
  Widget _buildChecklistItem(BuildContext context, ChecklistViewModel viewModel, bool key, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Switch(
            value: key,
            onChanged: (value) {
              viewModel.updateChecklistItem(carId, title, value);
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.black12,
      height: 1,
    );
  }
}

class ChecklistScreenDialogue extends StatelessWidget {
  const ChecklistScreenDialogue({Key? key, this.carId, this.homeViewModel}) : super(key: key);

  final String? carId;
  final HomeViewModel? homeViewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => homeViewModel ?? HomeViewModel(),
      disposeViewModel: false,
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                  height: 580,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: NormalText(
                              text: 'Checklist',
                              fontWeight: FontWeight.w700,
                              fontSize: 21,
                            ),
                          ),
                          const XMargin(10),
                          GestureDetector(
                              onTap: () {

                                if(carId != null) {
                                  navigate(context, ChecklistScreen(carId: carId!));
                                }

                              },
                              child: const GetSvgImage(
                                  image: 'assets/images/settings.svg')
                          ),
                          const XMargin(30),
                          GestureDetector(
                              onTap: () {
                                popView(context);
                              },
                              child: const Icon(Icons.close_rounded, size: 30,
                              )
                          ),
                          const XMargin(10),
                        ],
                      ),
                      const YMargin(20),

                      if(carId != null && viewModel.checkListDataModel != null) ... [

                        if(viewModel.isBusy) ... [
                          const Padding(
                            padding: EdgeInsets.all(28.0),
                            child: Center(child: CircularProgressIndicator(strokeWidth: 3,)),
                          )
                        ] else  ... [

                          NormalText(
                            text: viewModel.checkListDataModel!.payload!.items!.any((item) => item.isChecked ==  true)
                                ? 'Here are your active checklist items with reminders set as they are marked Blue.'
                                : 'Below are all checklist items you have. Click the settings above to select your checklist items.',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),

                          const YMargin(10),

                          Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(
                                        horizontal: -2, vertical: -2),
                                    onTap: () {
                                      //viewModel.toggleItem(index);
                                    },
                                    leading: Icon(
                                      viewModel.checkListDataModel!.payload!.items![index].isChecked!
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: XColors.buttonColor(),
                                    ),
                                    title: NormalText(
                                      text: viewModel.checkListDataModel!.payload!.items![index].item!,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                const DividerWidget(),
                                itemCount: viewModel.checkListDataModel!.payload!.items!.length
                            ),
                          ),
                        ],

                      ] else  ... [

                        const NormalText(
                          text: 'You need to add a car to get full check list experience',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),

                        const YMargin(10),

                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: -2, vertical: -2),
                                  onTap: () {
                                    //viewModel.toggleItem(index);
                                  },
                                  leading: Icon(Icons.check_box_outline_blank,
                                    color: XColors.buttonColor(),
                                  ),
                                  title: NormalText(
                                    text: checklistItems[index]["title"],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                              const DividerWidget(),
                              itemCount: checklistItems.length
                          ),
                        ),
                      ],

                    ],
                  )
              ),
            ),
          ),
        );
      },
    );
  }
}