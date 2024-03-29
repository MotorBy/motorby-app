import 'package:mobile_auto_drive/models/sales_model.dart';
import 'package:mobile_auto_drive/services/sales_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class MarketplaceViewModel extends BaseViewModel {
  final salesService = serviceLocator<SalesService>();
  final userService = serviceLocator<UserService>();

  String? carMake;

  void setPickedCarMake({String? v}){
    carMake = v;
    salesService.currentCarMake = carMake;
    notifyListeners();
  }

  void setFilteringData(){

  }


}