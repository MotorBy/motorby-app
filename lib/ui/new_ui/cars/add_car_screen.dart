import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'add_car_viewmodel.dart';

class AddCarScreen extends StatelessWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddCarViewModel>.reactive(
      viewModelBuilder: () => AddCarViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: Color(0xFFFEF7FF),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: false,
          title: const NormalText(
            text: 'Add a car',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NormalText(
                  text: 'Your car image (optional)',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),
                _buildImageUploader(model),
                const SizedBox(height: 8),
                const NormalText(
                  text:
                      'Upload up to 5 images capturing different angles of your car.',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 24),
                _buildDropdownField(
                  label: 'Manufacturer',
                  hint: 'Select manufacturer',
                  onTap: model.selectManufacturer,
                  value: model.selectedManufacturer,
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  label: 'Model',
                  hint: 'Model',
                  onTap: model.selectModel,
                  value: model.selectedModel,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Year',
                  hint: 'Surname/Last name',
                  onTap: model.selectYear,
                  value: model.selectedYear,
                  trailing: const GetSvgImage(
                    image: 'assets/images/Icon-calender.svg',
                    height: 14,
                    width: 14,
                    boxFit: BoxFit.scaleDown,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  label: 'Fuel type',
                  hint: 'Fuel type',
                  onTap: model.selectFuelType,
                  value: model.selectedFuelType,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Fuel capacity',
                  hint: 'Enter fuel capacity',
                  onChanged: model.setFuelCapacity,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'License plate (optional)',
                  hint: 'Enter license plate',
                  onChanged: model.setLicensePlate,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Chassis number (optional)',
                  hint: 'Enter chassis number',
                  onChanged: model.setChassisNumber,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: model.addNewCar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: XColors.buttonColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: NormalText(
                      text: 'Add new car',
                      textColor: XColors.white(),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploader(AddCarViewModel model) {
    final PageController _pageController =
        PageController(viewportFraction: 0.8);

    if (model.carImages.isNotEmpty) {
      return SizedBox(
        height: 250,
        child: ListView.builder(
            controller: _pageController,
            itemCount: model.carImages.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Stack(
                  children: [
                    Image.file(
                      model.carImages[index],
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      right: 5,
                      top: 2,
                      child: ContainerWidget(
                        onTap:()=> model.removeCarByIndex(index),
                        decoration:const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle,),padding: const EdgeInsets.all(2),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }
    return Container(
        width: double.infinity,
        height: 250,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFFF4EFFB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GetSvgImage(image: 'assets/images/file_uploadfile.svg'),
            const YMargin(16),
            const NormalText(
              text: 'Click to upload',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            const NormalText(
              text: 'PNG, JPG (max. 800×400px)',
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Color(0xFFD0D5DD),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: NormalText(
                      text: 'OR',
                      fontSize: 14,
                      textColor: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Color(0xFFD0D5DD),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: model.browseFiles,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A1CAC),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: NormalText(
                text: 'Browse Files',
                textColor: XColors.white(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ));
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required VoidCallback onTap,
    String? value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          text: label,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? hint,
                  style: TextStyle(
                    fontSize: 16,
                    color: value == null ? Colors.grey : Colors.black,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    Function(String)? onChanged,
    VoidCallback? onTap,
    Widget? trailing,
    TextInputType? keyboardType,
    String? value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: TextField(
            onChanged: onChanged,
            onTap: onTap,
            readOnly: onTap != null,
            keyboardType: keyboardType,
            controller:
                value != null ? TextEditingController(text: value) : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              suffixIcon: trailing,
            ),
          ),
        ),
      ],
    );
  }
}
