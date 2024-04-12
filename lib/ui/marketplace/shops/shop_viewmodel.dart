import 'dart:io';
import 'dart:math';

import 'package:mobile_auto_drive/models/shops_model.dart';
import 'package:mobile_auto_drive/services/firebase_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/shop_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/image_handling.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class ShopViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();
  final shopService = serviceLocator<ShopService>();
  final persistService = serviceLocator<PersistenceService>();

  Map<String, dynamic> createData = {};
  List<String> intoPicks = [];
  List<String> carMakePicks = [];
  File? logoPick;

  final List<String> shopTypes = ["All", "Dealership", "Repair", "Detailing", "Servicing", "Parts"];

  List<Shop>? shops = [];
  Shop? currentShop;

  bool? hasData = false;

  Future initialise() async {
    await getShop();
  }

  Future createShop({Function? onCallBack, Function? onErrorCallBack}) async {

    createData['into'] = intoPicks;
    createData['support_make'] = carMakePicks;
    createData['opened_by'] = persistService.getUserID;
    createData['country'] = userService.userModel!.payload!.user!.country;
    createData['state'] = userService.userModel!.payload!.user!.state ?? '';

    setBusy(true);

    if(logoPick != null) {
      await FirebaseService().uploadFileToStorage(
          storagePath: 'shop-logo/${createData['name']}.png',
          filePath: logoPick!.path,
          onCallBack: (s){
            createData['logo'];
          }
      );
    }

    shopService.createShop(shopData: createData).then((value) {

      if(onCallBack != null) {
        onCallBack();
      }

      setBusy(false);

    }).onError((error, stackTrace) {

      if(onErrorCallBack != null) {
        onErrorCallBack();
      }

      setBusy(false);

    });

  }

  Future pickImages() async {
    await pickImage(
      allowCropping: false,
      onCallBack: (image) {
        updateAddedFileImages(image);
      },
    );
  }

  void updateAddedFileImages(String? file) {
    logoPick = File(file!);
    notifyListeners();
  }

  Future getShop() async {
    setBusyForObject('shops', true);
    await shopService.getShops().then((value) {
      shops = shopService.shopsModel!.shop;
      setBusyForObject('shops', false);
      if(shops!.isNotEmpty) {
        hasData = true;
      }
    }).onError((error, stackTrace) {
      print(stackTrace);
      setBusyForObject('shops', false);
      hasData = false;
    });
  }

  void updateSelections({String? picks, String? type, bool? remove = false}) {

    if(remove != true) {

      if(type == 'into') {

        if(intoPicks.length < 2) {
          if(!intoPicks.contains(picks)) {
            intoPicks.add(picks!);
          }
        }

      } else if (type == "make") {

        if(carMakePicks.length < 5) {
          if(!carMakePicks.contains(picks!)) {
            carMakePicks.add(picks);
          }
        }

      }

    } else {

      if(type == 'into') {
        intoPicks.remove(picks);
      } else if (type == "make") {
        carMakePicks.remove(picks);
      }

    }

    notifyListeners();
  }

  void updateSetupData({String? data, String? type,}) {
    if(type == 'name') {
      createData["name"] = data;
    } else if (type == "description") {
      createData["description"] = data;
    } else if (type == "contact") {
      createData["contact"] = data;
    } else if (type == "address") {
      createData["address"] = {
        "address_name": data
      };
    } else if (type == "email") {
      createData["email"] = data;
    }

    notifyListeners();
  }

  void updateCurrentShop(Shop? shop){
    currentShop = shop;
    notifyListeners();
  }



}