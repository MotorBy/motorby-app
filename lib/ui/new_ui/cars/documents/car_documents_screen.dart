import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/documents/car_documents_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class CarDocumentsScreen extends StatelessWidget {
  const CarDocumentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CarDocumentsViewModel>.reactive(
      viewModelBuilder: () => CarDocumentsViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF7FF),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: false,
          title: const NormalText(
            text: 'Car Documents',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDocumentCategory('Vehicle Registration', model, context: context),
              const SizedBox(height: 16),
              _buildDocumentCategory('Insurance', model, context: context),
              const SizedBox(height: 16),
              _buildDocumentCategory('Maintenance Records', model, context: context),
              const SizedBox(height: 16),
              _buildDocumentCategory('Other Documents', model, context: context),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: XColors.primaryColor(),
          onPressed: () => model.uploadDocument(onComplete: () {

            DateTime? selectedDate;

            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => StatefulBuilder(
                builder: (context, setState) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormalText(
                        text: 'Upload Document for ${model.documentType}',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 26),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: NormalText(
                          text: selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : 'Set Expiry Date',
                          fontSize: 16,
                        ),
                        onTap: () async {

                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 3650)),
                          );

                          if (date != null) {

                            selectedDate = date;
                            setState(() {});

                            model?.setExpiryDate(eDate: selectedDate, onSelected: () { });

                          }

                        },
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: XColors.primaryColor(),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const NormalText(
                            text: 'Upload Document',
                            textColor: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

          }),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        ),
      );
  }

  Widget _buildDocumentCategory(String title, CarDocumentsViewModel model, { BuildContext? context }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: Theme.of(context!).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: NormalText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        onExpansionChanged: (expanded) {
          model.setTypeOfDocument(type: title);
        },
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: model.getDocumentsByCategory(title).length,
            itemBuilder: (context, index) {
              final document = model.getDocumentsByCategory(title)[index];
              return ListTile(
                leading: const GetSvgImage(
                  image: 'assets/images/file_upload.svg',
                  height: 24,
                  width: 24,
                ),
                title: NormalText(
                  text: document.name,
                  fontSize: 14,
                ),
                subtitle: NormalText(
                  text: document.expiryDate != null 
                    ? 'Expires: ${document.expiryDate}'
                    : 'No expiry date',
                  fontSize: 12,
                  textColor: Colors.grey,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => model.showDocumentOptions(context, document),
                ),
                onTap: () => model.viewDocument(context, document),
              );
            },
          ),
        ],
      ))
    );
  }
}