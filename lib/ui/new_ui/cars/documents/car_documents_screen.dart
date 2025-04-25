import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_selector_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/documents/car_documents_viewmodel.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class CarDocumentsScreen extends StatelessWidget {
  const CarDocumentsScreen({Key? key, this.carId, this.isFromProfile = false}) : super(key: key);

  final String? carId;
  final bool? isFromProfile;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CarDocumentsViewModel>.reactive(
      viewModelBuilder: () => CarDocumentsViewModel(),
      onViewModelReady: (model) => model.initialize(carId: carId),
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              if(isFromProfile == true) ... [

                CarSelectorView(
                    cars: model.getBudgetData(),
                    currentCar: model.getCurrentCar() != null ? '${model.getCurrentCar()!.carMake} ${model.getCurrentCar()!.carModel} ${model.getCurrentCar()!.carYear}' : null,
                    onCarSelected: ({Budget? budget, int? index}) {

                      model.initialize(carId: budget!.carId!.sId);

                    }
                ),

                const SizedBox(height: 26),

              ],

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
          backgroundColor: model.documentType!.isNotEmpty ? XColors.primaryColor() : Colors.grey,
          onPressed: () {
            if(model.documentType!.isNotEmpty) {

              model.pickDocument(onComplete: () {

                DateTime? selectedDate;

                modalBottomSheetMenu(
                  context: context,
                  child: ViewModelBuilder<CarDocumentsViewModel>.reactive(
                      viewModelBuilder: () => model,
                      disposeViewModel: false,
                      builder: (context, model, child) {
                        return Container(
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
                                    model.notifyListeners();

                                    model.setExpiryDate(eDate: selectedDate, onSelected: () {

                                    });

                                  }

                                },
                              ),
                              const SizedBox(height: 26),

                              XButton(
                                onPressed: () {

                                  if(model.expiryDate == null) {
                                    FloatingSnackBar.show(
                                        context,
                                        "Please select an expiry date for your document",
                                        isError: true
                                    );
                                    return null;
                                  }

                                  model.uploadDocument(
                                      onCallback: () {

                                        popView(context);
                                        FloatingSnackBar.show(
                                            context,
                                            "Successfully uploaded your document for ${model.documentType}",
                                            isError: false
                                        );

                                      },
                                      onError: (e) {
                                        FloatingSnackBar.show(
                                            context,
                                            e,
                                            isError: true
                                        );
                                      }
                                  );

                                },
                                text: 'Upload Document',
                                isLoading: model.busy('upload'),
                                buttonColor: XColors.primaryColor(),
                                width: MediaQuery.of(context).size.width,
                              ),

                            ],
                          ),
                        );
                      }
                  ),
                );
              });

            } else {

              FloatingSnackBar.show(
                  context,
                  "Select any document category to upload first",
                  isError: true
              );

            }
          },
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
                fontWeight: model.documentType == title ? FontWeight.w700 : FontWeight.w400,
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
                        text: document.documentName,
                        fontSize: 14,
                      ),
                      subtitle: NormalText(
                        text: document.documentExpiryDate != null
                            ? 'Expires: ${document.documentExpiryDate}'
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
            ),
        )
    );
  }
}