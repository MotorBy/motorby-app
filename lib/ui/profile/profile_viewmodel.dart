import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:stacked/stacked.dart';

import '../../services/user_service.dart';
import '../../utils/locator_setup.dart';

class ProfileViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();

  UserModel? userModel;
  Payload? user;

  Future init() async {

    if(userService.userModel != null) {
      userModel = userService.userModel;
      user = userModel!.payload;
    } else {
      await userService.getUsers();
      userModel = userService.userModel;
      user = userModel!.payload;
    }

    notifyListeners();

  }

}