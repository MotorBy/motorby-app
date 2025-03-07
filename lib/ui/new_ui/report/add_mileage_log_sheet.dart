import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'report_viewmodel.dart';

class AddMileageLogSheet extends StatelessWidget {
  const AddMileageLogSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportViewModel>.reactive(
      viewModelBuilder: () => ReportViewModel(),
      builder: (context, model, child) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Mileage Log',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
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
    );
  }

  Widget _buildDateField(BuildContext context, ReportViewModel model) {
    final date = model.selectedDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'DD/MM/YYYY',
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F2FF),
          ),
          readOnly: true,
          controller: TextEditingController(
            text: date != null 
                ? '${date.day}/${date.month}/${date.year}'
                : '',
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
        const Text(
          'Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter time',
            suffixIcon: const Icon(Icons.access_time),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F2FF),
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
        const Text(
          'Odometer Reading',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Start/End',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F2FF),
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
        const Text(
          'Fuel Added',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter amount of liters',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F2FF),
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
        const Text(
          'Location Tagging',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter start and end location',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F2FF),
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
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7B61FF),
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
