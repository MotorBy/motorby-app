import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Checklist settings',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Frequency Section
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
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  'Daily',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'You will get reminders daily for the activated checklist below',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Edit Checklist Section
                const Text(
                  'Edit checklist',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add or remove any checklist you want',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),

                // Checklist Items
                _buildChecklistItem('Fluids (oil and coolant)'),
                _buildDivider(),
                _buildChecklistItem('Brakes'),
                _buildDivider(),
                _buildChecklistItem('Lights'),
                _buildDivider(),
                _buildChecklistItem('Wiper blades'),
                _buildDivider(),
                _buildChecklistItem('Horn'),
                _buildDivider(),
                _buildChecklistItem('Tyres'),
                _buildDivider(),
                _buildChecklistItem('Documents and licenses'),
                
                const SizedBox(height: 32),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement update functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Update checklist',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildChecklistItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: true, // TODO: Connect to view model
            onChanged: (value) {
              // TODO: Implement switch functionality
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
  const ChecklistScreenDialogue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
                height: 580,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       const NormalText(
                          text: 'Checklist',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        GestureDetector(
                         onTap: (){
                          navigate(context,const ChecklistScreen());
                         }, 
                          child:const GetSvgImage(image: 'assets/images/settings.svg')),
                      ],
                    ),
                    const YMargin(20),
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const  VisualDensity(horizontal: -2,vertical: -2),
                              onTap: (){
                                viewModel.toggleItem(index);
                              },
                              leading: 
                              Icon(
                               viewModel.checkList[index].isChecked?
                               Icons.check_box
                               : 
                                Icons.check_box_outline_blank,
                                color: XColors.buttonColor(),
                              ),
                              title: NormalText(text: viewModel.checkList[index].title,fontSize: 14,fontWeight: FontWeight.w500,),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const DividerWidget(),
                          itemCount: viewModel.checkList.length),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }}