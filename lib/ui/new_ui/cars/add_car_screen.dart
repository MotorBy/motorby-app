import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'add_car_viewmodel.dart';

class AddCarScreen extends StatelessWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddCarViewModel>.reactive(
      viewModelBuilder: () => AddCarViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFFF8F2FF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Add a car',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your car image (optional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                _buildImageUploader(model),
                const SizedBox(height: 8),
                const Text(
                  'Upload up to 5 images capturing different angles of your car.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
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
                  trailing: const Icon(Icons.calendar_today, size: 20),
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
                      backgroundColor: const Color(0xFF7B61FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add new car',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_upload_outlined,
            size: 40,
            color: Color(0xFF7B61FF),
          ),
          const SizedBox(height: 8),
          const Text(
            'Click to upload',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'PNG, JPG (max. 800×400px)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'OR',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: model.browseFiles,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B61FF),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Browse Files'),
          ),
        ],
      ),
    );
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
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
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
            controller: value != null ? TextEditingController(text: value) : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              suffixIcon: trailing,
            ),
          ),
        ),
      ],
    );
  }
}
