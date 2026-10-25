import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/add/add_car_screen.dart';
import 'package:mobile_auto_drive/utils/car_make_data.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/divider_widget.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class CarSelectorView extends StatelessWidget {
  final List<Budget> cars;
  final Function({ Budget budget, int index}) onCarSelected;
  final String? title;
  final String? currentCar;
  final bool? allowStyling;

  const CarSelectorView({
    Key? key,
    required this.cars,
    required this.onCarSelected,
    this.title,
    this.currentCar,
    this.allowStyling = false,
  }) : super(key: key);

  void _showCarSelector(BuildContext context) {
    modalBottomSheetMenu(
      color: Colors.white,
      isDismissible: true,
      context: context,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                color: const Color(0xFFD0D5DD),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My cars',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if(cars.isNotEmpty) ... [

              const NormalText(
                text: 'Select any of your cars',
                fontSize: 13,
                textColor: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 26),

            ],

            if(cars.isNotEmpty) ... [

              SizedBox(
                height: 140,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(vertical: -2),
                          trailing: const Icon(Icons.circle_outlined),
                          title: NormalText(
                            text: cars[index].carName,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          selected: true,
                          selectedTileColor: Colors.deepPurple.withOpacity(0.1),
                          onTap: () {
                            Navigator.pop(context);
                            onCarSelected(budget: cars[index], index: index);
                          }
                      );
                    },
                    separatorBuilder: (context, index) => const DividerWidget(),
                    itemCount: cars.length
                ),
              ),
              const SizedBox(height: 16),

            ] else ... [

              const NormalText(
                text: 'You currently have no car added to manage, Add a car to start',
                fontSize: 13,
                textColor: Colors.black,
                fontWeight: FontWeight.w500,
              ),

              const SizedBox(height: 26),

            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const NormalText(
                  text: 'Add car',
                  textColor: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: XColors.background(),
                  side: const BorderSide(width: 1, color: Colors.grey),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  //navigate(context, const AddCarScreen());
                  navigate(context, const AddCarsScreen());
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCarSelector(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(
          border: allowStyling == true ? Border.all(color: XColors.primaryColor()) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Row(children: [

              if(currentCar != null) ... [

                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    carMakeData.firstWhere(
                            (make) => currentCar!.contains(make['name']!),
                        orElse: () => carMakeData[0]
                    )['logo']!,
                    fit: BoxFit.cover,
                  ),
                ),

              ],
              const XMargin(10),
              NormalText(
                text: currentCar ?? 'Add a Car',
                textColor: XColors.primaryColor(),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),

            ],),

            Icon(Icons.arrow_forward_ios, size: 22, color: XColors.primaryColor()),
          ],
        ),
      ),
    );
  }
}