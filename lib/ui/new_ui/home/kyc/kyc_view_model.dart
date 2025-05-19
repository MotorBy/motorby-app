import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/firebase_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class KYCViewModel extends BaseViewModel {
  final userService =  serviceLocator<UserService>();

  bool hasKycVerification = false;
  UserModel? userModel = serviceLocator<UserService>().userModel;

  dynamic filePickerResultMain;
  dynamic filePickerResultBack;

  void prefillUserData({
    required TextEditingController nameController,
    required TextEditingController nationalityController,
    required TextEditingController stateController,
    TextEditingController? dobController,
    TextEditingController? pobController,
    TextEditingController? ninController,
    TextEditingController? addressController,
    Function(String)? onGenderSelected,
  }) {
    if (userService.userModel?.payload?.user != null) {
      final user = userService.userModel!.payload!.user!;

      nameController.text = user.fullname ?? '';
      nationalityController.text = user.country ?? '';
      stateController.text = user.state ?? '';
      
      // Pre-fill additional KYC data if available
      if (userService.userModel!.payload!.user?.kycData != null) {
        addressController!.text = userService.userModel!.payload!.user?.kycData!.homeAddress ?? "";
        dobController?.text = userService.userModel!.payload!.user!.kycData!.dateOfBirth ?? "";
        pobController?.text = userService.userModel!.payload!.user!.kycData!.placeOfBirth ?? "";
        ninController?.text = userService.userModel!.payload!.user!.kycData!.documents![0].number ?? "";
        onGenderSelected!(userService.userModel!.payload!.user!.kycData!.gender ?? "Male");
      }

    }
  }

  // KYC Data Fields
  Map<String, dynamic> kycData = {
    'kyc_data': {
      'country': '',
      'name': '',
      'date_of_birth': '',
      'place_of_birth': '',
      'gender': '',
      'nationality': '',
      'documents': [{
        'type': 'national_id',
        'number': "",
        'url': '',
        'front': '',
        'back': '',
        'expiry_date': ""
      }]
    }
  };

  // KYC Data Handling
  Future<void> updateKycData({
    required String fullName,
    required String dateOfBirth,
    required String placeOfBirth,
    required String gender,
    required String nationality,
    required String nationalIdNumber,
    String? state,
    String? address,
    Function? onCallBack,
    Function(String? e)? onError,
  }) async {

    kycData['kyc_data']['country'] = nationality;
    kycData['kyc_data']['name'] = fullName;
    kycData['kyc_data']['date_of_birth'] = dateOfBirth;
    kycData['kyc_data']['place_of_birth'] = placeOfBirth;
    kycData['kyc_data']['gender'] = gender.toLowerCase();
    kycData['kyc_data']['nationality'] = nationality;
    kycData['kyc_data']['state'] = state;
    kycData['kyc_data']['address'] = address;
    kycData['kyc_data']['documents'][0]['number'] = nationalIdNumber;

    setBusy(true);

    await uploadDocument(front: true, onCallback: () {});
    await uploadDocument(front: false, onCallback: () async {

      await userService.updateUsers(data: kycData).then((v) {

        setBusy(false);
        userModel = userService.userModel;
        hasKycVerification = true;
        onCallBack?.call();

      }).onError((e, s) {
        print(s);
        setBusy(false);
        onError?.call(e.toString());
      });

    });

  }

  Future<void> pickDocument({ bool? front = true, Function? onComplete }) async {
    try {

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {

        if(onComplete != null) {
          if(front!) {
            filePickerResultMain = result;
          } else {
            filePickerResultBack = result;
          }
          onComplete();
        }

      }

    } catch (e) {
      print('Error uploading document: $e');
    }
  }

  Future<void> uploadDocument({ bool? front = true, Function? onCallback, Function(String e)? onError}) async {

    try {

      setBusyForObject('upload', true);

      await FirebaseService().uploadFileToStorage(
          storagePath: 'profile/kyc/${userService.userModel!.payload!.user?.userId}/${front == true ? filePickerResultMain!.files.single.name : filePickerResultBack!.files.single.name}',
          filePath: front == true ? filePickerResultMain!.files.single.path! : filePickerResultBack!.files.single.path!,
          onCallBack: (s) async {
            if(front!) {
              kycData['kyc_data']['documents'][0]['front'] = s;
              kycData['kyc_data']['documents'][0]['url'] = s;
            } else {
              kycData['kyc_data']['documents'][0]['back'] = s;
              kycData['kyc_data']['documents'][0]['url'] = s;
            }

            onCallback?.call();

          }
      );

    } catch (e) {
      print('Error uploading document: $e');

      setBusyForObject('upload', false);
      onError!.call(e.toString());
    }

  }

}