import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'document_details_screen.dart';

class CarDocument {
  final String id;
  final String name;
  final String category;
  final String? filePath;
  final DateTime? expiryDate;

  CarDocument({
    required this.id,
    required this.name,
    required this.category,
    this.filePath,
    this.expiryDate,
  });
}

class CarDocumentsViewModel extends BaseViewModel {
  final List<CarDocument> _documents = [];

  List<CarDocument> getDocumentsByCategory(String category) {
    return _documents.where((doc) => doc.category == category).toList();
  }

  String? documentType = "";
  DateTime? expiryDate;
  FilePickerResult? filePickerResult;

  void setTypeOfDocument({String? type}){
    documentType = type;
  }

  void setExpiryDate({DateTime? eDate, Function? onSelected}) {

    expiryDate = eDate;
    onSelected!.call();

    File file = File(filePickerResult!.files.single.path!);

    _documents.add(
      CarDocument(
        id: DateTime.now().toString(),
        name: filePickerResult!.files.single.name,
        category: documentType ?? 'Other Documents',
        filePath: file.path,
        expiryDate: expiryDate,
      ),
    );

    notifyListeners();

  }

  Future<void> uploadDocument({ Function? onComplete }) async {
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
                deleteDocument(document.id);
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