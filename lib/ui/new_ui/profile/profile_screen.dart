import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFFF8F2FF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                // TODO: Implement menu options
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
              radius: 50,
              backgroundImage: AssetImage(model.profileImage),
            ),
            Positioned(
              right: 0,
              bottom: 0,
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
        Text(
          model.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          model.email,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 16),
        if (!model.isPremium)
          OutlinedButton(
            onPressed: model.upgradeAccount,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: const BorderSide(color: Color(0xFF7B61FF)),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
            ),
            child: const Text(
              'Upgrade',
              style: TextStyle(
                color: Color(0xFF7B61FF),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCarsCard(ProfileViewModel model) {
    return GestureDetector(
      onTap: model.navigateToMyCars,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFF7B61FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/car_illustration.png',
                height: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cars',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Text(
                        'View my cars',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(ProfileViewModel model) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.credit_card,
          title: 'Payment and subscription',
          onTap: model.navigateToPaymentAndSubscription,
        ),
        _buildMenuItem(
          icon: Icons.description,
          title: 'My documents',
          onTap: model.navigateToMyDocuments,
        ),
        _buildMenuItem(
          icon: Icons.people,
          title: 'Referral and earning',
          onTap: model.navigateToReferralAndEarning,
        ),
        _buildMenuItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: model.navigateToSettings,
        ),
        _buildMenuItem(
          icon: Icons.business,
          title: 'Set up business profile',
          onTap: model.navigateToBusinessProfile,
        ),
        _buildMenuItem(
          icon: Icons.info,
          title: 'About app',
          onTap: model.navigateToAboutApp,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.black54,
      ),
    );
  }
}
