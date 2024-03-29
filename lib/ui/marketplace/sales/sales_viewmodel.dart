import 'package:mobile_auto_drive/models/sales_model.dart';
import 'package:mobile_auto_drive/services/sales_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class SalesViewModel extends BaseViewModel {
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

      setBusyForObject('sales-loading', true);
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

  void setCurrentSale(SalesModel? s){
    currentSalesModel = s;
    notifyListeners();
  }

  Future reloadSales() async {
    setBusyForObject('sales-loading', true);

    await salesService.getSales(carMake: carMake).then((value) {
      setBusyForObject('sales-loading', false);
    }).onError((error, stackTrace) {
      setBusyForObject('sales-loading', false);
      setError(error!.toString());
    });
    salesListModel = salesService.salesListModel;
    notifyListeners();
  }

}