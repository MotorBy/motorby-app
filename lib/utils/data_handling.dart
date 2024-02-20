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