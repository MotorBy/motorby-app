import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/firebase_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';
import 'document_details_screen.dart';

class CarDocumentsViewModel extends BaseViewModel {
  final budgetingService = serviceLocator<BudgetingService>();
  final vehicleService = serviceLocator<UserService>();

  List<CarDocument> _documents = [];
  List<Map<String, dynamic>> docUploads = [];
  CarId? currentCarDoc;
  String? currentCarId;

  void initialize({String? carId}) {

    if(budgetingService.budgetingModel == null) {
      setBusy(true);
    } else {

      if(carId != null) {
        currentCarId = carId;
        _documents = budgetingService.budgetingModel!.budget!.where((b) => b.carId!.sId == carId).toList()[0].carId!.carDocuments!;
        currentCarDoc = budgetingService.budgetingModel!.budget!.where((b) => b.carId!.sId == carId).toList()[0].carId!;
      } else {
        _documents = budgetingService.budgetingModel!.budget!.isNotEmpty ? budgetingService.budgetingModel!.budget!.first.carId!.carDocuments! : [];
        currentCarDoc = budgetingService.budgetingModel!.budget!.isNotEmpty ? budgetingService.budgetingModel!.budget!.first.carId! : null;
      }

    }

    setBusy(false);

  }

  List<CarDocument> getDocumentsByCategory(String category) {
    return _documents.where((doc) => doc.documentType == category).toList();
  }

  String? documentType = "";
  DateTime? expiryDate;
  FilePickerResult? filePickerResult;

  void setTypeOfDocument({String? type}) {
    documentType = type;
    notifyListeners();
  }

  List<Budget> getBudgetData() {
    return budgetingService.budgetingModel?.budget ?? [];
  }

  CarId? getCurrentCar() {
    return budgetingService.currentCar;
  }

  void setExpiryDate({DateTime? eDate, Function? onSelected}) {

    docUploads.clear();

    expiryDate = eDate;
    onSelected!.call();

    File file = File(filePickerResult!.files.single.path!);
    String fileName = filePickerResult!.files.single.name;

    docUploads.add(
      {
        "document_name": fileName,
        "document_type": documentType,
        "document_expiry_date": '${eDate!.day}/${eDate.month}/${eDate.year}',
      }
    );

    notifyListeners();

  }

  Future<void> uploadDocument({Function? onCallback, Function(String e)? onError}) async {

    try {

      setBusyForObject('upload', true);

      await FirebaseService().uploadFileToStorage(
          storagePath: 'docs/${currentCarDoc!.carMake}/${docUploads[0]["document_type"]}-${docUploads[0]["document_name"]}',
          filePath: filePickerResult!.files.single.path!,
          onCallBack: (s) async {

            docUploads[0]["document_path"] = s;

            await vehicleService.uploadCarDocuments(
              documents: {
                "documents": docUploads
              },
              carId: currentCarId
            ).then((e) {
              initialize(carId: currentCarId);

              setBusyForObject('upload', false);
              onCallback!.call();
            });

          }
      );

    } catch (e) {
      print('Error uploading document: $e');

      setBusyForObject('upload', false);
      onError!.call(e.toString());
    }

  }

  Future<void> pickDocument({ Function? onComplete }) async {
    try {

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {

        if(onComplete != null) {
          filePickerResult = result;
          onComplete();
        }

      }

    } catch (e) {
      print('Error uploading document: $e');
    }
  }

  void viewDocument(BuildContext context, CarDocument document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentDetailsScreen(document: document),
      ),
    );
  }

  void showDocumentOptions(BuildContext context, CarDocument document) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Update Expiry Date'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement date picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Document'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Document', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                deleteDocument(document.id!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteDocument(String documentId) async {
    _documents.removeWhere((doc) => doc.id == documentId);
    notifyListeners();
  }

  Future<void> updateDocument(CarDocument document) async {
    final index = _documents.indexWhere((doc) => doc.id == document.id);
    if (index != -1) {
      _documents[index] = document;
      notifyListeners();
    }
  }
}