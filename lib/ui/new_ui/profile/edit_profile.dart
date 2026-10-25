import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/kyc/kyc_verification_screen.dart';
import 'package:mobile_auto_drive/ui/profile/profile_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/supported_countries.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/image_handling.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
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
  late TextEditingController stateController;
  late TextEditingController addressController;

  /// Drives both the country field and, through it, the billing currency.
  late SupportedCountry country;

  bool hasChanges = false;

  void initControllers(ProfileViewModel model) {

    firstNameController = TextEditingController(text: model.currentUser?.firstname ?? '');
    middleNameController = TextEditingController(text: model.currentUser?.firstname ?? '');
    lastNameController = TextEditingController(text: model.currentUser?.lastname ?? '');
    phoneController = TextEditingController(text: model.currentUser?.phonenumber ?? '');
    stateController = TextEditingController(text: model.currentUser?.state ?? '');
    addressController = TextEditingController(text: model.currentUser?.address ?? '');

    country = countryByName(model.currentUser?.country);

    void onChanged() {
      if (!mounted) return;
      setState(() {
        hasChanges = firstNameController.text != (model.currentUser?.firstname ?? '') ||
                    middleNameController.text != (model.currentUser?.firstname ?? '') ||
                    lastNameController.text != (model.currentUser?.lastname ?? '') ||
                    stateController.text != (model.currentUser?.state ?? '') ||
                    addressController.text != (model.currentUser?.address ?? '') ||
                    country.name != countryByName(model.currentUser?.country).name;
      });
    }

    firstNameController.addListener(onChanged);
    middleNameController.addListener(onChanged);
    lastNameController.addListener(onChanged);
    stateController.addListener(onChanged);
    addressController.addListener(onChanged);
  }

  void pickCountry(ProfileViewModel model) {
    listHelperPicker(
      height: 320,
      context: context,
      title: 'Country',
      listString: kSupportedCountries.map((c) => c.name).toList(),
      selected: (s) {
        setState(() {
          country = kSupportedCountries.firstWhere((c) => c.name == s);
          hasChanges = true;
        });
      },
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    stateController.dispose();
    addressController.dispose();
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
            // The form outgrew a single screen once country, state and
            // address were added, so it scrolls.
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
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
                  const YMargin(32),
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
                  // Country decides which currency this account is billed in,
                  // so show that alongside the name rather than surprising
                  // the user at checkout.
                  MainInputField(
                    label: 'Country',
                    isEnabled: false,
                    controller: TextEditingController(
                        text: '${country.name}  (${country.currencyCode})'),
                    suffixIcon: GestureDetector(
                      onTap: () => pickCountry(model),
                      child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21),
                    ),
                  ),
                  const YMargin(16),
                  MainInputField(
                    label: 'State',
                    controller: stateController,
                    isEnabled: true,
                  ),
                  const YMargin(16),
                  MainInputField(
                    label: 'Current address',
                    controller: addressController,
                    isEnabled: true,
                    maxLines: 2,
                  ),
                  const YMargin(16),
                  XButton(
                    onPressed: hasChanges ? () {

                      model.updateData = {
                        'firstname': firstNameController.text,
                        'middlename': middleNameController.text,
                        'lastname': lastNameController.text,
                        'country': country.name,
                        'state': stateController.text,
                        'address': addressController.text,
                      };
                      model.updateUserTypeProfile(
                        onCallBack: () {
                          setState(() {
                            hasChanges = false;
                          });
                          Navigator.pop(context);
                        },
                      );
                    } : null,
                    text: 'Update profile',
                    isLoading: model.busy('user_type_loading'),
                    buttonColor: hasChanges ? XColors.primaryColor() : Colors.grey,
                    width: 120,
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
