import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class AddCarViewModel extends BaseViewModel {
  String? selectedManufacturer;
  String? selectedModel;
  String? selectedYear;
  String? selectedFuelType;
  String? fuelCapacity;
  String? licensePlate;
  String? chassisNumber;
  List<File> carImages = [];

  Future<void> selectManufacturer() async {
    // TODO: Implement manufacturer selection
    notifyListeners();
  }

  Future<void> selectModel() async {
    // TODO: Implement model selection
    notifyListeners();
  }

  Future<void> selectYear() async {
    // TODO: Implement year selection
    notifyListeners();
  }

  Future<void> selectFuelType() async {
    // TODO: Implement fuel type selection
    notifyListeners();
  }

  void setFuelCapacity(String value) {
    fuelCapacity = value;
    notifyListeners();
  }

  void setLicensePlate(String value) {
    licensePlate = value;
    notifyListeners();
  }

  void setChassisNumber(String value) {
    chassisNumber = value;
    notifyListeners();
  }

  Future<void> browseFiles() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty && images.length <= 5) {
        //File file = File(pickedFile.path);
      carImages = images.map((xfile) => File(xfile.path)).toList();
        notifyListeners();
      }
    } catch (e) {
      // TODO: Handle error
      print('Error picking images: $e');
    }
  }

void removeCarByIndex(int index){
  carImages.removeAt(index);
  notifyListeners();
}
  Future<void> addNewCar() async {
    // TODO: Implement add new car logic
    // Validate required fields
    if (selectedManufacturer == null ||
        selectedModel == null ||
        selectedYear == null ||
        selectedFuelType == null ||
        fuelCapacity == null) {
      // Show error
      return;
    }

    // Create car object and save
    final car = {
      'manufacturer': selectedManufacturer,
      'model': selectedModel,
      'year': selectedYear,
      'fuelType': selectedFuelType,
      'fuelCapacity': fuelCapacity,
      'licensePlate': licensePlate,
      'chassisNumber': chassisNumber,
      'images': carImages,
    };

    // TODO: Save car to database
    print('Adding new car: $car');
  }
}
