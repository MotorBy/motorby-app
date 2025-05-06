import 'dart:io';
import 'dart:convert' as JSON;

import 'package:image_picker/image_picker.dart';
import 'package:mobile_auto_drive/models/sales_model.dart';
import 'package:mobile_auto_drive/services/firebase_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/sales_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/services/vin_check_service.dart';
import 'package:mobile_auto_drive/utils/image_handling.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class AddCarViewModel extends BaseViewModel {
  final persistService = serviceLocator<PersistenceService>();
  final userService = serviceLocator<UserService>();
  final salesService = serviceLocator<SalesService>();
  final vinService = serviceLocator<VinCheckService>();

  bool isBusinessOrForSale = false;
  List<File> addImagesList = [];
  List<String> addedImagesUrlList = [];

  List<String> vinDataLabel = [
    'Make',
    'Model',
    'Year',
    '4WD/AWD',
    'Manufactured in',
    'Body Type'
  ];

  String? action = 'sell';

  SalesModel? salesModel;

  String? gear;
  String? seats;
  String? airBag;
  String? airConditioner;
  String? speakers;
  String? vinNumber = '';

  Map<String, dynamic> setCarData = { };

  void init({
    bool? forSale = false,
    String? initAction,
    Function? dataSetup}) {

    if(initAction != 'sell') {
      isBusinessOrForSale = false;
    } else {
      if(isBusiness || initAction == 'sell') {
        isBusinessOrForSale = true;
      }
    }

    action = initAction;
    notifyListeners();

    if(action == 'sell') {
      setCarData = {
        "car_details" : {},
        "sales_details" : {}
      };
    } else if(action == 'add') {
      setCarData = {
        "details" : {},
      };
    }

    if(dataSetup != null) {
      dataSetup();
    }

  }

  void setUrlImage({List<String>? urlImageList}){
    if(urlImageList != null) {
      addedImagesUrlList = urlImageList;
    }
    notifyListeners();
  }

  void updateImagePicks({int? index, type}) {
    if(type == 'file') {
      addImagesList.removeAt(index!);
    } else {
      addedImagesUrlList.removeAt(index!);
    }

    notifyListeners();
  }

  Future pickImages() async {
    if(addImagesList.length <= 8) {
      await pickImage(
          allowCropping: false,
          onCallBack: (image) {
            updateAddedFileImages(image);
          },
      );
    }
  }

  void updateAddedFileImages(String? file) {
    addImagesList.add(File(file!));
    notifyListeners();
  }

  Future uploadFilesToCloud() async {
    setBusy(true);

    for (var element in addImagesList) {
      await FirebaseService().uploadFileToStorage(
          storagePath: 'cars/${salesService.currentCarMake!.toLowerCase()}/${element.path.split('/')[element.path.split('/').length - 1]}',
          filePath: element.path,
          onCallBack: (s){
            addedImagesUrlList.add(s);
          }
      );
    }

  }

  void updateSetCarData({dynamic data, String? dataType}) {
    setBusy(false);

    Map<String, dynamic> updateData = {};
    
    if (action == "sell") {
      final carDetails = <String, dynamic>{
        if (dataType == 'make') 'car_make': data,
        if (dataType == 'year') 'car_year': data,
        if (dataType == 'model') 'car_model': data,
        if (dataType == 'grade') 'condition': data,
        if (dataType == 'mileage') 'mileage': int.parse(data!),
        if (dataType == 'vin') 'vin_number': data,
        if (dataType == 'color') 'color': data,
        if (dataType == 'seats') 'seats': int.parse(data!),
        if (dataType == 'speakers') 'speakers': int.parse(data!),
        if (dataType == 'gear') 'gear': data,
        if (dataType == 'breaks') 'breaks': data,
        if (dataType == 'air_bag') 'air_bag': data,
        if (dataType == 'air_conditioner') 'air_conditioner': data,
      };

      final salesDetails = <String, dynamic>{
        if (dataType == 'selling price') 'amount_for_sale': int.parse(data!),
        if (dataType == 'units') 'units_left': int.parse(data!),
      };

      if (carDetails.isNotEmpty) {
        updateData['car_details'] = carDetails;
      }
      if (salesDetails.isNotEmpty) {
        updateData['sales_details'] = salesDetails;
      }

      setCarData.addAll(updateData);

      if (dataType == 'make') {
        salesService.currentCarMake = data;
      }

    } else if (action == 'add') {
      final details = <String, dynamic>{
        if (dataType == 'grade') 'condition': data,
        if (dataType == 'mileage') 'mileage': int.parse(data!),
        if (dataType == 'speakers') 'speakers': data,
        if (dataType == 'gear') 'gear': data,
        if (dataType == 'seats') 'seats': data,
        if (dataType == 'breaks') 'breaks': data,
        if (dataType == 'air_bag') 'air_bag': data,
        if (dataType == 'air_conditioner') 'air_conditioner': data,
        if (dataType == 'color') 'color': data,
      };

      final mainData = <String, dynamic>{
        if (dataType == 'make') 'car_make': data,
        if (dataType == 'year') 'car_year': data,
        if (dataType == 'model') 'car_model': data,
        if (dataType == 'amount') 'amount_bought': int.parse(data!),
        if (dataType == 'vin') 'vin_number': data,
        if (dataType == 'chassis_number') 'chassis_number': data,
        if (dataType == 'engine_number') 'engine_number': data,
        if (dataType == 'registration_number') 'registration_number': data,
      };

      if (details.isNotEmpty) {
        updateData['details'] = details;
      }
      if (mainData.isNotEmpty) {
        updateData.addAll(mainData);
      }

      setCarData.addAll(updateData);

      if (dataType == 'make') {
        salesService.currentCarMake = data;
      }
    }

    // Update local state variables
    if (dataType == 'seats') seats = data;
    if (dataType == 'speakers') speakers = data;
    if (dataType == 'gear') gear = data;
    if (dataType == 'air_bag') airBag = data;
    if (dataType == 'air_conditioner') airConditioner = data;

    if (action == "sell") {
      salesModel = SalesModel.fromJson(JSON.json.decode(JSON.json.encode(setCarData)));
    }

    print(setCarData.toString());
    notifyListeners();
  }

  Future<void> browseFiles() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty && images.length <= 5) {
        addImagesList = images.map((xfile) => File(xfile.path)).toList();
        notifyListeners();
      }
    } catch (e) {
      // TODO: Handle error
      print('Error picking images: $e');
    }
  }

  void removeCarByIndex(int index){
    addImagesList.removeAt(index);
    notifyListeners();
  }

  Future uploadCar({Function? onCallBack, Function? onErrorCallBack}) async {

    await uploadFilesToCloud();

    setCarData['images'] = addedImagesUrlList;
    setCarData['by'] = persistService.getUserID;
    setCarData['user_id'] = persistService.getUserID;

    setBusy(true);
    if(action == 'sell') {

      var saleData = {
        'user_id' : persistService.getUserID,
        'data': setCarData,
      };

      await salesService.makeSales(salesData: saleData).then((value) {
        setBusy(false);
        onCallBack!();
      }).onError((error, stackTrace) {
        setBusy(false);
        print(stackTrace.toString());
        onErrorCallBack!();
      });

    } else {

      await userService.addACar(carData: setCarData).then((value) {
        setBusy(false);
        onCallBack!();
      }).onError((error, stackTrace) {
        setBusy(false);
        print(stackTrace.toString());
        onErrorCallBack!();
      });

    }

  }

  Future updateCarImage({Function? onCallBack, Function? onErrorCallBack, bool? fromSale = false}) async {
    await uploadFilesToCloud();

    var dataToUpdate = {
      "images" : addedImagesUrlList
    };

    if(fromSale!) {

      await salesService.updateSales(salesData: dataToUpdate).then((value) {
        setBusy(false);
        onCallBack!();
      }).onError((error, stackTrace) {
        setBusy(false);
        print(stackTrace.toString());
        onErrorCallBack!();
      });

    } else {

      await userService.updateCar(data: dataToUpdate, carId: salesService.currentCar!.sId).then((value) {
        setBusy(false);
        onCallBack!();
      }).onError((error, stackTrace) {
        setBusy(false);
        print(stackTrace.toString());
        onErrorCallBack!();
      });

    }

  }

  void updateVinNumber(String? s){
    vinNumber = s;
    notifyListeners();
  }

  Future makeVinCheck({Function? onCallBack, Function(String e)? onErrorCallBack}) async {
    setBusy(true);
    await vinService.vinCheckSetup(
      vinType: 'basic',
      vinNumber: vinNumber
    ).then((value) {
      setBusy(false);
      onCallBack!();
    }).onError((error, stackTrace) {
      print(stackTrace);
      onErrorCallBack!(error.toString());
      setBusy(false);
    });
  }


}