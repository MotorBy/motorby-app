import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_auto_drive/services/auth_service.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/checklist_service.dart';
import 'package:mobile_auto_drive/services/community_service.dart';
import 'package:mobile_auto_drive/services/insurance_service.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/places_services.dart';
import 'package:mobile_auto_drive/services/sales_service.dart';
import 'package:mobile_auto_drive/services/shop_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/services/vin_check_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

final GetIt serviceLocator = GetIt.I;

Future locatorSetup() async {

  Future<PackageInfo> packageInfo() async => await PackageInfo.fromPlatform();

  WidgetsFlutterBinding.ensureInitialized();
  serviceLocator.registerLazySingleton(() => PersistenceService());
  serviceLocator.registerLazySingleton(() => AuthService());
  serviceLocator.registerLazySingleton(() => UserService());
  serviceLocator.registerLazySingleton(() => SalesService());
  serviceLocator.registerLazySingleton(() => ShopService());
  serviceLocator.registerLazySingleton(() => CommunityService());
  serviceLocator.registerLazySingleton(() => BudgetingService());
  serviceLocator.registerLazySingleton(() => AppPaymentService());
  serviceLocator.registerLazySingleton(() => VinCheckService());
  serviceLocator.registerLazySingleton(() => ChecklistService());
  serviceLocator.registerLazySingleton(() => PlacesService());
  serviceLocator.registerLazySingleton(() => InsuranceService());


}
