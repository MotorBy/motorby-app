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

  Map<String, dynamic> setCarData = {
    "details" : {},
    "car_details" : {},
    "sales_details" : {}
  };

  void init({bool? forSale = false, String? initAction, Function? dataSetup}) {

    if(initAction != 'sell') {
      isBusinessOrForSale = false;
    } else {
      if(isBusiness || initAction == 'sell') {
        isBusinessOrForSale = true;
      }
    }

    action = initAction;
    notifyListeners();

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

  Future<List<String>> uploadFilesToCloud() async {
    setBusy(true);

    for (var element in addImagesList) {

      var pathUri = element.path.split('/')[element.path.split('/').length - 1];
      var storagePath = 'cars/${salesService.currentCarMake?.toLowerCase()}/${userService.userModel?.payload?.user?.userId}/$pathUri';

      await FirebaseService().uploadFileToStorage(
          storagePath: storagePath,
          filePath: element.path,
          onCallBack: (s) {

          }
      ).then((v) {
        addedImagesUrlList.add(v);
      });
    }

    return addedImagesUrlList;
  }

  void updateSetCarData({required Map<String, dynamic> data}) {
    setBusy(false);

    if (action == 'add' || action == 'edit') {

      if (data.containsKey('details')) {
        setCarData['details']?.addAll(data['details']);
      }

      data.forEach((key, value) {
        if (key != 'details') {
          setCarData[key] = value;
        }
      });

      // Update local state variables
      if(setCarData['details'] != null) {
        seats = setCarData['details']?['seats'];
        speakers = setCarData['details']?['speakers'];
        gear = setCarData['details']?['gear'];
        airBag = setCarData['details']?['air_bag'];
        airConditioner = setCarData['details']?['air_conditioner'];
      }

      if (data['car_make'] != null) {
        salesService.currentCarMake = data['car_make'];
      }
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
      print('Error picking images: $e');
    }
  }

  void removeCarByIndex(int index){
    addImagesList.removeAt(index);
    notifyListeners();
  }

  Future uploadCar({Function? onCallBack, Function? onErrorCallBack}) async {

    await uploadFilesToCloud().then((v) async {
      print(addedImagesUrlList.length);

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

      } else if (action == 'edit') {

        await userService.updateCar(
            data: setCarData,
            carId: salesService.currentCar!.sId
        ).then((value) {
          setBusy(false);
          onCallBack!();
        }).onError((error, stackTrace) {});

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

    });

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

  void updateVinNumber(String? s) {
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