import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/community/community_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_list_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/documents/car_documents_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/insurance/insurance.dart';
import 'package:mobile_auto_drive/ui/new_ui/more/more_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/payment_and_subscription/payment_sub_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/profile_screen.dart';
import 'package:mobile_auto_drive/utils/supported_countries.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/report_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/session.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MoreViewModel>.reactive(
      viewModelBuilder: () => MoreViewModel(),
      onViewModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) => Scaffold(
        appBar: appBarHeader(
            hasOnBack: false,
            context: context,
            appBarTitle: 'More',
            centerTitle: false
        ),
        backgroundColor: XColors.background(),
        body: SingleChildScrollView(
          child: Container(
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [
            //       XColors.primaryColor().withOpacity(0.05),
            //       XColors.background(),
            //     ],
            //   ),
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const YMargin(10),
                _buildCountryStrip(model),
                const YMargin(10),
                // Insurance only has providers in some markets; elsewhere the
                // banner would lead to an empty quote screen.
                if (model.offers(MarketFeature.insurance)) ...[
                  _buildInsuranceSection(model, context),
                  const YMargin(30),
                ],
                _buildMoreActions(context),
                const YMargin(30),
                _buildMenuSection(model, context),
                const YMargin(20),
            ],
          ),),
        ),
    ));
  }

  Widget _buildInsuranceSection(MoreViewModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GetPngImage(
                image: 'assets/images/motorby_toyo.png',
                width: MediaQuery.of(context).size.width,
                height: 150,
              ),
              Positioned(
                top: 45,
                bottom: 25,
                left: 14,
                right: 14,
                child: GestureDetector(
                  onTap: () {
                    navigate(context, const InsuranceScreen());
                  },
                  child: const AbsorbPointer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Car Insurance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Request quote',
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                                Icons.chevron_right,
                                color: Colors.white
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ]),
      );
  }

  Widget _buildMoreActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _buildQuickActionCard(
                icon: 'assets/images/new_car.svg',
                title: 'My Cars',
                subtitle: 'Manage your vehicles and track maintenance',
                color: Colors.blue,
                onTap: () {
                  navigate(context, const CarsListScreen());
                },
              ),
              const YMargin(12),
              _buildQuickActionCard(
                icon: 'assets/images/auto/file.svg',
                title: 'Documents',
                subtitle: 'Access and manage your vehicle documents',
                color: Colors.green,
                onTap: () {
                  navigate(context, const CarDocumentsScreen(showCarSelection: true));
                },
              ),
              const YMargin(12),
              _buildQuickActionCard(
                icon: 'assets/images/nav_icons/reminder.svg',
                title: 'Reminders',
                subtitle: 'Set and manage maintenance alerts and notifications',
                color: Colors.orange,
                onTap: () {
                  navigate(
                      context,
                      const ReminderScreen(isFromQuickActions: true,)
                  );
                },
              ),
              const YMargin(12),
              _buildQuickActionCard(
                icon: 'assets/images/user-group.svg',
                title: 'Community',
                subtitle: 'Join the motorby community and engage with others',
                color: Colors.green,
                onTap: () {
                  navigate(context, const CommunityScreen());
                },
              ),
              const YMargin(12),
              _buildQuickActionCard(
                icon: 'assets/images/scan.svg',
                title: 'VIN Checks',
                subtitle: 'Perform validity checks on your car and others',
                color: Colors.orange,
                onTap: () {

                  FloatingSnackBar.show(
                    context,
                    backgroundColor: XColors.primaryColor(),
                    'VIN check is coming soon',
                  );

                },
              ),
              const YMargin(12),
              _buildQuickActionCard(
                icon: 'assets/images/store.svg',
                title: 'Marketplace',
                subtitle: 'Buy and sell car easily and fast',
                color: Colors.purple,
                onTap: () {

                  FloatingSnackBar.show(
                    context,
                    backgroundColor: XColors.primaryColor(),
                    'Marketplace is coming soon',
                  );

                },
              ),
              const YMargin(12),
              _buildQuickActionCard(
                icon: 'assets/images/nav_icons/report.svg',
                title: 'Reports',
                subtitle: 'View detailed analytics and vehicle reports',
                color: Colors.purple,
                onTap: () {
                  navigate(
                      context,
                      const ReportScreen(isFromQuickActions: true)
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(MoreViewModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NormalText(
            text: 'Settings & More',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          _buildMenuItem(
            icon: 'assets/images/user_.svg',
            title: 'Profile',
            subtitle: model.locationLabel,
            onTap: () {
              navigate(context, const NewProfileScreen());
            },
          ),
          _buildMenuItem(
            icon: 'assets/images/auto/card.svg',
            title: 'Payment & Subscription',
            subtitle: model.billingLabel,
            onTap: () {
              navigate(context, const PaymentAndSubscriptionScreen());
            },
          ),
          // _buildMenuItem(
          //   icon: 'assets/images/settings.svg',
          //   title: 'Settings',
          //   subtitle: 'Customize your app preferences and notifications',
          //   onTap: () {
          //     // Navigate to settings
          //   },
          // ),
          // _buildMenuItem(
          //   icon: 'assets/images/user_.svg',
          //   title: 'Log Out',
          //   subtitle: 'Sign out of your account securely',
          //   textColor: Colors.red,
          //   onTap: () {
          //     _showLogoutDialog(context, model);
          //   },
          // ),
        ],
      ),
    );
  }

  /// Says which market the account is in, so a user never has to guess why a
  /// feature is missing or what currency they are about to be charged in.
  Widget _buildCountryStrip(MoreViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.public, size: 16, color: XColors.primaryColor()),
          const XMargin(8),
          NormalText(
            text: model.locationLabel,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            textColor: XColors.textColor(),
          ),
          const XMargin(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: XColors.primaryColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: NormalText(
              text: model.currencyCode,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              textColor: XColors.primaryColor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ContainerWidget(
        backgroundColor: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: GetSvgImage(
                image: icon,
                color: color,
                width: 20,
                height: 20,
              ),
            ),
            const XMargin(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    text: title,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  const YMargin(4),
                  NormalText(
                    text: subtitle,
                    fontSize: 12,
                    textColor: Colors.grey[600]!,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const XMargin(12),
            Icon(
              Icons.arrow_forward_ios,
              color: color.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    final color = textColor ?? XColors.primaryColor();
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ContainerWidget(
          backgroundColor: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: GetSvgImage(
                  image: icon,
                  color: color,
                  width: 20,
                  height: 20,
                ),
              ),
              const XMargin(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      text: title,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: color,
                    ),
                    const YMargin(4),
                    NormalText(
                      text: subtitle,
                      fontSize: 12,
                      textColor: Colors.grey[600]!,
                    ),
                  ],
                ),
              ),
              const XMargin(12),
              Icon(
                Icons.arrow_forward_ios,
                color: color.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
      ),
    ));
  }

  void _showLogoutDialog(BuildContext context, MoreViewModel model) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const NormalText(
          text: 'Log Out',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        content: const NormalText(
          text: 'Are you sure you want to log out of your account?',
          fontSize: 16,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: NormalText(
              text: 'Cancel',
              fontSize: 16,
              textColor: Colors.grey[600]!,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              logOutToSignIn(context);
            },
            child: const NormalText(
              text: 'Log Out',
              fontSize: 16,
              textColor: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}