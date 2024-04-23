import 'dart:io';
import 'dart:convert' as JSON;

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

  Map<String, dynamic> setCarData = {

  };

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

  void updateSetCarData({dynamic data, String? dataType, }) {
    setBusy(false);

    if(action == "sell") {
      if(dataType == 'make') {
        setCarData['car_details']['car_make'] = data!;
        salesService.currentCarMake = data!;
      } else if(dataType == 'year') {
        setCarData['car_details']['car_year'] = data!;

      } else if (dataType == "model") {
        setCarData['car_details']['car_model'] = data!;

      } else if(dataType == "grade") {
        setCarData['car_details']['condition'] = data!;

      } else if(dataType == "mileage") {
        setCarData['car_details']['mileage'] = int.parse(data!);

      } else if(dataType == "vin") {
        setCarData['car_details']['vin_number'] = data!;

      } else if(dataType == "selling price") {
        setCarData['sales_details']['amount_for_sale'] = int.parse(data!);

      } else if(dataType == "units") {
        setCarData['sales_details']['units_left'] = int.parse(data!);

      } else if(dataType == "color") {
        setCarData['car_details']['color'] = data!;

      } else if(dataType == "seats") {
        setCarData['car_details']['seats'] = int.parse(data!);
        seats = data;

      } else if(dataType == "speakers") {
        setCarData['car_details']['speakers'] = int.parse(data!);
        speakers = data;

      } else if(dataType == "gear") {
        setCarData['car_details']['gear'] = data!;
        gear = data;

      } else if(dataType == "breaks") {
        setCarData['car_details']['breaks'] = data!;

      } else if(dataType == "air_bag") {
        setCarData['car_details']['air_bag'] = data!;
        airBag = data;

      } else if(dataType == "air_conditioner") {
        setCarData['car_details']['air_conditioner'] = data!;
        airConditioner = data;

      }
    } else if(action == 'add') {

      if(dataType == 'make') {
        setCarData['car_make'] = data!;
        salesService.currentCarMake = data!;
      } else if(dataType == 'year') {
        setCarData['car_year'] = data!;

      } else if (dataType == "model") {
        setCarData['car_model'] = data!;

      } else if(dataType == "grade") {
        setCarData['details']['condition'] = data!;

      } else if(dataType == "amount") {
        setCarData['amount_bought'] = int.parse(data!);

      } else if(dataType == "mileage") {
        setCarData['details']['mileage'] = int.parse(data!);

      } else if(dataType == "vin") {
        setCarData['vin_number'] = data!;

      } else if(dataType == "speakers") {
        setCarData['details']['speakers'] = data!;
        speakers = data;

      } else if(dataType == "gear") {
        setCarData['details']['gear'] = data!;
        gear = data;

      }  else if(dataType == "seats") {
        setCarData['details']['seats'] = data!;
        seats = data;

      } else if(dataType == "breaks") {
        setCarData['details']['breaks'] = data!;

      } else if(dataType == "air_bag") {
        setCarData['details']['air_bag'] = data!;
        airBag = data;

      } else if(dataType == "air_conditioner") {
        setCarData['details']['air_conditioner'] = data!;
        airConditioner = data;

      }

    }

    if(action == "sell") {
      salesModel = SalesModel.fromJson(JSON.json.decode(JSON.json.encode(setCarData)));
    }

    print(setCarData.toString());
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