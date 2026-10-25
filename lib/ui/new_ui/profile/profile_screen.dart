import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/main.dart';
import 'package:mobile_auto_drive/services/device_info.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_list_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/documents/car_documents_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/edit_profile.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/payment_and_subscription/payment_sub_screen.dart';
import 'package:mobile_auto_drive/ui/profile/profile_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/divider_widget.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import 'payment_and_subscription/subscription_view.dart';

class NewProfileScreen extends StatelessWidget {
  const NewProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onViewModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: XColors.white(),
        appBar: appBarHeader(
            hasOnBack: true,
            context: context,
          appBarTitle: 'Profile',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              children: [
                _buildProfileHeader(model, context: context),
                const SizedBox(height: 44),
                _buildCarsCard(model, context: context),
                const SizedBox(height: 44),
                _buildMenuItems(model, context: context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileViewModel model, {BuildContext? context}) {
    return Column(
      children: [
        const SizedBox(height: 16),
        NormalText(
          text: model.user != null ? model.user!.fullname : "",
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 4),
        Text(
          model.user != null ? model.user!.email! : '',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 16),
        if (!model.isPro)
          OutlinedButton(
            onPressed: (){
              navigateWithCallBack(
                  context!, const SubscriptionView(),
                  onCallBack: (value) {
                    if (value != null) {
                      model.init();
                    }
                  },
              );
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              side: BorderSide(color: XColors.borderColor()),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
            ),
            child: const NormalText(
              text: 'Upgrade',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildCarsCard(ProfileViewModel model, {BuildContext? context}) {
    return GestureDetector(
      onTap: (){
        navigate(context!, const CarsListScreen());
      },
      child: const Stack(
        children: [
          GetPngImage(image: 'assets/images/motorby_toyo.png'),
          Positioned(
            top: 35,
            left: 14,
            child: AbsorbPointer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cars',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'View my Cars',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItems(ProfileViewModel model, {BuildContext? context}) {

    PackageInfo? packageInfo;

    ValueNotifier<String> packageInfoValueState = ValueNotifier("");
    ValueNotifier<String> deviceCate = ValueNotifier("");

    DeviceService().getPackageData().then((_packageInfo) {
      packageInfo = _packageInfo;
      packageInfoValueState.value = packageInfo!.version;
    });

    DeviceService().getDeviceData().then((d) {
      if(d['deviceCategory'] != null) {
        deviceCate.value = d['deviceCategory'];
      }
    });

    return Column(
      children: [
        _buildMenuItem(
          icon: 'assets/images/user_.svg',
          title: 'Edit profile',
          subtitle: 'Name, phone number and address',
          onTap: (){
            navigate(context!, EditProfileScreen(model: model));
          },
        ),
        const DividerWidget(),
        _buildMenuItem(
          icon: 'assets/images/auto/card.svg',
          title: 'Payment and subscription',
          onTap: (){
            navigate(context!, const PaymentAndSubscriptionScreen());
          },
        ),
        const DividerWidget(),
        _buildMenuItem(
          icon: 'assets/images/auto/file.svg',
          title: 'My documents',
          onTap: (){
            navigate(context!, const CarDocumentsScreen(showCarSelection: true,));
          },
        ),
        // const DividerWidget(),
        // _buildMenuItem(
        //   icon: 'assets/images/auto/user-group.svg',
        //   title: 'Referral and earning',
        //   onTap: (){
        //     navigate(context!, const ReferralScreen());
        //   },
        // ),
        const DividerWidget(),
        _buildMenuItem(
          icon: 'assets/images/auto/about_icon.svg',
          title: 'About app',
          onTap: () {
            showModalBottomSheet(
              context: context!,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const NormalText(
                      text: 'MotorBy',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                   ValueListenableBuilder<String>(
                      valueListenable: packageInfoValueState,
                     builder: (context, value, c) {
                       return NormalText(
                          text: 'Version ${value ?? "1.0.0"}',
                          fontSize: 16,
                          textColor: Colors.grey,
                        );
                     }
                   ),
                    const SizedBox(height: 24),
                    const NormalText(
                      text: 'Connect with us',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 24),
                  const NormalText(
                    text: 'MotorBy is your comprehensive auto companion, designed to help you manage your vehicles, track expenses, set reminders, and stay on top of your automotive needs.',
                    fontSize: 13,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500,
                  ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialLink(
                          icon: Icons.language,
                          label: 'Website',
                          onTap: () async {

                            canLaunch('https://motorby.co').then((value) async {
                              if (deviceCate.value != 'IOS' ? !value : value) {
                                await launch(
                                  'https://motorby.co',
                                  universalLinksOnly: true,
                                );
                              }
                            });

                          },
                        ),
                        // _buildSocialLink(
                        //   icon: Icons.facebook,
                        //   label: 'Facebook',
                        //   onTap: () async {
                        //     final Uri url = Uri.parse('https://facebook.com/motorby');
                        //     // if (await canLaunchUrl(url)) {
                        //     //   await launchUrl(url);
                        //     // }
                        //   },
                        // ),
                        // _buildSocialLink(
                        //   icon: Icons.messenger,
                        //   label: 'Twitter',
                        //   onTap: () async {
                        //     final Uri url = Uri.parse('https://twitter.com/motorby');
                        //     // if (await canLaunchUrl(url)) {
                        //     //   await launchUrl(url);
                        //     // }
                        //   },
                        // ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const NormalText(
                      text: '© 2024 MotorBy. All rights reserved.',
                      fontSize: 14,
                      textColor: Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const DividerWidget(),
        ListTile(
          onTap: () => _showLogOutSheet(context!, model),
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.logout_rounded, color: Colors.red, size: 22),
          title: const NormalText(
            text: 'Log out',
            fontSize: 14,
            textColor: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
        const DividerWidget(),
      ],
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: GetSvgImage(image: icon, color: Colors.black54),
      title: NormalText(
        text: title,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      subtitle: subtitle == null
          ? null
          : NormalText(
              text: subtitle,
              fontSize: 12,
              textColor: Colors.grey[600]!,
            ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.black38),
    );
  }
}

/// Prompts before signing out, and offers the way out for people who are
/// leaving for good rather than just signing off.
void _showLogOutSheet(BuildContext context, ProfileViewModel model) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 44,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const NormalText(
              text: 'Log out?',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            NormalText(
              text: 'Your cars, documents and reminders stay on your account. '
                  'You will need to sign in again to reach them.',
              fontSize: 14,
              textColor: Colors.grey[600]!,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            XButton(
              onPressed: () {
                Navigator.pop(sheetContext);
                model.logOut().then((value) {
                  // logOut resets the locator, so bail if the screen went away
                  // while it was running.
                  if (!context.mounted) return;
                  popToFirst(context);
                  navigateReplace(context, const MyApp(
                    isAuthed: false,
                    isOnboarded: false,
                  ));
                });
              },
              text: 'Log out',
              buttonColor: Colors.red,
              textColor: Colors.white,
              height: 50,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(sheetContext),
              child: NormalText(
                text: 'Cancel',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                textColor: Colors.grey[700]!,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: DividerWidget(),
            ),
            // Separate from logging out, and deliberately quieter: leaving for
            // good is a different decision from signing off.
            NormalText(
              text: 'Leaving for good?',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              textColor: Colors.grey[700]!,
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                Navigator.pop(sheetContext);
                _confirmAccountDeletion(context, model);
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline, size: 19, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const NormalText(
                            text: 'Request account deletion',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
    ),
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

Widget _buildSocialLink({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24),
        ),
        const SizedBox(height: 8),
        NormalText(
          text: label,
          fontSize: 12,
          textColor: Colors.grey[700]!,
        ),
      ],
    ),
  );
}
