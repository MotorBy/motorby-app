import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/main.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/kyc/kyc_verification_screen.dart';
import 'package:mobile_auto_drive/ui/profile/profile_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/search_address_map.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/supported_countries.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/phone_field.dart';
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

  /// Read off the phone number's dial code, never picked directly. Changing
  /// the number is how a user moves country, and the billing currency follows.
  late SupportedCountry country;

  /// What the profile looked like when the form opened, so the save button
  /// only lights up on a real change.
  late String _initialPhone;
  late String _initialCountry;
  late String _initialFirstName;
  late String _initialLastName;
  late String _initialState;
  late String _initialAddress;

  bool hasChanges = false;

  void initControllers(ProfileViewModel model) {

    final user = model.currentUser;

    firstNameController = TextEditingController(text: user?.firstname ?? '');
    // There is no middlename on the profile yet; it used to be seeded with the
    // first name, which just looked like a bug to anyone opening the form.
    middleNameController = TextEditingController(text: '');
    lastNameController = TextEditingController(text: user?.lastname ?? '');
    stateController = TextEditingController(text: user?.state ?? '');
    addressController = TextEditingController(text: user?.address ?? '');

    // Numbers are stored in E.164 (+2348031234567). Split the dial code back
    // out so the picker shows the right flag and the field the local number.
    final stored = user?.phonenumber ?? '';
    country = countryFromDialCode(stored) ?? countryByName(user?.country);
    phoneController =
        TextEditingController(text: stripDialCode(stored, country));

    _initialPhone = phoneController.text;
    _initialCountry = country.name;
    _initialFirstName = firstNameController.text;
    _initialLastName = lastNameController.text;
    _initialState = stateController.text;
    _initialAddress = addressController.text;

    firstNameController.addListener(recheckChanges);
    middleNameController.addListener(recheckChanges);
    lastNameController.addListener(recheckChanges);
    stateController.addListener(recheckChanges);
    addressController.addListener(recheckChanges);
  }

  void recheckChanges() {
    if (!mounted) return;
    setState(() {
      hasChanges = firstNameController.text != _initialFirstName ||
          lastNameController.text != _initialLastName ||
          middleNameController.text.isNotEmpty ||
          stateController.text != _initialState ||
          addressController.text != _initialAddress ||
          phoneController.text != _initialPhone ||
          country.name != _initialCountry;
    });
  }

  /// Opens the map picker and fills in whatever it hands back.
  ///
  /// The picker returns the state alongside the address, so choosing a place
  /// fills both rather than leaving the user to retype one of them.
  Future<void> pickAddressOnMap() async {
    final picked = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchAddressMap(viewModel: null),
      ),
    );

    if (picked == null || !mounted) return;

    setState(() {
      final address = picked['address'];
      if (address != null && '$address'.isNotEmpty) {
        addressController.text = '$address';
      }
      final state = picked['state'];
      if (state != null && '$state'.isNotEmpty) {
        stateController.text = '$state';
      }
    });
    recheckChanges();
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

  /// Explains why there is no country field: it follows the dial code, and it
  /// decides what currency the account is billed in.
  Widget _buildCountryHint() {
    return Row(
      children: [
        Icon(Icons.info_outline, size: 15, color: XColors.primaryColor()),
        const XMargin(6),
        Expanded(
          child: NormalText(
            text: '${country.name} \u00b7 billed in ${country.currencyCode}. '
                'Change the dial code to move country.',
            fontSize: 12,
            textColor: Colors.grey[600]!,
            maxLines: 2,
          ),
        ),
      ],
    );
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
                  // The dial code is the only way to change country, so the
                  // number is editable here.
                  PhoneNumberField(
                    controller: phoneController,
                    initialCountry: country,
                    onChanged: (picked, number) {
                      country = picked;
                      recheckChanges();
                    },
                  ),
                  const YMargin(8),
                  _buildCountryHint(),
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
                    hint: 'Type it, or tap the pin to choose on the map',
                    suffixIcon: GestureDetector(
                      onTap: pickAddressOnMap,
                      child: Icon(
                        Icons.pin_drop_outlined,
                        size: 22,
                        color: XColors.primaryColor(),
                      ),
                    ),
                  ),
                  const YMargin(16),
                  XButton(
                    onPressed: hasChanges ? () {

                      model.updateData = {
                        'firstname': firstNameController.text,
                        'middlename': middleNameController.text,
                        'lastname': lastNameController.text,
                        'phonenumber': country.e164(phoneController.text),
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
                  const YMargin(20),
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
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            const YMargin(4),
                            NormalText(
                              text: 'Update your verification details',
                              textColor: XColors.primaryColor().withOpacity(0.4),
                              fontSize: 12,
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
                  // Separate from logging out, and deliberately quieter: leaving for
                  // good is a different decision from signing off.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _confirmAccountDeletion(context, model);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const NormalText(
                                        text: 'Request account deletion',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        textColor: Colors.red,
                                      ),
                                      const SizedBox(height: 2),
                                      NormalText(
                                        text: 'Removes your account and everything on it',
                                        fontSize: 12,
                                        textColor: Colors.grey[600]!,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, size: 20, color: Colors.black38),
                              ],
                            ),
                          ),
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


  /// Second gate on deletion. Spells out that it takes the cars and documents
  /// with it, and makes the destructive choice the deliberate one.
  void _confirmAccountDeletion(BuildContext context, ProfileViewModel model) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: const NormalText(
          text: 'Delete your account?',
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
        content: NormalText(
          text: 'We will remove your account along with your cars, documents, '
              'reminders and spending history. This cannot be undone, and you '
              'will be signed out now.',
          fontSize: 14,
          textColor: Colors.grey[700]!,
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: NormalText(
              text: 'Keep my account',
              fontSize: 15,
              textColor: Colors.grey[700]!,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              model.requestAccountDeletion(
                onCallBack: () {
                  popToFirst(context);
                  navigateReplace(context, const MyApp(
                    isAuthed: false,
                    isOnboarded: false,
                  ));
                },
                onErrorBack: (e) {
                  FloatingSnackBar.show(
                    context,
                    e ?? 'Could not send your request. Please try again.',
                    isError: true,
                  );
                },
              );
            },
            child: const NormalText(
              text: 'Delete account',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              textColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

}
