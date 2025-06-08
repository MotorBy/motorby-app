import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/kyc/kyc_verification_screen.dart';
import 'package:mobile_auto_drive/ui/profile/profile_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/image_handling.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, this.model});

  final ProfileViewModel? model;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  bool hasChanges = false;

  void initControllers(ProfileViewModel model) {

    firstNameController = TextEditingController(text: model.user?.firstname ?? '');
    middleNameController = TextEditingController(text: model.user?.firstname ?? '');
    lastNameController = TextEditingController(text: model.user?.lastname ?? '');
    phoneController = TextEditingController(text: model.user?.email ?? '');

    void onChanged() {
      if (!mounted) return;
      setState(() {
        hasChanges = firstNameController.text != (model.user?.firstname ?? '') ||
                    middleNameController.text != (model.user?.firstname ?? '') ||
                    lastNameController.text != (model.user?.lastname ?? '');
      });
    }

    firstNameController.addListener(onChanged);
    middleNameController.addListener(onChanged);
    lastNameController.addListener(onChanged);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => widget.model ?? ProfileViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) {
          initControllers(model);
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: appBarHeader(
              hasOnBack: true,
              onCloseAction: () {
                Navigator.pop(context);
              },
              appBarTitle: 'Edit profile',
            ),
            backgroundColor: XColors.background(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ////profile image section
                  GestureDetector(
                    onTap: () {
                      pickImage(
                        allowCropping: true,
                        onCallBack: (imagePath) {
                          if (imagePath != null) {
                            model.updateProfileImage(imagePath);
                            setState(() {
                              hasChanges = true;
                            });
                          }
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: model.profileImagePath != null
                              ? FileImage(File(model.profileImagePath!))
                              : null,
                          child: model.profileImagePath == null
                              ? Icon(Icons.person, size: 30, color: XColors.primaryColor2())
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 5,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: XColors.white(),
                              shape: BoxShape.circle,
                            ),
                            child: const GetSvgImage(image: 'assets/images/Camera.svg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const YMargin(56),
                  MainInputField(
                    label: 'First Name',
                    controller: firstNameController,
                    isEnabled: true,
                  ),
                  const YMargin(16),
                  MainInputField(
                    label: 'Middle Name',
                    controller: middleNameController,
                    isEnabled: true,
                  ),
                  const YMargin(16),
                  MainInputField(
                    label: 'Last Name',
                    controller: lastNameController,
                    isEnabled: true,
                  ),
                  const YMargin(16),
                  MainInputField(
                    label: 'Phone number',
                    controller: phoneController,
                    isEnabled: false,
                  ),
                  const YMargin(16),
                  ContainerWidget(
                    onTap: hasChanges ? () {
                      model.updateData = {
                        'firstname': firstNameController.text,
                        'middlename': middleNameController.text,
                        'lastname': lastNameController.text,
                      };
                      model.updateUserTypeProfile(
                        onCallBack: () {
                          Navigator.pop(context);
                        },
                      );
                    } : null,
                    backgroundColor: hasChanges ? XColors.primaryColor2() : Colors.grey,
                    borderRadius: BorderRadius.circular(26),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    width: double.infinity,
                    child: Center(
                        child: NormalText(
                      text: 'Update profile',
                      textColor: XColors.white(),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
                  ),
                  const YMargin(30),
                  ContainerWidget(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KYCVerificationScreen(),
                        ),
                      );
                    },
                    backgroundColor: XColors.white(),
                    borderRadius: BorderRadius.circular(8),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NormalText(
                              text: 'KYC Verification',
                              textColor: XColors.black(),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            const YMargin(4),
                            NormalText(
                              text: 'Update your verification details',
                              textColor: XColors.primaryColor().withOpacity(0.4),
                              fontSize: 14,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: XColors.primaryColor().withOpacity(0.4),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }
}
