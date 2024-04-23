import 'package:mobile_auto_drive/models/sales_model.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
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

  UserModel? userModel;

  bool? hasData = false;

  bool? isBusiness;

  Future getAllSales() async {
    carMake = salesService.currentCarMake;
    isBusiness = userService.isBusiness;

    userModel = userService.userModel;

    if(salesService.salesListModel == null) {

      setBusyForObject('sales-loading', true);
      reloadSales();

    } else {

      if(salesService.salesListModel!.payload!.isNotEmpty) {
        hasData = true;
        if(salesService.salesListModel!.payload![0].carDetails!.carMake == carMake) {
          salesListModel = salesService.salesListModel;
          notifyListeners();
        } else {
          hasData = false;
          reloadSales();
        }
      } else {
        reloadSales();
      }

    }
  }

  void setCurrentSale(SalesModel? s){
    currentSalesModel = s;
    salesService.currentSalesModel = currentSalesModel;
    notifyListeners();
  }

  void updateCurrentSale({Map<String, dynamic>? updateData, String? updateType}) async {

    setBusyForObject('sales-updating', true);

    if(updateType == 'isSold') {
      updateData = {
        'sales_details' : {
          'is_sold' : true
        }
      };
    }

    await salesService.updateSales(salesData: updateData, salesId: currentSalesModel!.sId).then((value) {
      setBusyForObject('sales-updating', false);

      currentSalesModel = salesService.currentSalesModel;
      print(currentSalesModel!.toJson().toString());
      notifyListeners();

    }).onError((error, stackTrace) {
      print(stackTrace.toString());
      setBusyForObject('sales-updating', false);
      setError(error!.toString());
    });

  }

  Future reloadSales() async {
    setBusyForObject('sales-loading', true);

    await salesService.getSales(carMake: carMake).then((value) {
      setBusyForObject('sales-loading', false);

      if(salesService.salesListModel!.payload!.isNotEmpty){
        hasData = true;
      }

    }).onError((error, stackTrace) {
      print(stackTrace.toString());
      setBusyForObject('sales-loading', false);
      setError(error!.toString());
    });
    salesListModel = salesService.salesListModel;
    notifyListeners();
  }

  bool isSalesMaker(){
    return currentSalesModel!.by! == userModel!.payload!.referralProfile!.userId;
  }

}