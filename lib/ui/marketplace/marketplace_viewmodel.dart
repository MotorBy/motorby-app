import 'package:mobile_auto_drive/models/sales_model.dart';
import 'package:mobile_auto_drive/services/sales_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class MarketplaceViewModel extends BaseViewModel {
  final salesService = serviceLocator<SalesService>();
  final userService = serviceLocator<UserService>();

  String? carMake;

  SalesListModel? salesListModel;
  SalesModel? currentSalesModel;

  bool? isBusiness;

  Future getAllSales() async {
    carMake = salesService.currentCarMake;
    isBusiness = userService.isBusiness;

    if(salesService.salesListModel == null) {

      setBusy(true);
      reloadSales();

    } else {

      if(salesService.salesListModel!.payload!.isNotEmpty) {
        if(salesService.salesListModel!.payload![0].carDetails!.carMake == carMake) {
          salesListModel = salesService.salesListModel;
          notifyListeners();
        } else {
          reloadSales();
        }
      } else {
        reloadSales();
      }

    }
  }

  Future reloadSales() async {
    setBusy(true);
    print(carMake);

    await salesService.getSales(carMake: carMake).then((value) {
      setBusy(false);
    }).onError((error, stackTrace) {
      setBusy(false);
    });
    salesListModel = salesService.salesListModel;
    notifyListeners();
  }

  void setPickedCarMake({String? v}){
    carMake = v;
    salesService.currentCarMake = carMake;
    notifyListeners();
  }

  void setFilteringData(){

  }


}