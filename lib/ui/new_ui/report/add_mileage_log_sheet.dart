import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'report_viewmodel.dart';

class AddMileageLogSheet extends StatelessWidget {
  const AddMileageLogSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportViewModel>.reactive(
      viewModelBuilder: () => ReportViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Mileage Log',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDateField(context, model),
                const SizedBox(height: 16),
                _buildTimeField(context, model),
                const SizedBox(height: 16),
                _buildOdometerField(model),
                const SizedBox(height: 16),
                _buildFuelField(model),
                const SizedBox(height: 16),
                _buildLocationField(model),
                const SizedBox(height: 24),
                _buildSaveButton(context, model),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, ReportViewModel model) {
    final date = model.selectedDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NormalText(
          text: 'Date',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
               enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1,color: Color(0xFFD0D5DD)),
            ),
            focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1,color: Color(0xFFD0D5DD)),
            ),
            hintText: 'DD/MM/YYYY',
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1, color: Color(0xFFD0D5DD)),
            ),
            filled: true,
            fillColor: XColors.white(),
          ),
          readOnly: true,
          controller: TextEditingController(
            text: date != null ? '${date.day}/${date.month}/${date.year}' : '',
          ),
          onTap: () async {
            final selected = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (selected != null) {
              model.setDate(selected);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTimeField(BuildContext context, ReportViewModel model) {
    final time = model.selectedTime;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NormalText(
          text: 'Time',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
               enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1,color: Color(0xFFD0D5DD)),
            ),
            focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1,color: Color(0xFFD0D5DD)),
            ),
            hintText: 'Enter time',
            suffixIcon: const Icon(Icons.access_time),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 1,
                color: Color(0xFFD0D5DD),
              ),
            ),
            filled: true,
            fillColor: XColors.white(),
          ),
          readOnly: true,
          controller: TextEditingController(
            text: time != null
                ? '${time.hour}:${time.minute.toString().padLeft(2, '0')}'
                : '',
          ),
          onTap: () async {
            final selected = await showTimePicker(
              context: context,
              initialTime: time ?? TimeOfDay.now(),
            );
            if (selected != null) {
              model.setTime(selected);
            }
          },
        ),
      ],
    );
  }

  Widget _buildOdometerField(ReportViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NormalText(
          text: 'Odometer Reading',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
               enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1,color: Color(0xFFD0D5DD)),
            ),
            focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1,color: Color(0xFFD0D5DD)),
            ),
            hintText: 'Start/End',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1, color: Color(0xFFD0D5DD)),
            ),
            filled: true,
            fillColor: XColors.white(),
          ),
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: model.odometerReading),
          onChanged: model.setOdometerReading,
        ),
      ],
    );
  }

  Widget _buildFuelField(ReportViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NormalText(
          text: 'Fuel Added',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
               enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1,color: Color(0xFFD0D5DD)),
            ),
            focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1,color: Color(0xFFD0D5DD)),
            ),
            hintText: 'Enter amount of liters',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1, color: Color(0xFFD0D5DD)),
            ),
            filled: true,
            fillColor: XColors.white(),
          ),
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: model.fuelAdded),
          onChanged: model.setFuelAdded,
        ),
      ],
    );
  }

  Widget _buildLocationField(ReportViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NormalText(
          text: 'Location Tagging',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter start and end location',
            border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1,color: Color(0xFFD0D5DD)),
            ),
            enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1,color: Color(0xFFD0D5DD)),
            ),
            focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1,color: Color(0xFFD0D5DD)),
            ),
            filled: true,
            fillColor: XColors.white(),
          ),
          controller: TextEditingController(text: model.location),
          onChanged: model.setLocation,
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, ReportViewModel model) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await model.saveMileageLog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: XColors.primaryColor2(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
