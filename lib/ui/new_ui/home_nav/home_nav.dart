import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/home/home_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav_vmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/quick_actions/quick_actions_bottom_sheet.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/report_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:stacked/stacked.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {}
      },
      child: ViewModelBuilder<DashboardViewModel>.reactive(
        viewModelBuilder: () => DashboardViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: XColors.background(),
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                model.changeTabIndex(index);
              },
              children: [
                const NewHomeScreen(),
                const ReportScreen(),
                Container(),
                const ReminderScreen(),
                const MapScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavbar(
              onTap: (index) {
                _pageController.animateToPage(
                  index, duration: const Duration( milliseconds: 10 ), // Increase duration for smooth animation
                  curve: Curves.easeInOut,
                );
                model.changeTabIndex(index); // Update the active tab index
              },
              model: model, // Pass the ViewModel instance
            ),
          );
        },
      ),
    );
  }
}

class BottomNavbar extends StatelessWidget {
  final Function(int) onTap;
  final DashboardViewModel model; // Accept ViewModel instance

  const BottomNavbar({super.key, required this.onTap, required this.model});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: "Home",
          icon: const GetSvgImage(
            image: 'assets/images/home_in_active.svg',
          ),
          activeIcon: const GetSvgImage(
            image: 'assets/images/active_homr.svg',
          ),
          backgroundColor: XColors.background(),
        ),
        BottomNavigationBarItem(
          label: "Report",
          activeIcon: const GetSvgImage(
            image: 'assets/images/report_active.svg',
          ),
          icon: const GetSvgImage(
            image: 'assets/images/inactive_report.svg',
          ),
          backgroundColor: XColors.background(),
        ),
        const BottomNavigationBarItem(
            label: '',
            activeIcon: GetSvgImage(
              image: 'assets/images/primary_button.svg',
            ),
            icon: GetSvgImage(
              image: 'assets/images/primary_button.svg',
            ),
        ),
        BottomNavigationBarItem(
          label: "Reminder",
          activeIcon: const GetSvgImage(
            image: 'assets/images/remider_inactive.svg',
          ),
          icon: const GetSvgImage(
            image: 'assets/images/remider_inactive.svg',
          ),
          backgroundColor: XColors.background(),
        ),
        BottomNavigationBarItem(
          label: "Map",
          activeIcon: const GetSvgImage(
            image: 'assets/images/map_inactive.svg',
          ),
          icon: const GetSvgImage(
            image: 'assets/images/map_inactive.svg',
          ),
          backgroundColor: XColors.background(),
        ),
      ],
      currentIndex: model.currentindex, // Ensure the index updates
      selectedItemColor: XColors.black(),
      selectedFontSize: 12.0,
      backgroundColor: XColors.background(),
      unselectedItemColor: XColors.textColor(),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: model.currentindex == 2 ? false : true,
      showUnselectedLabels: true,
      onTap: (index) {
        if (index == 2) {
          // Show quick actions bottom sheet when center button is tapped
          modalBottomSheetMenu(
            context: context,
            radius: 24,
            child: const QuickActionsBottomSheet(),
          );
        } else {
          onTap(index); // Call the original onTap for other tabs
        }
      },
    );
  }
}
