import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/main.dart';
import 'package:mobile_auto_drive/services/device_info.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_list_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/documents/car_documents_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/edit_profile.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/payment_and_subscription/payment_sub_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/referral/referral_screen.dart';
import 'package:mobile_auto_drive/ui/profile/profile_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
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
          actions: [
            PopupMenuButton<int>(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  onTap: (){
                    navigate(context, EditProfileScreen(model: model));
                  },
                  child: const NormalText(
                    text: 'Edit Profile',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // const PopupMenuItem<int>(
                //   value: 0,
                //   child: NormalText(
                //     text: 'Settings',
                //     fontSize: 12,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                PopupMenuItem<int>(
                  value: 1,
                  onTap: () {

                    model.logOut().then((value) {
                      popToFirst(context);
                      navigateReplace(context, const MyApp(
                        isAuthed: false,
                        isOnboarded: false,
                      ));
                    });

                  },
                  child: const NormalText(
                    text: 'Log out',
                    fontSize: 12,
                    textColor: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              onSelected: (val) {

              },
            ),
          ]
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
        // Stack(
        //   children: [
        //     CircleAvatar(
        //       radius: 30,
        //       backgroundImage: AssetImage(model.profileImage),
        //     ),
        //     Positioned(
        //       right: 0,
        //       bottom: 5,
        //       child: Container(
        //         width: 16,
        //         height: 16,
        //         decoration: BoxDecoration(
        //           color: Colors.green,
        //           shape: BoxShape.circle,
        //           border: Border.all(
        //             color: Colors.white,
        //             width: 2,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
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
            navigate(context!, const CarDocumentsScreen(isFromProfile: true,));
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
      ],
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
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
    );
  }
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
