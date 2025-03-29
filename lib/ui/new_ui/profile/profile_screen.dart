import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/edit_profile.dart';
import 'package:mobile_auto_drive/ui/profile/profile_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class NewProfileScreen extends StatelessWidget {
  const NewProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFFF8F2FF),
        appBar: AppBar(
          backgroundColor: XColors.background(),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const NormalText(
            text: 'Profile',
            textColor: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          actions: [
            PopupMenuButton<int>(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: NormalText(
                    text: 'Edit Profile',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  onTap: (){

                    model.logOut().then((value) {
                      popToFirst(context);
                      navigateReplace(context, SignInScreen());
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
                navigate(context, const EditProfileScreen());
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildProfileHeader(model),
                const SizedBox(height: 24),
                _buildCarsCard(model),
                const SizedBox(height: 24),
                _buildMenuItems(model),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileViewModel model) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(model.profileImage),
            ),
            Positioned(
              right: 0,
              bottom: 5,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        NormalText(
          text: model.name,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 4),
        Text(
          model.email,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 16),
        if (!model.isPremium)
          OutlinedButton(
            onPressed: (){},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
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

  Widget _buildCarsCard(ProfileViewModel model) {
    return GestureDetector(
      onTap: (){},
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

  Widget _buildMenuItems(ProfileViewModel model) {
    return Column(
      children: [
        _buildMenuItem(
          icon: 'assets/images/auto/card.svg',
          title: 'Payment and subscription',
          onTap: (){},
        ),
        const DividerWidget(),
        _buildMenuItem(
          icon: 'assets/images/auto/file.svg',
          title: 'My documents',
          onTap: (){},
        ),
        const DividerWidget(),
        _buildMenuItem(
          icon: 'assets/images/auto/user-group.svg',
          title: 'Referral and earning',
          onTap: (){},
        ),
        const DividerWidget(),
        _buildMenuItem(
          icon: 'assets/images/auto/settings.svg',
          title: 'Settings',
          onTap: (){},
        ),
        const DividerWidget(),
        _buildMenuItem(
          icon: 'assets/images/auto/settings.svg',
          title: 'Set up business profile',
          onTap: (){},
        ),
        const DividerWidget(),
        _buildMenuItem(
          icon: 'assets/images/auto/about_icon.svg',
          title: 'About app',
          onTap: (){},
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
