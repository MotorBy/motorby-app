import 'package:intl/intl.dart';

final oCcy = NumberFormat("#,##0", "en_US");


String amtFormatter(int? value) {
  return oCcy.format(value).toString();
}

Map<String, dynamic>? formatObject(Map<String, dynamic>? Obj) {

  Map<String, dynamic> newObj = {};
  Map<String, dynamic> ObjectF = Obj!;

  ObjectF.removeWhere((key, value) => value == null);
  newObj = ObjectF;

  return newObj;
}

String numberFormat({double? number}){
  if(number == 0) {
    return '0';
  } else {
    NumberFormat numberFormat = NumberFormat('#,##,000');
    return numberFormat.format(number);
  }

}


List<String>? carMakeDataList = [
  "Audi",
  "Chevrolet",
  "Cadillac",
  "Acura",
  "BMW",
  "Chrysler",
  "Ford",
  "INFINITI",
  "GMC",
  "Honda",
  "Hyundai",
  "Jeep",
  "Genesis",
  "Dodge",
  "Jaguar",
  "Kia",
  "Land Rover",
  "Lexus",
  "Mercedes-Benz",
  "Mitsubishi",
  "Lincoln",
  "MAZDA",
  "Nissan",
  "Porsche",
  "Subaru",
  "Toyota",
  "Volkswagen",
  "Volvo",
  "Tesla",
  "Lotus",
  "Rolls-Royce",
  "SRT",
  "Suzuki",];